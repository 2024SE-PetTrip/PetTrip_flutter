class UserModel {
  final int id;
  final String realname;
  final String nickname;
  final String username;
  final String password;
  final String address;
  final String profileImageUrl;

  // Constructor
  UserModel({
    required this.id,
    required this.realname,
    required this.nickname,
    required this.username,
    required this.password,
    required this.address,
    required this.profileImageUrl,
  });

  // fromJson: JSON 데이터를 객체로 변환
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      realname: json['realname'],
      nickname: json['nickname'],
      username: json['username'],
      password: json['password'],
      address: json['address'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  // toJson: 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'realname': realname,
      'nickname': nickname,
      'username': username,
      'password': password,
      'address': address,
      'profileImageUrl': profileImageUrl,
    };
  }}
