import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

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
}