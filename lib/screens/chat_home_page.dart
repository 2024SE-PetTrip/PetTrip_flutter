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
      // 임시 아이디
      final chatRooms = await chatRoomService.fetchChatRooms(16);
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
                  return GestureDetector(
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipOval(
                            child: Icon(
                              Icons.person,
                              size: 60,
                            ),
                          ),
                        ),
                        Text("시루",)
                      ],
                    ),
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
