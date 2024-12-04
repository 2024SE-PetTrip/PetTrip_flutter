import 'package:flutter/material.dart';
import 'package:pettrip_fe/models/chat_room_model.dart';
import 'package:pettrip_fe/models/chat_message_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pettrip_fe/services/chat_message_service.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatRoomModel room;
  const ChatDetailPage({super.key, required this.room});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late StompClient stompClient;
  late ChatMessageService chatMessageService;
  TextEditingController _messageController = TextEditingController();
  List<ChatMessageModel> _messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    chatMessageService = ChatMessageService();
    _loadChatHistory();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  // 채팅 기록 불러오기
  Future<void> _loadChatHistory() async {
    try {
      final messages = await chatMessageService.fetchChatHistory(widget.room.chatRoomId);
      setState(() {
        _messages = messages;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading chat history: $e');
    }
  }

  // WebSocket 연결
  void _connectToWebSocket() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/chat/inbox', // WebSocket URL
        onConnect: _onWebSocketConnect,
        onWebSocketError: (error) => print('WebSocket error: $error'),
        onDisconnect: (frame) => print('WebSocket disconnected'),
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
      destination: '/pub/message/',
      body: json.encode(message.toJson()),
    );

    // 로컬 메시지 리스트에 추가
    setState(() {
      _messages.add(message);
    });

    _messageController.clear();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.room.guestId}'),
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
                return ListTile(
                  title: Text(
                    message.message,
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      color: isMe ? Colors.blue : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'User: ${message.authorId}',
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
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
                      hintText: '메세지를 입력하세요.',
                      border: OutlineInputBorder(),
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

