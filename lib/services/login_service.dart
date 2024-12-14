import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pettrip_fe/services/token_parser.dart';
import 'package:pettrip_fe/services/token_storage.dart';

import '../const/secret_key.dart';
import 'api_client.dart';

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
        ApiClient(_jwtToken);
        await saveToken(_jwtToken!); // 토큰 저장
        int? userId = await extractUserId(_jwtToken!);
        await saveUserId(userId!);
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

  Future<Map<String, dynamic>> join(Map<String, dynamic> joinData) async {
    try {
      final response = await _dio.post(
        '/user/join',
        data: joinData,
      );

      debugPrint('joindata: ' + joinData.toString());

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'message': '회원가입 실패: ${response.statusCode}'};
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // 서버에서 반환한 에러 처리
        return {'success': false, 'message': e.response?.data['message'] ?? '알 수 없는 오류 발생'};
      } else {
        // 요청이 도달하지 못했거나 다른 에러
        return {'success': false, 'message': '네트워크 오류 발생'};
      }
    }
  }
}