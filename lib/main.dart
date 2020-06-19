import 'package:flutter/material.dart';
import 'package:flutterwanandroid/ui/page/page_article.dart';
import 'package:flutterwanandroid/ui/page/page_article_top.dart';
import 'package:flutterwanandroid/ui/widget/main_drawer.dart';

import 'manager/app_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> tabs = ["文章", "置顶"];

  @override
  void initState() {
    super.initState();
    AppManager.initApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
              title: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 40.0, 0.0),
            child: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "文章",
                ),
                Tab(
                  text: "置顶",
                ),
              ],
            ),
          )),
          drawer: Drawer(
            child: MainDrawer(),
          ),
          body: TabBarView(
            children: <Widget>[ArticlePage(), TopArticlePage()],
          ),
        ),
      ),
    );
  }
}
