import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:async';

import 'package:sprintf/sprintf.dart';

import '../utils/http_util.dart' as HttpUtil;
import '../utils/urls_util.dart' as UrlUtil;
import '../utils/encode_util.dart' as EncodeUtil;

void main(List<String> args) async {
  print("main start =================");
  /// 先判断是否需要验证码 loginConf
  var needPassCode = await initLoginConf();
  if (needPassCode) {
    /// 获取验证码 captcha
    var captchaImage = getCaptchaImage();
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
  print("initLoginConf result:${result.data} \n");
  if (result.success && result.data['is_login_passCode'] == "N") {
    print('不需要验证码');
    return false;
  }
  print('需要验证码');
  return true;
}

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

Future<File> getCaptchaImage({String base64String = ""}) async {
  if ("" == base64String) {
    base64String = await getCaptchaBase64String();
  }
  return await EncodeUtil.base64String2Image("sssssss.png", base64String);
}