import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import './../utils/login_util.dart' as LoginUtil;

class LoginView extends StatelessWidget {
  String _userName = "";
  String _password = "";

  void _changeUserName(String userName) {
    _userName = userName;
    print('username is:$_userName');
  }

  void _changePassword(String password) {
    _password = password;
    print('username is:$_password');
  }

  String _loginResult = "未登录";

  /// 开始登录
  void _clickLogin() {
    print("click login");
    /// 登录失败的消息如何传递给 LoginCaptchaView
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      elevation: 3,
      child: Column(
        children: <Widget>[
          TextField(
              onChanged: _changeUserName,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                icon: Icon(Icons.text_fields),
                labelText: '请输入账号',
              )),
          TextField(
              onChanged: _changePassword,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                icon: Icon(Icons.text_fields),
                labelText: '请输入密码',
              )),
          LoginCaptchaView(parentValue: _loginResult),
          RaisedButton(
            onPressed: _clickLogin,
            elevation: 3,
            child: Text(
              "登录",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    ));
  }
}

final _pointX = [];
final _pointY = [];

class LoginCaptchaView extends StatefulWidget {
  String parentValue = "";

  LoginCaptchaView({Key key, this.parentValue}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    print("login.dart-LoginCaptchaView-createState:");
    return new _LoginCaptchaState();
  }
}

class _LoginCaptchaState extends State<LoginCaptchaView> {
  void _tapDown(TapDownDetails tapDownDetails) {
    print(
        "login.dart-_LoginCaptchaState-_tapDown:${tapDownDetails.localPosition}");
    if (_needRefreshCaptcha) {
//      _refreshCaptcha(pointerDownEvent);
    }
  }

  Uint8List _imgData = null;

  bool _needRefreshCaptcha = true;
  bool _isLoading = false;

  _rootPointerDownEvent(PointerDownEvent pointerDownEvent) {
    print(
        "login.dart-_LoginCaptchaState-_rootPointerDownEvent:${pointerDownEvent.localPosition}");
    if (_needRefreshCaptcha) {
      _refreshCaptcha();
    }
  }

  _refreshCaptcha() {
    print("login.dart-_LoginCaptchaState-_refreshCaptcha:");
    setState(() {
      _isLoading = true;
    });
    _getCaptchaImage().then((base64String) {
      if ("" != base64String) {
        setState(() {
          _imgData = base64Decode(base64String);
          _isLoading = false;
        });
        _needRefreshCaptcha = false;
      }
    });
  }

  Future<String> _getCaptchaImage() async {
    print("login.dart-_LoginCaptchaState-_getCaptchaImage:");
    var needPassCode = await LoginUtil.initLoginConf();
    if (needPassCode) {
      /// 获取验证码 captcha
      return await LoginUtil.getCaptchaBase64String();
    } else {
      /// 不需要验证码
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    print("login.dart-_LoginCaptchaState-build:");
    // 刷新按钮，说着说重试按钮，防止有时候图片刷不出来
    // 显示验证码
    // 选择验证码
//    return GestureDetector(
//      onTapDown: _tapDown,
//      child: FutureBuilder(
//        future: _getCaptchaImage(),
//        builder: _build,
//      ),
//    );
    List<Widget> wList = [];
    wList.add(Container(
      alignment: AlignmentDirectional.center,
      child: Text(_isLoading ? "加载中" : "点击加载验证码！！！"),
    ));
    if (null != _imgData) {
      wList.add(Image.memory(
        _imgData,
        width: 300,
        height: 200,
      ));
    }
//    wList.add(GestureDetector(
//      onTapDown: _tapDown,
//      child: Text("",),
//    ));

    return Listener(
      onPointerDown: _rootPointerDownEvent,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: 300, height: 200),
        child: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: wList,
        ),
      ),
    );
  }
}
