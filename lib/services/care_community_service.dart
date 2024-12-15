import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pettrip_fe/models/care_model.dart';

import 'api_client.dart';

import 'package:pettrip_fe/const/secret_key.dart';

class CareCommunityService{
  final Dio _dio = ApiClient(null).dio;

  Future<List<CareModel>> fetchItems({String? title, String? location, String? breed}) async {
    final queryParameters = {
      if (title != null && title.isNotEmpty) 'title': title,
      if (location != null && location.isNotEmpty) 'location': location,
      if (breed != null && breed.isNotEmpty) 'breed': breed,
    };

    String baseUri = '/care/all'; // Care 리스트 조회 API

    try {
      // 첫 번째 API 호출: Care 리스트 조회
      final response = await _dio.get(baseUri, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        final List data = response.data['result']; // GetCareDTO 리스트
        List<CareModel> careList = await Future.wait(data.map((item) async {
          // 개별 Care 요청 상세 조회 호출
          return await _fetchCareDetail(item['requestId']);
        }));
        return careList;
      } else {
        throw Exception("Failed to load Care list");
      }
    } catch (e) {
      throw Exception("Error while fetching care requests: $e");
    }
  }

// Care 요청 상세 조회 호출 메서드
  Future<CareModel> _fetchCareDetail(int requestId) async {
    String detailUri = '/care/$requestId'; // Care 요청 상세 조회 API

    try {
      final response = await _dio.get(detailUri);

      if (response.statusCode == 200) {
        final detailData = response.data['result']; // GetCareDetailDTO
        return CareModel.fromJson(detailData); // CareModel 생성
      } else {
        throw Exception("Failed to load Care details for ID: $requestId");
      }
    } catch (e) {
      throw Exception("Error while fetching care detail for ID $requestId: $e");
    }
  }

  Future<void> addCareRequest(CareRequestDTO careRequestDTO) async {
    try {
      final response = await _dio.post('/care/add',
          data: careRequestDTO.toJson());
    } catch (e) {
      print('Error: $e');
      throw Exception("돌봄 요청 실패: $e");
    }
  }
}



