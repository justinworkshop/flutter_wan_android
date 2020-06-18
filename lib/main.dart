import 'package:flutter/material.dart';
import 'package:flutterwanandroid/ui/widget/main_drawer.dart';
import 'package:flutterwanandroid/ui/page/page_article.dart';

import 'manager/app_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// 初始化
    AppManager.initApp();

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          title: Text(
        '文章',
        style: TextStyle(color: Colors.white),
      )),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: ArticlePage(),
    ));
  }
}
