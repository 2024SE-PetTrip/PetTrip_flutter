import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

// JWT 토큰 저장
Future<void> saveToken(String token) async {
  await secureStorage.write(key: 'jwtToken', value: token);
}

// JWT 토큰 읽기
Future<String?> getToken() async {
  return await secureStorage.read(key: 'jwtToken');
}

// JWT 토큰 삭제
Future<void> deleteToken() async {
  await secureStorage.delete(key: 'jwtToken');
}

// userId 저장
Future<void> saveUserId(int userId) async {
  await secureStorage.write(key: 'userId', value: userId.toString());
}

// userId 읽기
Future<int?> getUserId() async {
  String? userId = await secureStorage.read(key: 'userId');
  return userId != null ? int.tryParse(userId) : null;
}

// userId 삭제
Future<void> deleteUserId() async {
  await secureStorage.delete(key: 'userId');
}