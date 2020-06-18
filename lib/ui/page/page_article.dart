import 'package:banner_view/banner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/http/api.dart';
import 'package:flutterwanandroid/ui/page/page_webview.dart';

import '../widget/item_article.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  // 滑动控制器
  ScrollController _controller = new ScrollController();

  // 控制正在加载的显示
  bool _isHidden = true;

  List articles = [];
  List banners = [];
  var listTotalSize = 0;
  var curPage = 0;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      ///  获得ScrollController监听控件可以滚动到最大范围
      var maxScroll = _controller.position.maxScrollExtent;

      /// 获得当前位置到像素值
      var pixels = _controller.position.pixels;

      /// 当前滑动位置达到底部，同时还有更多数据
      if (maxScroll == pixels && articles.length < listTotalSize) {
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
                itemCount: articles.length + 1, // +1是banner
                itemBuilder: (context, i) => _buildItem(i),
                controller: _controller,
              ),
              onRefresh: _pullToRefresh),
        ),
      ],
    );
  }

  _getArticleList([bool update = true]) async {
    var data = await Api.getArticleList(curPage);
    if (data != null) {
      var map = data['data'];
      var datas = map['datas'];

      listTotalSize = map["total"];
      if (curPage == 0) {
        articles.clear();
      }
      curPage++;
      articles.addAll(datas);

      /// 更新UI
      if (update) {
        setState(() {});
      }
    }
  }

  _getBanner([bool update = true]) async {
    var data = await Api.getBanner();
    if (data != null) {
      banners.clear();
      banners.addAll(data['data']);
      if (update) {
        setState(() {});
      }
    }
  }

  Future<void> _pullToRefresh() async {
    curPage = 0;

    /// 文章列表、Banner 都请求完成再刷新页面，这里是组合两个异步任务Future
    Iterable<Future> futures = [_getArticleList(), _getBanner()];
    await Future.wait(futures);
    _isHidden = false;
    setState(() {});
    return null;
  }

  Widget _buildItem(int i) {
    if (i == 0) {
      // Container：容器
      return new Container(
        height: MediaQuery.of(context).size.height * 0.3, // 屏幕高度的0.3
        child: _bannerView(),
      );
    }

    var itemData = articles[i - 1];
    return new ArticleItem(itemData);
  }

  Widget _bannerView() {
    /// map:转换，将List中的每一个条目执行map方法参数接收的这个方法
    /// map方法最终会返回一个Iterable<T>
    var list = banners.map((item) {
      return InkWell(
        child: Image.network(item['imagePath'], fit: BoxFit.cover),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return WebViewPage(item);
          }));
        },
      );
    }).toList();

    return list.isNotEmpty
        ? BannerView(
            list,
            intervalDuration: const Duration(seconds: 3), // 控制轮播时间
          )
        : null;
  }
}
