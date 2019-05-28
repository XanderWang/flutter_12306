import 'package:dio/dio.dart';
import 'http.dart' as HttpUtils;
import 'urls.dart' as UrlUtils;

void main(List<String> args) {
  print("main start =================\n");
  // print("args:$args");
  // _captcha_code();
  // _login();
  _loginConf();
  print("main end =================\n");
}

void _download_captcha_img() {}

void _captcha_code() async {
  var url = UrlUtils.createUrlConfigMap('getCodeImg')['req_url'];
  print("_login url:$url");
  try {
    Response response = await Dio().get(url);
    print(response);
  } catch (e) {
    print(e);
  }
}

void _login() {
  var loginConfig = UrlUtils.createUrlConfigMap('login');
  print("loginConfig:$loginConfig");
  HttpUtils.request(loginConfig);
}

void _loginConf() {
  var urlConfig = UrlUtils.createUrlConfigMap('loginConf');
  print("_loginConf urlConfig:$urlConfig");

  // var result = await HttpUtils.request(urlConfig);
  // print("_loginConf result:${result.toString()} \n");
}
