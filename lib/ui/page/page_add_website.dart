import 'package:flutter/material.dart';
import 'package:flutterwanandroid/http/api.dart';
import 'package:toast/toast.dart';

class WebsiteAddPage extends StatefulWidget {
  @override
  _WebsiteAddPageState createState() => _WebsiteAddPageState();
}

class _WebsiteAddPageState extends State<WebsiteAddPage> {
  String _name;
  String _link;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收藏网址"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0.0),
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: "名称",
              ),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "请输入收藏名称";
                }
                _name = value;
              },
            ),
            TextFormField(
              initialValue: "http://",
              decoration: InputDecoration(
                labelText: "网址",
              ),
              keyboardType: TextInputType.url,
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "请输入地址";
                }
                _link = value;
              },
            ),
            Container(
              height: 45.0,
              margin: EdgeInsets.only(
                top: 18.0,
                left: 8.0,
                right: 8.0,
              ),
              child: RaisedButton(
                child: Text(
                  "收藏",
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () => _doAdd(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  _doAdd(context) async {
    if (_formKey.currentState.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      var result = await Api.collectWebsite(_name, _link);
      // Dialog dismiss
      Navigator.pop(context);

      if (result['errorCode'] != 0) {
        Toast.show(result['errorMsg'], context, gravity: Toast.CENTER);
      } else {
        Navigator.pop(context);
      }
    }
  }
}
