import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pettrip_fe/models/course_model.dart';

import '../const/secret_key.dart';

class CourseService {
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));

  // 코스 저장
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

  // 유저의 저장 코스 모두 불러오기
  Future<List<CourseModel>> getUserCourses(String userID) async {
    try {
      final response = await _dio.get('url');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => CourseModel.fromJson(json)).toList();
      } else {
        throw Exception("수리 요청 목록 로딩 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("수리 요청 목록 로딩 실패: $e");
    }
  }

  Future<void> likeCourse(String courseID) async {
    try {
      // TODO: URL 수정
      final response = await _dio.post('url',
          data: courseID);
    } catch (e) {
      print('Error: $e');
      throw Exception("좋아요 누르기 실패: $e");
    }
  }
}