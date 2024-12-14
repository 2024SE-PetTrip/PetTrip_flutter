import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;
import 'package:pettrip_fe/models/care_model.dart';

import 'package:pettrip_fe/const/secret_key.dart';

class CareCommunityService{
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));

  static Future<List<CareModel>> fetchItems({String? title, String? location, String? breed}) async {
    final queryParameters = {
      //TODO: 필터 구현
      //아래는 예시 코드
      if (title != null && title.isNotEmpty) 'title': title,
      if (location != null && location.isNotEmpty) 'location': location,
      if (breed != null && breed.isNotEmpty) 'breed' : breed,
    };
    String baseUri = ' '; // TODO: URI 입력
    final uri = Uri.parse(baseUri).replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if(response.statusCode == 200){
      final decodedData = utf8.decode(response.bodyBytes);
      final List data = json.decode(decodedData);

      return data.map((data) => CareModel.fromJson(data)).toList();
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
      throw Exception("댓글 서버 저장 실패: $e");
    }
  }
}



