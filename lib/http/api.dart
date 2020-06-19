import 'package:dio/dio.dart';

import 'http_manager.dart';

class Api {
  static const String baseUrl = "https://www.wanandroid.com/";

  // 首页文章列表
  static const String ARTICLE_LIST = "article/list/";

  // 置顶文章列表
  static const String TOP_ARTICLE_LIST = "article/top/json";

  // Banner轮播图
  static const String BANNER = "banner/json";

  // 登录
  static const String LOGIN = "user/login";

  // 注册
  static const String REGISTER = "user/register";

  // 登出
  static const String LOGOUT = "user/logout/json";

  // 获取收藏列表
  static const String COLLECT_ARTICLE_LIST = "lg/collect/list/";
  static const String COLLECT_WEBSITE_LIST = "lg/collect/usertools/json";

  // 收藏站内文章
  static const String COLLECT_INTERNAL_ARTICLE = "lg/collect/";

  // 收藏站外文章
  static const String COLLECT_WEBSITE = "lg/collect/addtool/json";

  // 取消收藏
  static const String UN_COLLECT_ARTICLE = "lg/uncollect_originId/";
  static const String UN_COLLECT_WEBSITE = "lg/collect/deletetool/json";

  // 搜索
  static const String ARTICLE_SEARCH = "article/query/";

  static getArticleList(int page) async {
    return HttpManager.getInstance().request('$ARTICLE_LIST$page/json');
  }

  static getBanner() async {
    return await HttpManager.getInstance().request(BANNER);
  }

  static login(String userName, String password) async {
    print("userName: $userName, password: $password");
    var formData =
        FormData.fromMap({"username": userName, "password": password});

    print(formData.toString());
    return await HttpManager.getInstance()
        .request(LOGIN, data: formData, method: "post");
  }

  static register(String userName, String password) async {
    var formData = FormData.fromMap(
        {"username": userName, "password": password, "repassword": password});
    return await HttpManager.getInstance()
        .request(REGISTER, data: formData, method: "post");
  }

  static clearCookie() {
    HttpManager.getInstance().clearCookie();
  }

  static getArticleCollects(int page) async {
    return await HttpManager.getInstance()
        .request("$COLLECT_ARTICLE_LIST/$page/json");
  }

  static getWebSiteCollects() async {
    return await HttpManager.getInstance().request(COLLECT_WEBSITE_LIST);
  }

  static collectArticle(int id) async {
    return await HttpManager.getInstance()
        .request("$COLLECT_INTERNAL_ARTICLE$id/json", method: "post");
  }

  static unCollectArticle(int id) async {
    return await HttpManager.getInstance()
        .request("$UN_COLLECT_ARTICLE$id/json", method: "post");
  }

  static collectWebsite(String title, String author, String link) async {
    var formData =
        FormData.fromMap({"name": title, /*"author": author,*/ "link": link});
    return await HttpManager.getInstance()
        .request(COLLECT_WEBSITE, data: formData, method: "post");
  }

  static unCollectWebsite(int id) async {
    var formData = FormData.fromMap({"id": id});
    return await HttpManager.getInstance()
        .request(UN_COLLECT_WEBSITE, data: formData, method: "post");
  }

  static articleSearch(int pageId, String k) async {
    var formData = FormData.fromMap({"k": k});
    return await HttpManager.getInstance()
        .request("$ARTICLE_SEARCH$pageId/json", data: formData, method: "post");
  }

  static getTopArticleList() async {
    return await HttpManager.getInstance().request(TOP_ARTICLE_LIST);
  }
}
