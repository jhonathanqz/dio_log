// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class DioLoggerRequest extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _logInfo('''
┌==============================================================================
| #[DIO] Request
| => Request: ${options.method} ${options.uri}
| => Path: ${options.path}
| => Options: ${options.data.toString()}
|_______________________________________________________________________________
| Headers:
''');
    options.headers.forEach((key, value) {
      _logInfo('''
|\t$key: $value
''');
    });
    _logInfo('''
├==============================================================================
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
┌==============================================================================
| #[DIO] Response
| StatusCode: [${response.statusCode}]
| StatusMessage: [${response.statusMessage}]
|_______________________________________________________________________________
| => Response: ${response.data.toString()}
└==============================================================================
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
┌===============================================================================
| #[DIO=LOG] Error
| => Type: ${err.type.toString()}
| => Path: ${err.requestOptions.path}
|_______________________________________________________________________________
| => Error: ${err.error.toString()}: ${err.response.toString()}
|_______________________________________________________________________________
| => Message: ${err.message}
└===============================================================================
''');

    handler.next(err); //
    return super.onError(err, handler);
  }
}

// Green text
void _logSuccess(String msg) {
  print('\x1B[32m$msg\x1B[0m');
}

// Red text
void _logError(String msg) {
  print('\x1B[31m$msg\x1B[0m');
}

// Blue text
void _logInfo(String msg) {
  print('\x1B[34m$msg\x1B[0m');
}

final dioLoggerRequestInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, handler) {
    _logInfo("┌------------------------------------------------------------------------------");
    _logInfo('| [DIO] Request: ${options.method} ${options.uri}');
    _logInfo('| ${options.data.toString()}');
    _logInfo('| Headers:');
    options.headers.forEach(
      (key, value) {
        _logInfo('|\t$key: $value');
      },
    );
    _logInfo("├------------------------------------------------------------------------------");
    handler.next(options);
  },
  onResponse: (Response response, handler) async {
    _logSuccess("| [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}");
    _logSuccess("└------------------------------------------------------------------------------");
    handler.next(response);
  },
  onError: (DioException error, handler) async {
    _logError("| [DIO] Error: ${error.error}: ${error.response.toString()}");
    _logError("└------------------------------------------------------------------------------");
    handler.next(error);
  },
);
