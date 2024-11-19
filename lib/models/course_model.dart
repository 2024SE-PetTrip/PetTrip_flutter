import 'package:flutter_naver_map/flutter_naver_map.dart';

class CourseModel {
  final String courseName;
  final String moveTime;
  final bool isShared;
  final String province;
  final String city;
  final List<String> tags;
  final List<NLatLng> coordinates;

  CourseModel({
    required this.courseName,
    required this.moveTime,
    required this.isShared,
    required this.province,
    required this.city,
    required this.tags,
    required this.coordinates,
  });
}
