import 'dart:io';
import 'package:dio/dio.dart';

void request(Map<String, Object> urlConfig, {dynamic data = null}) async {
  var log = urlConfig['is_logger'] ?? true;

  /// Http method.
  String _method = urlConfig['req_type'] ?? "get";
  _method = _method.toLowerCase();

  /// 路径
  String _url = urlConfig['req_url'] ?? "";

  /// 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
  String _baseUrl = urlConfig['Host'] ?? "";
  String _path = "https://$_baseUrl$_url";
  if (log) print("path is $_path");

  /// Http请求头.
  Map<String, dynamic> _headers = _createDefaultHeaders();
  _headers.update("Referer", urlConfig["Referer"] ?? "");
  // if( _method == "post" ) {
  //   _headers.update("Content-Length", "$data");
  // }

  /// 连接服务器超时时间，单位是毫秒.
  int _connectTimeout = 5000;

  ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
  ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
  ///  注意: 这并不是接收数据的总时限.
  int _receiveTimeout = 3000;

  /// 请求数据,可以是任意类型.
  var _data = data;

  /// 请求的Content-Type，默认值是[ContentType.JSON].
  /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
  /// 可以设置此选项为 `ContentType.parse("application/x-www-form-urlencoded")`,  这样[Dio]
  /// 就会自动编码请求体.
  ContentType _contentType =
      ContentType.parse("application/x-www-form-urlencoded");

  /// [responseType] 表示期望以那种格式(方式)接受响应数据。
  /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
  ///
  /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
  /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
  ///
  /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
  var isJson = urlConfig["is_json"] ?? false;
  ResponseType _responseType = isJson ? ResponseType.json : ResponseType.plain;

  Options _options = new Options(
    method: _method,
    connectTimeout: _connectTimeout,
    receiveTimeout: _receiveTimeout,
    headers: _headers,
    contentType: _contentType,
    responseType: _responseType,
  );
  // options.baseUrl
  try {
    Dio dio = Dio();
    _addInterceptor(dio);
    Response response =
        await dio.request(_path, data: _data, options: _options);
    if (log) print(response);
  } catch (e) {
    print(e);
  }
}

Map<String, dynamic> _createDefaultHeaders() {
  return {
    "Accept-Encoding": "gzip, deflate",
    "User-Agent":
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) 12306-electron/1.0.1 Chrome/59.0.3071.115 Electron/1.8.4 Safari/537.36",
    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
    "Origin": "https://kyfw.12306.cn",
    "Connection": "keep-alive"
  };
}

void _addInterceptor(Dio dio) {
  dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
    print("in requset interceptors RequestOptions headers:${options}");
    return options;
  }, onResponse: (Response response) {
    print("in response interceptors:${response.data}");
    return response;
  }, onError: (DioError error) {
    print("in requset interceptors:$error");
    return error;
  }));
}
