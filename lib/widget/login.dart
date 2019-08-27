import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

import './../utils/login_util.dart' as LoginUtil;

class LoginView extends StatefulWidget {
  String _userName = "";
  String _password = "";
  Uint8List _captchaUint8 = new Uint8List(0);

  @override
  State<StatefulWidget> createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<LoginView> {
  void _changeUserName(String userName) {
    widget._userName = userName;
    print('username is:${widget._userName}');
  }

  void _changePassword(String password) {
    widget._password = password;
    print('username is:${widget._password}');
  }

  /// 刷新
  void _clickRefresh() {
    LoginUtil.initLoginConf().then((needCaptcha) {
      print("need captcha: $needCaptcha");
      return LoginUtil.getCaptchaBase64String();
    }).then((encodeString) {
      print("encodeString: $encodeString");
      Uint8List decodeData = base64Decode(encodeString);
      print("decode data:$decodeData");
      setState(() {
        widget._captchaUint8 = decodeData;
      });
    });
  }

  /// 开始登录
  void _clickLogin() {
    print("click login");
  }

  void _tapDown(TapDownDetails downDetails) {
    //print("tap down details:${json.encode(downDetails)}");
    print("tap down details:${downDetails.localPosition}");
  }

  Future<String> updateCaptchaImageString() async {
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
                  helperText: '请输入你的账号')),
          TextField(
              onChanged: _changePassword,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.text_fields),
                  labelText: '请输入密码',
                  helperText: '请输入你的密码')),
          GestureDetector(
            onTapDown: _tapDown,
            child: Image.memory(
              widget._captchaUint8,
              width: 300,
              height: 200,
            ),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: _clickRefresh,
                elevation: 3,
                child: Text(
                  "刷新",
                  style: TextStyle(fontSize: 20),
                ),
              ),
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
        ],
      ),
    ));
  }
}
