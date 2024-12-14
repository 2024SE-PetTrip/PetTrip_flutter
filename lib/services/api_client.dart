import 'package:dio/dio.dart';
import '../const/secret_key.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  final Dio _dio;

  factory ApiClient(String? jwtToken) {
    if (jwtToken != null) {
      _instance._dio.options.headers['Authorization'] = '$jwtToken';
    }
    return _instance;
  }

  ApiClient._internal()
      : _dio = Dio(BaseOptions(baseUrl: backendUrl)) {
    // 인터셉터 추가
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request to ${options.uri}');
        return handler.next(options);
      },
      onError: (DioError e, handler) {
        print('Error from ${e.requestOptions.uri}: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}