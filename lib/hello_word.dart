import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

/// 配合安装 dart sdk , 方便调试
/// dart sdk 可以在 flutter\bin\cache\dart-sdk\bin 下面找到
void main() {
  // print("hello flutter");
  // print("你好啊");
  // print(new TestA(1, 2));
  // print(TestA.empty());
  // print(TestA.forX(33));
  // print(TestA.forY());
  // outter(print_msg);
//   getNet_3();
  var line = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  print("read line:$line");

}

outer(inner(String inner_msg)) {
  print("now in outter");
  inner("I am value in out.");
}

print_msg(String msg) {
  print("in print msg method, $msg");
}

void getNet_3() async {
  var url = 'https://wanandroid.com/wxarticle/chapters/json';
  Dio dio = new Dio();
  var response = await dio.get(url);
  print("getNet_3 $response.data.toString()");
}

class TestA {
  num x = -1, y = -1;
  TestA(this.x, this.y);

  TestA.empty() {
    x = 0;
    y = 0;
  }

  TestA.forX(this.x);

  TestA.forY() {
    y = 100;
  }

  @override
  String toString() {
    return "x=$x , y=$y";
  }
}
