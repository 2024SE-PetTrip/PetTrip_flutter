import 'package:flutter/material.dart';
import 'package:pettrip_fe/models/chat_room_model.dart';
import 'package:pettrip_fe/services/chat_room_service.dart';
import 'package:pettrip_fe/screens/chat_detail_page.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  List<ChatRoomModel> _chatRooms = [];
  bool isLoading = false;
  final chatRoomService = ChatRoomService();

  Future<void> _fetchChatRooms() async {
    setState(() {
      isLoading = true;
    });

    try {
      final chatRooms = await chatRoomService.fetchChatRooms();
      setState(() {
        _chatRooms = chatRooms;
      });
    } catch(e) {
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load items: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _chatRooms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Room ID : ${_chatRooms[index].chatRoomId}'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetailPage(room: _chatRooms[index])
                          )
                      );
                    },
                  );
                }
              )
    );
  }
}
