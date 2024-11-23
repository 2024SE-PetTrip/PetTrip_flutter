import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pettrip_fe/widgets/save_course_form.dart';

import '../services/location_service.dart';

class SaveCoursePage extends StatelessWidget {
  final String trackedTime;
  final List<NLatLng> pathCoordinates;

  SaveCoursePage({required this.trackedTime, required this.pathCoordinates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('코스 저장'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
      ),
    ),
      body: SaveCourseForm(initialMoveTime: trackedTime, pathCoordinates: pathCoordinates)
    );
  }
}
