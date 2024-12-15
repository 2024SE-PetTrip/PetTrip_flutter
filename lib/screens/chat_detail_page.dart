import 'package:flutter/material.dart';
import 'package:pettrip_fe/models/chat_room_model.dart';
import 'package:pettrip_fe/models/chat_message_model.dart';

import 'dart:convert';
import 'package:pettrip_fe/services/chat_message_service.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../const/colors.dart';
import '../const/secret_key.dart';
import '../services/token_storage.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatRoomModel room;
  const ChatDetailPage({super.key, required this.room});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late StompClient stompClient;
  late ChatMessageService chatMessageService;
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessageModel> _messages = [];
  bool isLoading = true;
  late String _jwtToken;

  @override
  void initState() {
    super.initState();
    chatMessageService = ChatMessageService();
    _loadChatHistory();
    _initializeWebSocketConnection();
  }

  @override
  void dispose() {
    _messageController.dispose();
    stompClient.deactivate();
    super.dispose();
  }
  Future<void> _initializeWebSocketConnection() async {
    // 1. JWT 토큰 로드
    await _loadJwtToken();

    // 2. WebSocket 연결
    if (_jwtToken != null) {
      _connectToWebSocket();
    } else {
      print("Error: JWT Token is null");
    }
  }

  // 채팅 기록 불러오기
  Future<void> _loadChatHistory() async {
    try {
      final messages = await chatMessageService.fetchChatHistory(widget.room.chatRoomId);
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  Future<void> _loadJwtToken() async {
    final jwtToken = await getToken();
    setState(() {
      _jwtToken = jwtToken!;
      isLoading = false;
    });
  }

  // WebSocket 연결
  void _connectToWebSocket() {
    stompClient = StompClient(
      config: StompConfig(
        url: wsUrl, // WebSocket URL
        onConnect: _onWebSocketConnect,
        onWebSocketError: (error) => print('WebSocket error: $error'),
        onDisconnect: (frame) => print('WebSocket disconnected'),
        onStompError: (frame) => print("Stomp error: ${frame.body}"),
        reconnectDelay: Duration(seconds: 5), // 재연결 딜레이

        stompConnectHeaders: {
      'Authorization': _jwtToken // 토큰 포함
      },
        webSocketConnectHeaders: {
          'Authorization': _jwtToken // 토큰 포함
        },
      ),
    );
    stompClient.activate();
  }

  void _onWebSocketConnect(StompFrame frame) {
    print('WebSocket connected');
    stompClient.subscribe(
      destination: '/sub/channel/${widget.room.chatRoomId}',
      callback: _onMessageReceived,
    );
  }

  // 메시지 수신 처리
  void _onMessageReceived(StompFrame frame) {
    if (frame.body != null) {
      final message = ChatMessageModel.fromJson(json.decode(frame.body!));
      setState(() {
        _messages.add(message);
      });
    }
  }

  // 4. 메시지 전송
  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final message = ChatMessageModel(
      roomId: widget.room.chatRoomId,
      authorId: widget.room.roomMakerId,
      message: messageText,
    );

    // WebSocket을 통해 메시지 전송
    stompClient.send(
      destination: '/pub/message',
      body: json.encode(message.toJson()),
    );

    // // 로컬 메시지 리스트에 추가
    // setState(() {
    //   _messages.add(message);
    // });

    _messageController.clear();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('시루'),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.authorId == widget.room.roomMakerId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? MAIN_COLOR : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: isMe ? Radius.circular(15) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : Radius.circular(15),
                      ),
                      border: Border.all(
                        color: isMe ? MAIN_COLOR : DARK_GRAY_COLOR,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(
                        color: isMe ? Colors.white : DARK_GRAY_COLOR,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요.',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

