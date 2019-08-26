import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Md5加密
String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return digest.toString();
}

///Base64加密
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
Future image2Base64(String path) async {
  File file = new File(path);
  List<int> imageBytes = await file.readAsBytes();
  return base64Encode(imageBytes);
}

///将加密的 base64 字符串转化为 png 并保存
Future base64String2Image(String path, String base64) async {
  // String de = "iVBORw0KGgoAAAANSUhEUgAAAEYAAAAjCAIAAACmdes6AAACP0lEQVR4Xu2W0U3EQAxETxSA+OMnFdAL30AV1EUproB2SGJwhpldZ7MJEBDSfCT22Ot3vj3dxV5f/pguGvrt+kf6Mg2P9xrs01mQbKY6BOxESK79YKdDcu0BOwype4JEfT1PjWRd6zo7kmsTWCvSzfXzKAo+PdyFxiPxVW2X26ui0KlZ9DSC7UJyIZJmyaaDqnLPKlgTkvPUkGweN7akWTd4Kpk1lHgCJqFaR3KSHMnmM3Ikf0jGDSUeJKmt63gkpcJgMm4o8SiDgq0gBcYmJKSi12TcRo9SeTDiGVIweEGO5DZC0qWNg+rnSgokdPqzCgv9tYpEaxmfa41CHsddEY9VxtU+dBZFsFBTGRK9YqTW3T4jUU+TLxV1QE/xiCjRqqVcQyY8HtGgS89uQUJ5bTGoo+txfISGiqMnSCE8bKj8psfEtfLw1Ob+biSDFRXPTpCiyTBvTGvJU0yZIsXcVNaIhJvBS4V4OZLBr2Jt7iQ1leOLz03C7hHURvaBhBG9VKvjuie31eLv5fiiPAme9kqQIk5fvGIrvUtkS2aYyjVUlC4H8RymeAZRrd6l8OjcRFg8bip3hyZIioSi26LZQ5BctfhSHj7NoRKkGDeaIN7w+b/ffiTsr6mpPEyaQ21CIiFeICVUhERtMYjZeFjuUm0glyLhZ+/SDrofxUM/AqMNq9zpDxhf/NgxCvq0tZxGqWW10LMa9PhPIpEIrw/J9Ec8sbZoZ3mI8FS1uJ0Wyda25AYNmiIl1hbtqSV1I70B+dAU/4dAw64AAAAASUVORK5C";
  File file = new File(path);
  file.writeAsBytesSync(base64Decode(base64));
  return file;
}
