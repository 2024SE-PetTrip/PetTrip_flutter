import 'package:flutter/material.dart';
import 'package:pettrip_fe/models/chat_room_model.dart';
import 'package:pettrip_fe/models/user_model.dart';
import 'package:pettrip_fe/services/chat_room_service.dart';
import 'package:pettrip_fe/screens/chat/chat_detail_page.dart';

import '../../services/token_storage.dart';
import '../../services/user_service.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  List<ChatRoomModel> _chatRooms = [];
  bool isLoading = false;
  final chatRoomService = ChatRoomService();
  int? _userId;
  List<UserModel>? _others;

  Future<void> _fetchChatRooms() async {
    setState(() {
      isLoading = true;
    });

    try {
      _initializeUserId();
      final chatRooms = await chatRoomService.fetchChatRooms(_userId!);
      setState(() {
        _chatRooms = chatRooms;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load items: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initializeUserId() async {
    final userId = await getUserId();
    debugPrint("유저아이디: $userId");
    setState(() {
      _userId = userId;
    });
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      isLoading = true;
    });
    List<UserModel> fetchedUsers = [];
    try {
      for (var chatRoom in _chatRooms) {
        int otherUserId;

        // roomMakerId와 guestId 중 _userId가 아닌 쪽 선택
        if (chatRoom.roomMakerId == _userId) {
          otherUserId = chatRoom.guestId;
        } else {
          otherUserId = chatRoom.roomMakerId;
        }

        // 다른 유저의 프로필 데이터 가져오기
        UserModel otherUser =
            await UserService().getProfile(otherUserId as String);

        fetchedUsers.add(otherUser);
      }

      setState(() {
        _others = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      throw Exception("프로필 로딩 실패");
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
                      children: [
                        _others![index].profileImageUrl == ''
                            ? ClipOval(
                                child: Image.network(
                                    _others![index].profileImageUrl!,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover))
                            : SizedBox(
                                width: 80,
                                height: 80,
                                child: ClipOval(
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  ),
                                ),
                              ),
                        Text(_others![index].nickname)
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetailPage(
                                    room: _chatRooms[index],
                                    meId: _userId!,
                                    other: _others![index],
                                  )));
                    },
                  );
                }));
  }
}
