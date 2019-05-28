import 'package:dio/dio.dart';
import 'http.dart' as HttpUtils;
import 'urls.dart' as UrlUtils;

void main(List<String> args) {
  print("main start =================");
  // print("args:$args");
  // _captcha_code();
  // _login();
  _loginConf();
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

void _loginConf() async {
  var urlConfig = UrlUtils.getUrlConfigMap('loginConf');
  print("_loginConf urlConfig:$urlConfig");

  /// 没碰到一次 await , await 下面的代码就会被放到 Future 的 then 里面调用
  /// 这样，代码执行是异步执行的，但是代码逻辑上是同步的
  var result = await HttpUtils.request(urlConfig);
  print("_loginConf result:${result.toString()} \n");
}
