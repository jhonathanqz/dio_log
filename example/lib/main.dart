import 'package:dio/dio.dart';

import 'package:dio_logger_request/dio_logger_request.dart';

void main() async {
  Dio()
    ..interceptors.add(DioLoggerRequest())
    ..get("http://google.com.br"); //this prints to console
}
