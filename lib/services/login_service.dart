import 'package:dio/dio.dart';

import '../const/secret_key.dart';

class LoginService {
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));
  String? _jwtToken;

  // 로그인 요청
  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'username': username,
          'password': password
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // Response Header에서 JWT Token 추출
      _jwtToken = response.headers['authorization']?.first;

      if (_jwtToken != null) {
        _dio.options.headers['Authorization'] = 'Bearer $_jwtToken'; // 이후 요청에 JWT Token 추가
        return _jwtToken;
      } else {
        throw Exception('JWT Token 반환 안 됨');
      }
    } catch (e) {
      print('로그인 실패: $e');
      return null;
    }
  }

  // 로그아웃
  void logout() {
    _jwtToken = null;
    _dio.options.headers.remove('Authorization');
  }
}