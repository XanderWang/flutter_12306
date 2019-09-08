import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:async';

import 'package:sprintf/sprintf.dart';
//import 'package:path_provider/path_provider.dart';

import '../utils/http_util.dart' as HttpUtil;
import '../utils/urls_util.dart' as UrlUtil;
import '../utils/encode_util.dart' as EncodeUtil;

///先判断是否需要验证码
///然后请求授权
///然后获取 devicesId
///然后获取验证码
///然后再次请求授权
///然后校验验证码
///然后登陆
///然后获取用户名

void main(List<String> args) async {
  print("main start =================");

  /// 先判断是否需要验证码 loginConf
  var needPassCode = await initLoginConf();
  if (needPassCode) {
    /// 请求授权
    var auth = await doAuth();
    /// 获取 devicesId
    String devicesId = await getDevicesId();
    HttpUtil.setDevicesId(devicesId);
    /// 获取验证码 captcha
    /// var captchaImage = await getCaptchaImage();
    /// var checkResult = checkCaptcha("43,45,106,45");
    /// checkCaptcha("266%2C40%2C253%2C108");
  } else {
    /// 不需要验证码
  }
  print("main end =================");
}

/// 是否需要验证码
Future<bool> initLoginConf() async {
  var urlConfig = UrlUtil.getUrlConfigMap('loginConf');
  print("initLoginConf urlConfig:$urlConfig");

  /// 每碰到一次 await , await 下面的代码就会被放到 Future 的 then 里面调用
  /// 这样，代码执行是异步执行的，但是代码逻辑上是同步的
  var result = await HttpUtil.request(urlConfig);
  /// print("initLoginConf result:${result.data} \n");
  if (result.success && result.data['is_login_passCode'] == "N") {
    print('不需要验证码');
    return false;
  }
  print('需要验证码');
  return true;
}

/// 授权，分为下面 2 步
/// loginInitCdn1
/// uamtk-static
Future doAuth() async {
  var loginInitCdn1 = UrlUtil.getUrlConfigMap('loginInitCdn1');
  print("doAuth loginInitCdn1:$loginInitCdn1");
  var loginInitCdn1Result = await HttpUtil.request(loginInitCdn1);
  var uamtk_static = UrlUtil.getUrlConfigMap('uamtk-static');
  print("doAuth uamtk_static:$uamtk_static");
  var uamtk_static_data = {"appid": "otn"};
  var uamtk_staticResult =
      await HttpUtil.request(uamtk_static, data: uamtk_static_data);
  return uamtk_staticResult;
}

Future<String> getDevicesId() async {
  var devicesIdConf = UrlUtil.getUrlConfigMap('getDevicesId');
  var date = DateTime.now().millisecondsSinceEpoch;
  devicesIdConf['req_url'] = sprintf(devicesIdConf['req_url'], [date]);
  print("getDevicesId devicesIdConf:$devicesIdConf");
  var devicesIdResult = await HttpUtil.request(devicesIdConf);
  print("devicesIdResult:$devicesIdResult");
  String devicesId = "";
  if( devicesIdResult.success ) {
    String devicesString = devicesIdResult.data;
    var start = devicesString.indexOf('(') + 1;
    var end = devicesString.lastIndexOf(')');
    devicesString = devicesString.substring(start, end);
    var deviceJson = json.decode(devicesString);
    devicesId = deviceJson['dfp'];
  }
  return devicesId;
}

Future baseLogin(String username, String password, String answer) async {
  var login = UrlUtil.getUrlConfigMap('login');
  print("baseLogin login:$login");
  var login_data = {
    "username": username,
    "password": password,
    "answer": answer,
    "appid": "otn",
  };
  var loginResult = await HttpUtil.request(login, data: login_data);
}

/// 获取 base64 加密的验证码
Future<String> getCaptchaBase64String() async {
  var date = DateTime.now().millisecondsSinceEpoch;
  var captchaImage = UrlUtil.getUrlConfigMap('captchaImage');
  captchaImage['req_url'] =
      sprintf(captchaImage['req_url'], [date, date, date]);
  var captchaImageResult = await HttpUtil.request(captchaImage);
  if (captchaImageResult.success) {
    String base64String = captchaImageResult.data;
    var start = base64String.indexOf('(') + 1;
    var end = base64String.lastIndexOf(')');
    base64String = base64String.substring(start, end);
    var base64Json = json.decode(base64String);
    base64String = base64Json['image'];
    return base64String;
  } else {
    return "";
  }
}

/// 获取验证码
/// [fileName] 文件路径
/// [base64String] base64 加密后的
Future<File> getCaptchaImage(
    {String fileName = "captcha.png", String base64String = ""}) async {
  if ("" == base64String) {
    base64String = await getCaptchaBase64String();
  }
  if ("" == fileName) {
//    Directory appDocDir = await getApplicationDocumentsDirectory();
//    fileName = appDocDir.path + "/captcha.png";
  }
  return await EncodeUtil.base64String2Image(fileName, base64String);
}

/// 校验验证码
/// [answer] 选中的图片
Future<bool> checkCaptcha(String answer) async {
  var date = DateTime.now().millisecondsSinceEpoch;
  var checkCaptcha = UrlUtil.getUrlConfigMap('checkCaptcha');
  checkCaptcha['req_url'] =
      sprintf(checkCaptcha['req_url'], [date, answer, date]);
  var checkCaptchaResult = await HttpUtil.request(checkCaptcha);
  print('checkCaptchaResult:$checkCaptchaResult');
  if (checkCaptchaResult.success) {
    String checkResult = checkCaptchaResult.data;
    if (!checkResult.startsWith('/**/jQuery')) {
      return false;
    }
    var start = checkResult.indexOf('(') + 1;
    var end = checkResult.lastIndexOf(')');
    checkResult = checkResult.substring(start, end);
    var checkJson = json.decode(checkResult);
    return "4" == checkJson['result_code'];
  }
  return false;
}

Future login(String userName, String password) async {
  var login = UrlUtil.getUrlConfigMap('login');
  var loginResult = await HttpUtil.request(login,
      data: {'username': userName, 'password': password, 'appid': 'otn'});
  print('login:$loginResult');
}

/// 登录
Future auth() async {
  var auth = UrlUtil.getUrlConfigMap('auth');
  var authResult = await HttpUtil.request(auth, data: {'appid': 'otn'});
  print('checkCaptchaResult:$authResult');
}
