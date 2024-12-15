class UserModel {
  final String nickname;
  final String address;
  final String? profileImageUrl;

  // Constructor
  UserModel({
    required this.nickname,
    required this.address,
    this.profileImageUrl,
  });

  // fromJson: JSON 데이터를 객체로 변환
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nickname: json['result']['nickname'],
      address: json['result']['address'],
      profileImageUrl: json['result']['profileImageUrl'] ?? '',
    );
  }

  // toJson: 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'address': address,
      'profileImageUrl': profileImageUrl,
    };
  }
}
