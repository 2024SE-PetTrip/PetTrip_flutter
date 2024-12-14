class ChatMessageModel {
  final String roomId;
  final int authorId;
  final String message;

  // Constructor
  ChatMessageModel({
    required this.roomId,
    required this.authorId,
    required this.message,
  });

  // fromJson: JSON 데이터를 객체로 변환
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      roomId: json['roomId'],   // 채팅방 ID
      authorId: json['authorId'], // 작성자 ID
      message: json['message'],  // 메시지 내용
    );
  }

  // toJson: 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'authorId': authorId,
      'message': message,
    };
  }
}
