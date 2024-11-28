import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pettrip_fe/models/chat_room_model.dart';


class ChatRoomService {
  static Future<List<ChatRoomModel>> fetchChatRooms() async {
    try {
      final response = await http.get(Uri.parse(''));
      if(response.statusCode == 200){
        final decodedData = utf8.decode(response.bodyBytes);
        final List data = json.decode(decodedData);

        return data.map((data) => ChatRoomModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load chat rooms');
      }
    } catch(e) {
      print('Error: $e');
      throw Exception('$e');
    }






  }
}