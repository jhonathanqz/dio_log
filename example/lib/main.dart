import 'package:dio/dio.dart';

import 'package:dio_log/dio_log.dart';

void main() async {
  Dio()
    ..interceptors.add(DioLog())
    ..get("http://google.com.br"); //this prints to console
}
