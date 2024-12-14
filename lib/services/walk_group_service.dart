import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pettrip_fe/models/walk_group_model.dart';

import '../const/secret_key.dart';
import 'api_client.dart';

class WalkGroupService {
  final Dio _dio = ApiClient(null).dio;

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
      // 첫 번째 API 호출: 모든 산책 모임 목록 가져오기
      final response = await _dio.get('/walk/all');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['result'] is List<dynamic>) {
          List<dynamic> groupList = data['result'];

          // 각 그룹에 대해 상세 정보를 추가로 불러오기
          for (var group in groupList) {
            var groupId = group['groupId'];
            var groupDetailResponse = await _dio.get('/walk/$groupId'); // 두 번째 API 호출
            var groupDetail = groupDetailResponse.data;

            // 두 번째 API 응답에서 받은 상세 정보를 첫 번째 API 응답에 추가
            group['courseId'] = groupDetail['result']['courseId'];
            group['creatorId'] = groupDetail['result']['creatorId'];
            group['startDate'] = groupDetail['result']['startDate'];
            group['endDate'] = groupDetail['result']['endDate'];
            group['walkingDate'] = groupDetail['result']['walkingDate'];
            group['maxParticipants'] = groupDetail['result']['maxParticipants'];
            group['maxPetsPerUser'] = groupDetail['result']['maxPetsPerUser'];
            group['groupDescription'] = groupDetail['result']['groupDescription'];
            group['groupAddress'] = groupDetail['result']['groupAddress'];
            group['tags'] = groupDetail['result']['tags'];
            group['members'] = groupDetail['result']['members'];
          }

          // 첫 번째 API에서 받은 데이터를 `WalkGroupModel.fromJson`을 사용해 객체로 변환
          return groupList.map((json) => WalkGroupModel.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception("응답 데이터 형식이 올바르지 않습니다.");
        }
      } else {
        throw Exception("전체 산책 모임 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("전체 산책 모임 불러오기 실패: $e");
    }
  }


  // 참가 신청자 및 멤버 불러오기
  Future<Map<String, List<Map<String, dynamic>>>> getApplicantsAndMembers(int groupId, int creatorId) async {
    try {
      final response = await _dio.get(
        '/walk/$groupId/creator-detail',
        queryParameters: {'creatorId': creatorId},
      );

      if (response.statusCode == 200) {
        final data = response.data['result']['members'] as List<dynamic>;

        // applicants와 members로 분류
        final List<Map<String, dynamic>> applicants = [];
        final List<Map<String, dynamic>> members = [];

        for (var member in data) {
          if (member['approved'] == true) {
            members.add({
              'userId': member['userId'],
              'nickname': member['nickname'].toString(),
              'profileImageUrl': member['profileImageUrl'].toString(),
            });
          } else {
            applicants.add({
              'userId': member['userId'],
              'nickname': member['nickname'].toString(),
              'profileImageUrl': member['profileImageUrl'].toString(),
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
      final response = await _dio.post('/walk/$groupId/creator-detail/applicants/$userId/accept');
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 신청 수락 실패: $e");
    }
  }

  // 참가 신청 거절
  Future<void> rejectApplicant(int groupId, int userId) async {
    try {
      final response = await _dio.delete('/walk/$groupId/creator-detail/applicants/$userId/reject');
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 신청 거절 실패: $e");
    }
  }

  // 멤버 삭제
  Future<void> removeMember(int groupId, int userId) async {
    try {
      final response = await _dio.delete('/walk/$groupId/creator-detail/members/$userId/delete');
    } catch (e) {
      print('Error: $e');
      throw Exception("산책 모임 멤버 삭제 실패: $e");
    }
  }
}
