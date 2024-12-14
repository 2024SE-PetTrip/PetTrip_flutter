import 'dart:convert';

import 'package:flutter/cupertino.dart';

Future<int?> extractUserId(jwtToken) async{
  final token = jwtToken.replaceFirst('Bearer ', '');
  final parts = jwtToken?.split('.');
  if (parts?.length != 3) return null; // JWT 형식 확인

  final payload = parts?[1]; // 두 번째 부분이 페이로드
  final normalizedPayload = base64Url.normalize(payload!);
  final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));

  final payloadMap = jsonDecode(decodedPayload);
  return payloadMap['id'];
}
