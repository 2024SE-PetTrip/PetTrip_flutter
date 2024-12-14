import 'package:dio/dio.dart';
import 'package:pettrip_fe/models/pet_model.dart';

import 'package:pettrip_fe/const/secret_key.dart';

class PetService {
  final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl));

  Future<void> addPet(PetModel pet) async {
    try {
      final response = await _dio.post('url',
          data: pet.toJson());
    } catch (e) {
      print('Error: $e');
      throw Exception("펫 등록 실패: $e");
    }
  }
}