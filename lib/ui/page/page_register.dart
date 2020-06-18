import 'package:flutter/material.dart';
import 'package:flutterwanandroid/http/api.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _userNameNode = new FocusNode();
  FocusNode _pwdNode = new FocusNode();
  FocusNode _pwdValidateNode = new FocusNode();

  String _userName, _pwd, _pwdValidate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0.0),
          children: <Widget>[
            _buildUserName(),
            _buildPwd(),
            _buildPwdValidate(),
            _buildRegister(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      focusNode: _userNameNode,
      autofocus: true,
      decoration: InputDecoration(
        labelText: "用户名",
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwdNode);
      },
      validator: (String value) {
        if (value.trim().isEmpty) {
          return "请输入用户名";
        }

        _userName = value;
      },
    );
  }

  Widget _buildPwd() {
    return TextFormField(
      focusNode: _pwdNode,
      autofocus: true,
      decoration: InputDecoration(
        labelText: "密码",
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwdValidateNode);
      },
      validator: (String value) {
        if (value.trim().isEmpty) {
          return "请输入密码";
        }

        _pwd = value;
      },
    );
  }

  Widget _buildPwdValidate() {
    return TextFormField(
      focusNode: _pwdValidateNode,
      autofocus: true,
      decoration: InputDecoration(
        labelText: "确认密码",
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwdValidateNode);
      },
      validator: (String value) {
        if (value.trim().isEmpty) {
          return "请输入密码";
        } else if (_pwd != value) {
          return "两次密码输入不一致";
        }

        _pwdValidate = value;
      },
    );
  }

  Widget _buildRegister() {
    return Container(
      height: 52.0,
      margin: EdgeInsets.only(top: 18.0),
      child: RaisedButton(
        child: Text(
          "注册",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: _doClick,
      ),
    );
  }

  void _doClick() async {
    _userNameNode.unfocus();
    _pwdNode.unfocus();
    _pwdValidateNode.unfocus();

    if (_formKey.currentState.validate()) {
      // 弹出加载框
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      var result = await Api.register(_userName, _pwd);
      Navigator.pop(context);

      if (result['errorCode'] == -1) {
        var errorMsg = result['errorMsg'];
        Toast.show(errorMsg, context, gravity: Toast.CENTER);
      } else {
        Toast.show("注册成功!", context, gravity: Toast.CENTER);
        Navigator.pop(context);
      }
    }
  }
}
