

// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';
import 'package:dio/dio.dart';

class SessionInterceptor implements InterceptorsWrapper {
  @override
  void onError(err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      //todo handle 401
      return;
    }
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(<String, dynamic>{
      //todo add token
    });
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
