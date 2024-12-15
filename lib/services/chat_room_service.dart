import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pettrip_fe/models/chat_room_model.dart';

import 'api_client.dart';


class ChatRoomService {
  final Dio _dio = ApiClient(null).dio;

  Future<List<ChatRoomModel>> fetchChatRooms(int userId) async {
    try {
      final response = await _dio.get('/care/chatRoom/$userId/myChatRooms');
      if(response.statusCode == 200){
        final List data = response.data;

        return data.map((data) => ChatRoomModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load chat rooms');
      }
    } catch(e) {
      print('Error: $e');
      throw Exception('$e');
    }
  }

  Future<void> createChatRoom(int roomMakerId, int guestId) async {
    try {
      final response =
      await _dio.post('/care/chatRoom/personal', data: {
        "roomMakerId": roomMakerId,
        "guestId": guestId
      });
    } catch (e) {
      print('Error: $e');
      throw Exception("채팅방 개설 실패: $e");
    }
  }


}