import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pettrip_fe/models/chat_room_model.dart';

import 'package:pettrip_fe/models/chat_message_model.dart';

class ChatMessageService {
  // 1. 채팅 기록 불러오기
  Future<List<ChatMessageModel>> fetchChatHistory(String roomId) async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => ChatMessageModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load chat history');
      }
    } catch (e) {
      print('Error fetching chat history: $e');
      rethrow; // 에러를 상위로 전달
    }
  }
}
