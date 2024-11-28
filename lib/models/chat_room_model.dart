class ChatRoomModel {
  final String chatRoomId;
  final int roomMakerId;
  final int guestId;

  // Constructor
  ChatRoomModel({
    required this.chatRoomId,
    required this.roomMakerId,
    required this.guestId,
  });

  // fromJson: JSON 데이터를 객체로 변환
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatRoomId: json['chatRoomId'],  // chatRoomId
      roomMakerId: json['roomMakerId'], // roomMakerId
      guestId: json['guestId'],         // guestId
    );
  }

  // toJson: 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'roomMakerId': roomMakerId,
      'guestId': guestId,
    };
  }
}
