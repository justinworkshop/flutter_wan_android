import 'package:flutter/material.dart';
import 'package:flutterwanandroid/http/api.dart';
import 'package:flutterwanandroid/ui/widget/item_article.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController _controller = new ScrollController();
  bool _isHidden = false;
  String _keyWord;
  List articles = [];
  int curPage = 0;
  int listTotalSize = 0;

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
        _doSearch();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none)),
            onChanged: (String value) {
              if (value.trim().isEmpty) {
                return "请输入关键词";
              }

              _keyWord = value;
            },
          ),
          height: 80,
          decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(30)),
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
              height: 68,
              width: 80,
              child: Row(
                children: <Widget>[Text('搜索')],
              ),
            ),
            onTap: () {
              print(">>>>>> search");
              _doSearch();
            },
          )
        ],
      ),
      body: Stack(
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
                  itemCount: articles.length, // +1是banner
                  itemBuilder: (context, i) => _buildItem(i),
                ),
                onRefresh: _pullToRefresh),
          ),
        ],
      ),
    );
  }

  _doSearch() async {
    print("curPage: $curPage, Key: $_keyWord");
    var result = await Api.articleSearch(curPage, _keyWord);
    if (result != null) {
      var data = result['data'];
      var datas = data['datas'];
      if (curPage == 0) {
        articles.clear();
      }
      curPage++;
      articles.addAll(datas);
      listTotalSize = data['total'];

      setState(() {});
    }
  }

  Widget _buildItem(int i) {
    var itemData = articles[i];
    print("article 1 $itemData");
    return new ArticleItem(itemData);
  }

  Future<void> _pullToRefresh() async {
    curPage = 0;

    _doSearch();

    _isHidden = false;
    return null;
  }
}
