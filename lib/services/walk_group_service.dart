import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pettrip_fe/models/walk_group_model.dart';

import '../const/secret_key.dart';

class WalkGroupService {
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));

  // 산책 모임 저장
  Future<void> saveWalkGroup(Map<String, dynamic> groupData) async {
    try {
      debugPrint(groupData.toString());
      final response = await _dio.post('/walk/add', data: groupData);
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 서버 저장 실패: $e");
    }
  }

  // 모든 산책 모임 불러오기
  Future<List<WalkGroupModel>> getAllGroups() async {
    try {
      final response = await _dio.get('/walk/all');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => WalkGroupModel.fromJson(json)).toList();
      } else {
        throw Exception("전체 산책 모임 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("전체 산책 모임 불러오기 실패: $e");
    }
  }

  // 참가 신청자 및 멤버 불러오기
  Future<Map<String, List<Map<String, String>>>> getApplicantsAndMembers(int groupId, int creatorId) async {
    try {
      final response = await _dio.get(
        '/walk/$groupId/creator-detail',
        queryParameters: {'creatorId': creatorId},
      );

      if (response.statusCode == 200) {
        final data = response.data['members'] as List<dynamic>;

        // applicants와 members로 분류
        final List<Map<String, String>> applicants = [];
        final List<Map<String, String>> members = [];

        for (var member in data) {
          if (member['isApproved'] == true) {
            members.add({
              'userId': member['userId'].toString(),
            });
          } else {
            applicants.add({
              'userId': member['userId'].toString(),
            });
          }
        }

        return {
          'applicants': applicants,
          'members': members,
        };
      } else {
        throw Exception("모임 세부 정보 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("모임 세부 정보 불러오기 실패: $e");
    }
  }

  // 참가 신청
  Future<void> submitApplicant(int groupId, int userId) async {
    try {
      final response = await _dio.post('/walk/join',
          data: {'userId': userId, 'groupId': groupId});
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 참가 신청 실패: $e");
    }
  }

  // 참가 신청 수락
  Future<void> acceptApplicant(int groupId, int userId) async {
    try {
      final response = await _dio.post('/$groupId/creator-detail/applicants/$userId/accept');
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 신청 수락 실패: $e");
    }
  }

  // 참가 신청 거절
  Future<void> rejectApplicant(int groupId, int userId) async {
    try {
      final response = await _dio.post('/$groupId/creator-detail/applicants/$userId/reject');
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 신청 거절 실패: $e");
    }
  }

  // 멤버 삭제
  Future<void> removeMember(int groupId, int userId) async {
    try {
      final response = await _dio.post('/$groupId/creator-detail/members/$userId/delete');
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 멤버 삭제 실패: $e");
    }
  }
}
