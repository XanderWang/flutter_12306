import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:crypto/crypto.dart';

/// Md5加密
String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return digest.toString();
}

/// Base64加密
String encodeBase64(String data) {
  var content = utf8.encode(data);
  var digest = base64Encode(content);
  return digest;
}

/// Base64解密
String decodeBase64(String data) {
  return String.fromCharCodes(base64Decode(data));
}

/// 通过图片路径将图片转换成Base64字符串
Future<String> image2Base64(String path) async {
  File file = new File(path);
  List<int> imageBytes = await file.readAsBytes();
  return base64Encode(imageBytes);
}

/// 将加密的 base64 字符串转化为 png 并保存
Future<File> base64String2Image(String path, String base64) async {
  File file = new File(path);
  file.writeAsBytesSync(base64Decode(base64));
  return file;
}
