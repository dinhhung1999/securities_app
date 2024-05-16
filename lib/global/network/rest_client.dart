import 'package:dio/dio.dart';
import 'package:securities_app/global/network/interceptor/logger_interceptor.dart';
import 'package:securities_app/global/network/interceptor/session_interceptor.dart';

class RestClient {
  RestClient(
      {required this.url,
      List<Interceptor>? interceptors,
      HttpClientAdapter? httpClientAdapter,
      Duration timeout = const Duration(seconds: 10)}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: url,
        contentType: "application/json",
        receiveDataWhenStatusError: true,
        connectTimeout: timeout,
        receiveTimeout: timeout,
      ),
    );
    if (httpClientAdapter != null) {
      _dio.httpClientAdapter = httpClientAdapter;
    }
    _dio.interceptors.addAll([
      SessionInterceptor(),
      LoggerInterceptor(),
      ...interceptors ?? [],
    ]);
  }

  final String url;

  late Dio _dio;

  BaseOptions get options => _dio.options;

  Interceptors get interceptors => _dio.interceptors;

  Dio get dio => _dio;
}
