import 'package:flutter/material.dart';
import 'package:flutterwanandroid/http/api.dart';

import '../widget/item_article.dart';

class TopArticlePage extends StatefulWidget {
  @override
  _TopArticlePageState createState() => _TopArticlePageState();
}

class _TopArticlePageState extends State<TopArticlePage> {
  // 滑动控制器
  ScrollController _controller = new ScrollController();

  // 控制正在加载的显示
  bool _isHidden = true;

  List articles = [];
  List banners = [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      ///  获得ScrollController监听控件可以滚动到最大范围
      var maxScroll = _controller.position.maxScrollExtent;

      /// 获得当前位置到像素值
      var pixels = _controller.position.pixels;

      /// 当前滑动位置达到底部，同时还有更多数据
      if (maxScroll == pixels && articles.length < 100) {
        /// 加载更多
        _getArticleList();
      }
    });

    /// initState()中手动请求一次数据
    _pullToRefresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /// 正在加载
        Offstage(
          offstage: !_isHidden, // 是否隐藏
          child: new Center(child: CircularProgressIndicator()),
        ),

        /// 内容
        Offstage(
          offstage: _isHidden,
          child: new RefreshIndicator(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, i) => _buildItem(i),
                controller: _controller,
              ),
              onRefresh: _pullToRefresh),
        ),
      ],
    );
  }

  _getArticleList([bool update = true]) async {
    var data = await Api.getTopArticleList();
    if (data != null) {
      var datas = data['data'];

      articles.clear();
      articles.addAll(datas);

      /// 更新UI
      if (update) {
        setState(() {});
      }
    }
  }

  Future<void> _pullToRefresh() async {
    Iterable<Future> futures = [_getArticleList()];
    await Future.wait(futures);
    _isHidden = false;
    setState(() {});
    return null;
  }

  Widget _buildItem(int i) {
    var itemData = articles[i];
    return new ArticleItem(itemData);
  }
}
