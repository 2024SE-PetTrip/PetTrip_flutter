import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pettrip_fe/models/comment_model.dart';

import '../const/secret_key.dart';
import 'api_client.dart';

class CommentService{
  final Dio _dio = ApiClient(null).dio;

  Future<void> addComment(int courseId, Map<String, dynamic> commentData) async {
    try {
      final response = await _dio.post('/course/$courseId/addComment',
          data: commentData);
    } catch (e) {
      print('Error: $e');
      throw Exception("댓글 서버 저장 실패: $e");
    }
  }

  Future<List<CommentModel>> getCourseComments(int courseId) async{
    try {
      final response = await _dio.get('/course/$courseId/comments');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['result'] is List<dynamic>) {
          return (data['result'] as List<dynamic>)
              .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception("응답 데이터 형식이 올바르지 않습니다.");
        }
      } else {
        throw Exception("댓글 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("댓글 불러오기 실패: $e");
    }
  }
}