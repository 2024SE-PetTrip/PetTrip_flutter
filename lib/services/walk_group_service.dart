import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../const/secret_key.dart';

class WalkGroupService {
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));

  // 산책 모임 저장
  Future<void> saveWalkGroup(Map<String, dynamic> groupData) async {
    try {
      debugPrint(groupData.toString());
      final response = await _dio.post('/walk/add',
          data: groupData);
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 서버 저장 실패: $e");
    }
  }
}