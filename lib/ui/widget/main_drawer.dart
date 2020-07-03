import 'package:flutter/material.dart';
import 'package:flutterwanandroid/event/event_login.dart';
import 'package:flutterwanandroid/http/api.dart';
import 'package:flutterwanandroid/manager/app_manager.dart';
import 'package:flutterwanandroid/ui/page/page_collect.dart';
import 'package:flutterwanandroid/ui/page/page_develop.dart';
import 'package:flutterwanandroid/ui/page/page_login.dart';
import 'package:flutterwanandroid/ui/page/page_search.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _userName;

  @override
  void initState() {
    super.initState();
    AppManager.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        _userName = event.userName;
        AppManager.sharedPreference.setString(AppManager.account, _userName);
      });
    });

    _userName = AppManager.sharedPreference.getString(AppManager.account);
  }

  @override
  Widget build(BuildContext context) {
    Widget userHeader = DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: InkWell(
        onTap: () {
          _itemClick(null);
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 18.0),
              child: CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/wan_android_logo.png"),
                radius: 38.0,
              ),
            ),
            Text(
              _userName ?? "未登录",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        userHeader,

        /// 收藏
        InkWell(
          onTap: () {
            _itemClick(CollectPage());
          },
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              "收藏列表",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),

        /// 设置
        Offstage(
          offstage: false,
          child: InkWell(
            onTap: () {
              _itemClick(SearchPage());
            },
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                "设置",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),

        /// 开发者模式
        Offstage(
          offstage: false,
          child: InkWell(
            onTap: () {
              _itemClick(DevelopPage());
            },
            child: ListTile(
              leading: Icon(Icons.developer_mode),
              title: Text(
                "开发者模式",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),

        /// 退出登陆
        Offstage(
          offstage: _userName == null,
          child: InkWell(
            onTap: () {
              setState(() {
                AppManager.sharedPreference.setString(AppManager.account, null);
                Api.clearCookie();
                _userName = null;
              });
            },
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "退出登录",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  _itemClick(Widget page) {
    var dstPage = _userName == null ? LoginPage() : page;
    if (dstPage != null) {
      Navigator.push(context, new MaterialPageRoute(builder: (context) {
        return dstPage;
      }));
    }
  }
}
