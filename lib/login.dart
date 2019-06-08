import 'package:dio/dio.dart';
import 'http.dart' as HttpUtils;
import 'urls.dart' as UrlUtils;

void main(List<String> args) async {
  print("main start =================");

  /// 先判断是否需要验证码
  var needPassCode = await needLoginPassCode();
  if (needPassCode) {
    /// loginInitCdn1  cnd
    var loginInitCdn1 = UrlUtils.getUrlConfigMap('loginInitCdn1');
    var loginInitCdn1Result = await HttpUtils.request(loginInitCdn1);
    /// uamtk-static
    var uamtkStatic = UrlUtils.getUrlConfigMap('uamtk-static');
    var uamtkStaticData = {"appid": "otn"};
    var duamtkStaticResult = await HttpUtils.request(uamtkStatic, data: uamtkStaticData);
    // var list = Future.wait([
    //   HttpUtils.request(loginInitCdn1),
    //   HttpUtils.request(uamtkStatic, data: uamtkStaticData)
    // ]);
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
  print("_loginConf urlConfig:$urlConfig");

  /// 每碰到一次 await , await 下面的代码就会被放到 Future 的 then 里面调用
  /// 这样，代码执行是异步执行的，但是代码逻辑上是同步的
  var result = await HttpUtils.request(urlConfig);
  print("_loginConf result:${result.data} \n");
  if (result.success && result.data['is_login_passCode'] == "N") {
    print('不需要验证码');
    return false;
  }
  print('需要验证码');
  return true;
}
