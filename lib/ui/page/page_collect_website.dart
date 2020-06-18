import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterwanandroid/http/api.dart';
import 'package:flutterwanandroid/ui/page/page_add_website.dart';
import 'package:toast/toast.dart';

class WebsiteCollectPage extends StatefulWidget {
  @override
  _WebsiteCollectPageState createState() => _WebsiteCollectPageState();
}

class _WebsiteCollectPageState extends State<WebsiteCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;
  List _collects = [];

  @override
  void initState() {
    super.initState();
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
            onRefresh: () => _getCollects(),
            child: ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, i) => _buildItem(context, i),
                separatorBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  );
                },
                itemCount: _collects.length),
          ),
        ),
        Positioned(
          bottom: 18.0,
          right: 18.0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _addCollect,
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _getCollects() async {
    var result = await Api.getWebSiteCollects();
    if (result != null) {
      var data = result['data'];
      _collects.clear();
      _collects.addAll(data);
      _isHidden = true;
      setState(() {});
    }
  }

  _buildItem(BuildContext context, int i) {
    var item = _collects[i];
    return Slidable(
      delegate: SlidableDrawerDelegate(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "删除",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _delCollect(item),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              item['name'],
              style: TextStyle(fontSize: 22.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Text(
              item['link'],
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  _addCollect() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => WebsiteAddPage()));
    print("addResult >>>> $result");
    if (result != null) {
      _collects.add(result);
    }
    setState(() {

    });
  }

  _delCollect(item) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    var result = await Api.unCollectWebsite(item['id']);
    Navigator.pop(context);

    if (result['errorCode'] != 0) {
      Toast.show(result['errorMsg'], context, gravity: Toast.CENTER);
    } else {
      setState(() {
        _collects.remove(item);
      });
    }
  }
}
