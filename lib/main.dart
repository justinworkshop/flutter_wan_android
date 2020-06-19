import 'package:flutter/material.dart';
import 'package:flutterwanandroid/ui/page/page_article.dart';
import 'package:flutterwanandroid/ui/page/page_article_top.dart';
import 'package:flutterwanandroid/ui/page/page_search.dart';
import 'package:flutterwanandroid/ui/widget/main_drawer.dart';

import 'manager/app_manager.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
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
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
            title: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
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
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) {
                      return SearchPage();
                    }));
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.search),
                    ),
                  ),
                )
              ],
            ),
          ],
        )),
        drawer: Drawer(
          child: MainDrawer(),
        ),
        body: TabBarView(
          children: <Widget>[ArticlePage(), TopArticlePage()],
        ),
      ),
    );
  }
}
