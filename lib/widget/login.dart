import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';

import './../utils/login_util.dart' as LoginUtil;
import './../utils/http_util.dart' as HttpUtil;

// 点的位置
final _captchaPoints = [
  '43,45,',
  '106,45,',
  '167,45,',
  '259,45,',
  '43,120,',
  '106,120,',
  '167,120,',
  '259,120,'
];

/// 获取选择的验证码字串
String _getCaptchaPointsString() {
  String captchaAnswer = "";
  for (var index = 0; index < _captchaSelected.length; index++) {
    if (_captchaSelected[index]) {
      captchaAnswer += _captchaPoints[index];
    }
  }
  return captchaAnswer.substring(0, captchaAnswer.length - 1);
}

List<bool> _captchaSelected = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

final EventBus _eventBus = new EventBus();

class _CaptchaEvent {
  bool reload;

  _CaptchaEvent(this.reload);

  @override
  String toString() => "{reload:$reload}";
}

class _CaptchaSelectedEvent {
  int index;

  _CaptchaSelectedEvent(this.index);

  @override
  String toString() => "{index:$index}";
}

/// 验证码的宽
double _captchaWidth = 0;

/// 验证码的高
double _captchaHegiht = 0;

double _captchaRaitoWidth(double pixe) {
  return pixe * _captchaWidth / 360;
}

class LoginView extends StatelessWidget {
  String _userName = "";
  String _password = "";

  LoginView({Key key}) : super(key: key) {
    _eventBus.fire(new _CaptchaEvent(true));
  }

  void _changeUserName(String userName) {
    _userName = userName;
    print('username is:$_userName');
  }

  void _changePassword(String password) {
    _password = password;
    print('username is:$_password');
  }

  /// 开始登录
  void _clickLogin() {
    print("click login");
    /// 登录失败的消息如何传递给 LoginCaptchaView
    // _eventBus.fire(new _CaptchaEvent(true));
    String _captchaAswer = _getCaptchaPointsString();
    print("CaptchaPointsString:${_getCaptchaPointsString()}");
    LoginUtil.checkCaptcha(_captchaAswer).then((checkSuccess) {
      if (checkSuccess) {
        // LoginUtil.login(_userName, _password);
        LoginUtil.baseLogin(_userName, _password,_captchaAswer);
      } else {
        _eventBus.fire(new _CaptchaEvent(true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _captchaWidth = constraints.maxWidth;
      _captchaHegiht = _captchaWidth * 220 / 360;
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
                  labelText: '请输入手机号/邮箱/用户名',
                )),
            TextField(
                onChanged: _changePassword,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.text_fields),
                  labelText: '请输入密码',
                )),
            LoginCaptchaView(),
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
    });
  }
}

class LoginCaptchaView extends StatefulWidget {
//  LoginCaptchaView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    print("login.dart-LoginCaptchaView-createState:");
    return new _LoginCaptchaState();
  }
}

class _LoginCaptchaState extends State<LoginCaptchaView> {
  Uint8List _imgData = null;
  bool _needRefreshCaptcha = true;
  bool _isLoading = false;

  /// 构造方法，监听验证码校验结果
  _LoginCaptchaState() {
    print("login.dart-_LoginCaptchaState-_LoginCaptchaState:");
    _eventBus.on<_CaptchaEvent>().listen(_captchaListener);
  }

  /// 验证码验证结果监听，验证失败的时候刷新验证码
  void _captchaListener(_CaptchaEvent event) {
    print("login.dart-LoginCaptchaView-_captchaListener:$event");
    if (event.reload) {
      _refreshCaptcha();
    }
  }

  /// 点击初始化布局
  void _tapInitView() {
    print("login.dart-_LoginCaptchaState-_tapInitView:");
    _refreshCaptcha();
  }

  /// 刷新验证码
  void _refreshCaptcha() {
    print("login.dart-_LoginCaptchaState-_refreshCaptcha:");
    setState(() {
      _resetCaptchSelected();
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
    },onError: (error) {
      setState(() {
        _needRefreshCaptcha = true;
      });
    });
  }

  /// 获取验证码
  Future<String> _getCaptchaImage() async {
    print("login.dart-_LoginCaptchaState-_getCaptchaImage:");
    var needPassCode = await LoginUtil.initLoginConf();
    if (needPassCode) {
      /// 请求授权
      var auth = await LoginUtil.doAuth();
      /// 获取 devicesId
      String devicesId = await LoginUtil.getDevicesId();
      HttpUtil.setDevicesId(devicesId);
      /// 获取验证码 captcha
      return await LoginUtil.getCaptchaBase64String();
    } else {
      /// 不需要验证码
      return "";
    }
  }

  /// 重置验证码选择状态
  void _resetCaptchSelected() {
    _captchaSelected = [false, false, false, false, false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    print(
        "login.dart-_LoginCaptchaState-build:{$_captchaWidth,$_captchaHegiht}");
    // 刷新按钮，说着说重试按钮，防止有时候图片刷不出来
    // 显示验证码
    // 选择验证码
    List<Widget> stackList = [];
    stackList.add(GestureDetector(
        onTap: _tapInitView,
        child: Container(
          color: Color.fromARGB(1, 1, 1, 1),
          width: _captchaWidth,
          height: _captchaHegiht,
          alignment: AlignmentDirectional.center,
          child: Text(_isLoading ? "加载中..." : "点击加载验证码！！！"),
        )));

    if (null != _imgData && !_isLoading && !_needRefreshCaptcha) {
      stackList.add(Image.memory(
        _imgData,
        width: _captchaWidth,
        height: _captchaHegiht,
        fit: BoxFit.fill,
      ));

      double _paddingTop = _captchaRaitoWidth(50);
      double _paddingOther = _captchaRaitoWidth(5);

      stackList.add(Container(
        alignment: AlignmentDirectional.center,
        width: _captchaWidth - _paddingOther,
        height: _captchaHegiht - _paddingTop - _paddingOther,
        margin: EdgeInsets.fromLTRB(
            _paddingOther, _paddingTop, _paddingOther, _paddingOther),
        child: _CaptchaGridView(),
      ));

      stackList.add(Container(
        alignment: AlignmentDirectional.topEnd,
        width: _captchaWidth,
        height: _captchaHegiht,
        child: GestureDetector(
          onTap: _refreshCaptcha,
          child: Container(
              alignment: AlignmentDirectional.topEnd,
              color: Color.fromARGB(1, 1, 1, 1),
              width: _paddingTop,
              height: _paddingTop,
              child: Icon(
                Icons.refresh,
                size: _paddingTop - _captchaRaitoWidth(15),
                color: Colors.green,
              )),
        ),
      ));
    }

    return ConstrainedBox(
      constraints:
          BoxConstraints.expand(width: _captchaWidth, height: _captchaHegiht),
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: stackList,
      ),
    );
  }
}

class _CaptchaGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CaptchaGridViewState();
  }
}

class _CaptchaGridViewState extends State {
  void _tapItem(index) {
    print("login.dart-_CaptchaGridState-_tapItem:$index");
    _eventBus.fire(_CaptchaSelectedEvent(index));
    setState(() {
      _captchaSelected[index] = !_captchaSelected[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    print("login.dart-_CaptchaGridState-build:");
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, //每行四列
          childAspectRatio: 1.0, //显示区域宽高相等
          crossAxisSpacing: _captchaRaitoWidth(5),
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _tapItem(index);
            },
            child: Container(
              alignment: AlignmentDirectional.topStart,
              color: Color.fromARGB(1, 0, 0, 0), // 貌似加这个才可以点击，很奇怪
              child: Icon(
                Icons.favorite,
                color: _captchaSelected[index] ? Colors.red : Colors.grey,
              ),
            ),
          );
        });
  }
}
