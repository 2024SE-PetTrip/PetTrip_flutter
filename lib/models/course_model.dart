import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'comment_model.dart';

class CourseModel {
  final String courseID;
  final String courseName;
  final String moveTime;
  final String moveDistance;
  final bool isShared;
  final String province;
  final String city;
  final String description;
  final List<String> tags;
  final List<NLatLng> coordinates;
  final int likeCount;

  CourseModel({
    required this.courseID,
    required this.courseName,
    required this.moveTime,
    required this.moveDistance,
    required this.isShared,
    required this.province,
    required this.city,
    required this.description,
    required this.tags,
    required this.coordinates,
    required this.likeCount,
  });
}
