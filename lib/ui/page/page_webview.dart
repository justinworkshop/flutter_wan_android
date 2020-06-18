import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutterwanandroid/http/api.dart';

class WebViewPage extends StatefulWidget {
  final data;
  final supportCollect;

  WebViewPage(this.data, {this.supportCollect = false});


  @override
  _WebViewPageState createState() => _WebViewPageState();
}


class _WebViewPageState extends State<WebViewPage> {
  bool isLoad = true;
  FlutterWebviewPlugin flutterWebViewPlugin;

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin = new FlutterWebviewPlugin();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isCollected = widget.data['collect'] ?? false;
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.data['title']),
        actions: <Widget>[
          Offstage(
            offstage: !widget.supportCollect,
            child: IconButton(
              icon: Icon(Icons.favorite,
                  color: isCollected ? Colors.red : Colors.white),
              onPressed: () => _doCollect(),
            ),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: const LinearProgressIndicator()),
        bottomOpacity: isLoad ? 1.0 : 0.0,
      ),
      withLocalStorage: true,
      url: widget.data['url'],
      withJavascript: true,
    );
  }

  _doCollect() async {
//    var result;
//    bool isLogin = AppManager.isLogin();
//    if (isLogin) {
//      if (widget.data['collect']) {
//        result = await Api.unCollectArticle(widget.data['id']);
//      } else {
//        result = await Api.collectArticle(widget.data['id']);
//      }
//    } else {
//      Navigator.pushReplacement(
//          context, MaterialPageRoute(builder: (_) => LoginPage()));
//    }
//
//    if (result['errorCode'] == 0) {
//      setState(() {
//        widget.data['collect'] = !widget.data['collect'];
//        AppManager.eventBus
//            .fire(CollectEvent(widget.data['id'], widget.data['collect']));
//      });
//    }
  }
}
