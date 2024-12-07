import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../const/secret_key.dart';

class CommentService{
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));

  Future<void> saveComment(Map<String, dynamic> commentData) async {
    try {
      debugPrint(commentData.toString());
      // TODO: URL 수정
      final response = await _dio.post('url',
          data: commentData);
    } catch (e) {
      print('Error: $e');
      throw Exception("댓글 서버 저장 실패: $e");
    }
  }
}