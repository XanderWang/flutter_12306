import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:sprintf/sprintf.dart';
import 'package:dio/dio.dart';

import './utils/http.dart' as HttpUtils;
import './utils/urls.dart' as UrlUtils;

import './utils/encode_util.dart' as EncodeUtil;

void main(List<String> args) async {
  print("main start =================");

  // var file = await EncodeUtil.base64String2Image("sssssss.png", "");

  /// 先判断是否需要验证码 loginConf
  var needPassCode = await needLoginPassCode();
  if (needPassCode) {
    /// 获取验证码 getCodeImg1
    var getCodeImg1 = UrlUtils.getUrlConfigMap('getCodeImg1');
    getCodeImg1['req_url'] =
        sprintf(getCodeImg1['req_url'], ["23456", "23456", "23456"]);
    var getCodeImg1Result = await HttpUtils.request(getCodeImg1);

    // print('getCodeImg1Result is:$getCodeImg1Result');

    String base64String = getCodeImg1Result.data;
    print('======================');
    // print('base64String:$base64String');
    var start = base64String.indexOf('(') + 1;
    var end = base64String.lastIndexOf(')');
    base64String = base64String.substring(start, end);
    var base64Json = json.decode(base64String);
    base64String = base64Json['image'];
    print('======================');
    print('base64String:$base64String');
    var file = await EncodeUtil.base64String2Image("sssssss.png", base64String);
    //   print(getCodeImg1Result);
    //   File file = new File("sss.png");
    //   file.writeAsStringSync("test");
    // 校验验证码 codeCheck1
    // 验证账号和密码
    // loginInitCdn1  cnd
    // var loginInitCdn1 = UrlUtils.getUrlConfigMap('loginInitCdn1');
    // var loginInitCdn1Result = await HttpUtils.request(loginInitCdn1);
    // uamtk-static
    // var uamtkStatic = UrlUtils.getUrlConfigMap('uamtk-static');
    // var uamtkStaticData = {"appid": "otn"};
    // var duamtkStaticResult = await HttpUtils.request(uamtkStatic, data: uamtkStaticData);
    // var list = Future.wait([
    //   HttpUtils.request(loginInitCdn1),
    //   HttpUtils.request(uamtkStatic, data: uamtkStaticData)
    // ]);
  } else {
    /// 不需要验证码
  }
  print("main end =================");
}

void _download_captcha_img() {}

void _captcha_code() async {
  var url = UrlUtils.getUrlConfigMap('getCodeImg')['req_url'];
  print("_login url:$url");
  try {
    Response response = await Dio().get(url);
    print(response);
  } catch (e) {
    print(e);
  }
}

void _login() {
  var loginConfig = UrlUtils.getUrlConfigMap('login');
  print("loginConfig:$loginConfig");
  HttpUtils.request(loginConfig);
}

/// 是否需要验证吗
Future<bool> needLoginPassCode() async {
  var urlConfig = UrlUtils.getUrlConfigMap('loginConf');
  print("needLoginPassCode urlConfig:$urlConfig");

  /// 每碰到一次 await , await 下面的代码就会被放到 Future 的 then 里面调用
  /// 这样，代码执行是异步执行的，但是代码逻辑上是同步的
  var result = await HttpUtils.request(urlConfig);
  print("needLoginPassCode result:${result.data} \n");
  if (result.success && result.data['is_login_passCode'] == "N") {
    print('不需要验证码');
    return false;
  }
  print('需要验证码');
  return true;
}

Future<File> getCaptchaImage() async {
  var urlConfig = UrlUtils.getUrlConfigMap('getCodeImg1');
}
