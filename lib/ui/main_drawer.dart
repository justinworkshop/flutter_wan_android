import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _userName;

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
                backgroundImage: AssetImage("assets/images/wan_android_logo.png"),
                radius: 38.0,
              ),
            ),
            Text(
              _userName ?? "请先登录",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        userHeader
      ],
    );
  }

  _itemClick(Widget page) {
//    var dstPage = _userName == null ? LoginPage() : page;
//    if (dstPage != null) {
//      Navigator.push(context, new MaterialPageRoute(builder: (context) {
//        return dstPage;
//      }));
//    }
  }
}
