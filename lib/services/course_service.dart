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
      final response = await _dio.post('/course/create',
          data: courseData);
    } catch (e) {
      print('Error: $e');
      throw Exception("코스 서버에 저장 실패: $e");
    }
  }

  // 코스 업데이트
  Future<void> updateCourse(int courseId, Map<String, dynamic> courseData) async {
    try {
      debugPrint(courseData.toString());
      final response = await _dio.post('/course/update/$courseId',
          data: courseData);
    } catch (e) {
      print('Error: $e');
      throw Exception("코스 업데이트 실패: $e");
    }
  }

  // 모든 공개 코스 불러오기
  Future<List<CourseModel>> getAllCourses() async {
    try {
      final response = await _dio.get('/course/all');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => CourseModel.fromJson(json)).toList();
      } else {
        throw Exception("전체 코스 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("전체 코스 불러오기 실패: $e");
    }
  }

  // 유저의 비공개 코스 모두 불러오기
  Future<List<CourseModel>> getUserCourses(int userId) async {
    try {
      final response = await _dio.get('/course/user/$userId');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => CourseModel.fromJson(json)).toList();
      } else {
        throw Exception("유저 코스 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("유저 코스 불러오기 실패: $e");
    }
  }

  // 코스 좋아요
  Future<void> likeCourse(int courseId) async {
    try {
      final response = await _dio.post('/course/$courseId/like');
    } catch (e) {
      print('Error: $e');
      throw Exception("좋아요 누르기 실패: $e");
    }
  }

  // 코스 좋아요 취소
  Future<void> disLikeCourse(int courseId) async {
    try {
      final response = await _dio.post('/course/$courseId/dislike');
    } catch (e) {
      print('Error: $e');
      throw Exception("좋아요 취소 실패: $e");
    }
  }
}