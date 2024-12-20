import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pettrip_fe/const/secret_key.dart';
import 'package:pettrip_fe/screens/login/login_page.dart';
import 'package:pettrip_fe/screens/main_page.dart';

void main() async {
  await _initialize();
  runApp(MyApp());
}

Future<void> _initialize() async {
  // 네이버맵 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: naverMapID,
      onAuthFailed: (error) {
        print('네이버맵 인증 오류: $error');
      });

  // 위치 권한 얻기
  var requestStatus = await Permission.location.request();
  var status = await Permission.location.status;
  if (requestStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
    openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // 앱 실행 시 로그인 화면부터 표시
      routes: {
        '/login': (context) => LoginPage(), // 로그인 화면
        '/home': (context) => MainPage(), // 메인 화면
      },
    );
  }
}