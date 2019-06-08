import 'dart:io';
import 'package:dio/dio.dart';

class DataResponse {
  /// 请求结果， true 表示请求到结果
  var success = false;

  /// 结果编码 0 表示没有异常，其他表示有异常
  int code = 0;

  /// 请求结果异常的时候，错误提示
  var msg = "";

  /// 网络请求结果
  dynamic data;

  DataResponse(this.success, this.msg, this.data);

  DataResponse.error(int code, String msg) {
    this.success = false;
    this.code = code;
    this.msg = msg;
    this.data = null;
  }

  DataResponse.data(dynamic data) {
    this.success = true;
    this.code = 0;
    this.msg = "";
    this.data = data;
  }

  @override
  String toString() {
    return "{success:$success,msg:$msg,code:$code,data:$data}";
  }
}

Future<DataResponse> request(Map<String, Object> urlConfig,
    {Map<String, dynamic> data}) async {
  var useLog = urlConfig['is_logger'] ?? true;
  useLog = true;

  /// Http method.
  String _method = urlConfig['req_type'] ?? "GET";
  _method = _method.toUpperCase();
  if (useLog) print("http request method:$_method");

  /// 路径
  String _url = urlConfig['req_url'] ?? "";

  /// 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
  String _baseUrl = urlConfig['Host'] ?? "";
  String _path = "https://$_baseUrl$_url";
  if (useLog) print("http request path:$_path");

  /// Http请求头.
  Map<String, String> _headers = _createDefaultHeaders();
  _headers["Referer"] = urlConfig["Referer"] ?? "";
  // if( _method == "post" ) {
  //   _headers.["Content-Length"] = "$data";
  // }

  /// 连接服务器超时时间，单位是毫秒.
  int _connectTimeout = 5000;

  ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
  ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
  ///  注意: 这并不是接收数据的总时限.
  int _receiveTimeout = 3000;

  /// 请求数据,可以是任意类型.
  var _data = data ?? {};
  if (useLog) print("http request data:$_data");

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

  try {
    Dio dio = Dio();
    _addInterceptor(dio);
    Response response =
        await dio.request(_path, data: _data, options: _options);
    // print(response);
    if (response.statusCode == 200 || response.statusCode == 303) {
      if (useLog && isJson) {
        print("http request response.data:${response.data}");
      }
      return DataResponse.data(response.data);
    } else {
      return DataResponse.error(10, "${response.statusMessage}");
    }
  } on DioError catch (e) {
    print(e);
    return DataResponse.error(10, "${e.message}");
  }
}

Map<String, String> _createDefaultHeaders() {
  return {
    "Accept-Encoding": "gzip, deflate",
    "User-Agent":
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) 12306-electron/1.0.1 Chrome/59.0.3071.115 Electron/1.8.4 Safari/537.36",
    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
    "Origin": "https://kyfw.12306.cn",
    "Connection": "keep-alive"
  };
}

void _addInterceptor(Dio dio, {bool useLog = false}) {
  dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
    if (useLog) _printRequestOptions(options);
    return options;
  }, onResponse: (Response response) {
    // response.statusCode = 404;
    if (useLog) print("in response interceptors:${response.toString()}");
    return response;
  }, onError: (DioError error) {
    if (useLog) print("in requset interceptors:$error");
    return error;
  }));
}

void _printRequestOptions(RequestOptions options) {
  // print("RequestOptions ${options.path},${options.cookies},${options.headers}");
  print("RequestOptions ${options.path}");
}
