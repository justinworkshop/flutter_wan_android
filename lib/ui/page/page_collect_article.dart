import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterwanandroid/event/event_collect.dart';
import 'package:flutterwanandroid/http/api.dart';
import 'package:flutterwanandroid/manager/app_manager.dart';
import 'package:flutterwanandroid/ui/widget/item_article.dart';

class ArticleCollectPage extends StatefulWidget {
  @override
  _ArticleCollectPageState createState() => _ArticleCollectPageState();
}

class _ArticleCollectPageState extends State<ArticleCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;
  ScrollController _controller = ScrollController();

  List _collects = [];
  var curPage = 0;
  var pageCount = 0;
  StreamSubscription<CollectEvent> collectEventListen;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && curPage < pageCount) {
        _getCollects();
      }
    });

    collectEventListen = AppManager.eventBus.on<CollectEvent>().listen((event) {
      if (mounted) {
        if (!event.collect) {
          _collects.removeWhere((element) {
            return element['id'] == event.id;
          });
        }
      }
    });

    _getCollects();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isHidden,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Offstage(
          offstage: _collects.isNotEmpty || !_isHidden,
          child: Center(
            child: Text("没有收藏内容"),
          ),
        ),
        Offstage(
          offstage: _collects.isEmpty,
          child: RefreshIndicator(
            onRefresh: () => _getCollects(true),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _collects.length,
              itemBuilder: (context, i) => _buildItem(i),
              controller: _controller,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    collectEventListen?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _getCollects([bool refresh = false]) async {
    if (refresh) {
      curPage = 0;
    }

    var result = await Api.getArticleCollects(curPage);
    if (result != null) {
      if (curPage == 0) {
        _collects.clear();
      }
      curPage++;
      var data = result['data'];
      pageCount = data['pageCount'];
      _collects.addAll(data['datas']);
      _isHidden = true;
      setState(() {});
    }
  }

  Widget _buildItem(int i) {
    _collects[i]['id'] = _collects[i]['originId'];
    _collects[i]['collect'] = true;
    return ArticleItem(_collects[i]);
  }
}
