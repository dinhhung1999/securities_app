
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LoggerInterceptor extends PrettyDioLogger {
  LoggerInterceptor()
      : super(
    requestHeader: kDebugMode,
    requestBody: kDebugMode,
    responseBody:kDebugMode,
    responseHeader: kDebugMode,
    error: kDebugMode,
    compact: kDebugMode,
  );
}
