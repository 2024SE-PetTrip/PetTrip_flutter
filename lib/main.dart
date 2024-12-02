import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pettrip_fe/const/dummy_data.dart';
import 'package:pettrip_fe/const/secret_key.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/screens/course_detail_page.dart';
import 'package:pettrip_fe/screens/course_list_page.dart';
import 'package:pettrip_fe/screens/course_maker_page.dart';
import 'package:pettrip_fe/screens/care_service_page.dart';
import 'package:pettrip_fe/screens/create_group_page.dart';
import 'package:pettrip_fe/screens/group_detail_page.dart';
import 'package:pettrip_fe/screens/group_list_page.dart';

void main() async {
  await _initialize();
  runApp(MaterialApp(home: const MainPage()));
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      CourseMakerPage(),
      CourseListPage(),
      GroupListPage(),
      CareServicePage(),
      Placeholder(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      // 하단바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.pets), label: '코스생성'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: '코스찾기'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: '산책모임'),
            BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: '돌봄요청'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보')
          ],
        backgroundColor: Colors.white,
        selectedItemColor: MAIN_COLOR,
        unselectedItemColor: DARK_GRAY_COLOR,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap:(int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),);
  }
}