import 'package:dio/dio.dart';
import 'http.dart' as HttpUtils;
import 'urls.dart';

void main(List<String> args) {
  print("args:$args");
  // _captcha_code();
  // _login();
  _loginConf();
}

void _download_captcha_img() {}

void _captcha_code() async {
  var url = urls['getCodeImg']['req_url'];
  print("_login url:$url");
  try {
    Response response = await Dio().get(url);
    print(response);
  } catch (e) {
    print(e);
  }
}

void _login() {
  var loginConfig = urls['login'];
  print("loginConfig:$loginConfig");
  HttpUtils.request(loginConfig);
}

void _loginConf() {
  var urlConfig = urls['loginConf'];
  print("urlConfig:$urlConfig");
  HttpUtils.request(urlConfig);
}
