import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../const/secret_key.dart';

class CourseService {
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));

  Future<void> saveCourse(Map<String, dynamic> courseData) async {
    try {
      debugPrint(courseData.toString());
      // TODO: URL 수정
      final response = await _dio.post('url',
          data: courseData);
    } catch (e) {
      print('Error: $e');
      throw Exception("코스 서버 저장 실패: $e");
    }
  }
}