library dio_log;

import 'dart:developer';

import 'package:dio/dio.dart';

class DioLog extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _logInfo('''
┌------------------------------------------------------------------------------
| #[DIO] Request
| -> Request: ${options.method} ${options.uri}
| -> Options: ${options.data.toString()}
|_______________________________________________________________________________
| Headers:
''');
    options.headers.forEach((key, value) {
      _logInfo('''
|\t$key: $value
''');
    });
    _logInfo('''
├------------------------------------------------------------------------------
''');
    handler.next(options);
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _logSuccess('''
┌------------------------------------------------------------------------------
| #[DIO] Response
| StatusCode: [${response.statusCode}]
|_______________________________________________________________________________
| -> Response: ${response.data.toString()}
└------------------------------------------------------------------------------
''');

    handler.next(response);
    return super.onResponse(response, handler);
  }

  @override
  Future onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logError('''
┌-------------------------------------------------------------------------------
| #[DIO-LOG] Error
| -> Type: ${err.type}
|_______________________________________________________________________________
| -> Error: ${err.error}: ${err.response.toString()}
|_______________________________________________________________________________
| -> Message: ${err.message}
└-------------------------------------------------------------------------------
''');

    handler.next(err); //
    return super.onError(err, handler);
  }

  // Green text
  void _logSuccess(String msg) {
    log('\x1B[32m$msg\x1B[0m');
  }

  // Red text
  void _logError(String msg) {
    log('\x1B[31m$msg\x1B[0m');
  }

  // Blue text
  void _logInfo(String msg) {
    log('\x1B[34m$msg\x1B[0m');
  }
}
