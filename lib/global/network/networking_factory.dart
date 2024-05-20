import 'package:dio/dio.dart';
import 'package:securities_app/global/network/interceptor/logger_interceptor.dart';
import 'package:securities_app/global/network/interceptor/session_interceptor.dart';

class NetworkingFactory {
  static Dio createDio(
      {required String baseUrl,
      List<Interceptor>? interceptors,
      HttpClientAdapter? httpClientAdapter,
      Duration? timeout = const Duration(seconds: 10),
      bool isDebug = false}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: "application/json",
      receiveDataWhenStatusError: true,
      connectTimeout: timeout,
      receiveTimeout: timeout,
    ));

    if (httpClientAdapter != null) {
      dio.httpClientAdapter = httpClientAdapter;
    }
    dio.interceptors.addAll([
      SessionInterceptor(),
      LoggerInterceptor(),
      ...interceptors ?? [],
    ]);

    return dio;
  }
}
