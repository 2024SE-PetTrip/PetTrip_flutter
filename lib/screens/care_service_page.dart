import 'dart:async';

import 'package:flutter/material.dart';
import './care_find_page.dart';

class CareServicePage extends StatefulWidget {
  @override
  _CareServicePageState createState() => _CareServicePageState();
}

class _CareServicePageState extends State<CareServicePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Tab의 개수
      child: Scaffold(
        appBar: AppBar(
          title: Text('돌봄 요청'),
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.black, // 밑줄 색상
                width: 4.0, // 밑줄 두께
              ),
              insets: EdgeInsets.symmetric(horizontal: 100.0), // 밑줄 길이 조절
            ),
            labelColor: Colors.black, // 활성 탭 텍스트 색상
            unselectedLabelColor: Colors.grey, // 비활성 탭 텍스트 색상
            tabs: const [
              Tab(text: '돌봄찾기'), // 첫 번째 탭
              Tab(text: '채팅'), // 두 번째 탭
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: CareFindPage()), // 돌봄찾기
            Center(child: Text('채팅 화면 내용')), // 채팅방
          ],
        ),
      ),
    );
  }
}