import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pettrip_fe/models/care_model.dart';

import 'api_client.dart';

import 'package:pettrip_fe/const/secret_key.dart';

class CareCommunityService{
  final Dio _dio = ApiClient(null).dio;

  Future<List<CareModel>> fetchItems({String? title, String? location, String? breed}) async {
    final queryParameters = {
      //TODO: 필터 구현
      //아래는 예시 코드
      if (title != null && title.isNotEmpty) 'title': title,
      if (location != null && location.isNotEmpty) 'location': location,
      if (breed != null && breed.isNotEmpty) 'breed' : breed,
    };
    String baseUri = '/care/all'; // TODO: URI 입력
    final response = await _dio.get(baseUri, queryParameters: queryParameters);

    if(response.statusCode == 200){
      final List data = response.data;
      return data.map((item) => CareModel.fromJson(item)).toList();
    }
    else {
      throw Exception("Failed to load data");
    }
  }
  Future<void> addCareRequest(CareRequestDTO careRequestDTO) async {
    try {
      final response = await _dio.post('url',
          data: careRequestDTO);
    } catch (e) {
      print('Error: $e');
      throw Exception("돌봄 요청 실패: $e");
    }
  }
}



