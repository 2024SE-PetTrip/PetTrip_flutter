import 'package:dio/dio.dart';
import 'package:pettrip_fe/models/pet_model.dart';

import 'package:pettrip_fe/const/secret_key.dart';

import 'api_client.dart';

class PetService {
  final Dio _dio = ApiClient(null).dio;

  Future<void> addPet(PetModel pet) async {
    try {
      final response = await _dio.post('/pet/add',
          data: pet.toJson());
    } catch (e) {
      print('Error: $e');
      throw Exception("펫 등록 실패: $e");
    }
  }
}