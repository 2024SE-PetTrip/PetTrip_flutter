import 'package:dio/dio.dart';
import 'package:pettrip_fe/models/user_model.dart';

import 'package:pettrip_fe/const/secret_key.dart';

class UserService {
  // 서버 URL
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));

  Future<UserModel> getProfile(String userID) async {
    try {
      final response = await _dio.get('/user/profile/$userID');

      if (response.statusCode == 200) {
        var data = response.data;
        return UserModel.fromJson(data);
      } else {
        throw Exception("유저 정보 로딩 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("유저 정보 로딩 실패: $e");
    }
  }
}