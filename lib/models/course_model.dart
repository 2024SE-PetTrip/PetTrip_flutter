import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'comment_model.dart';

class CourseModel {
  final String courseId;
  final String courseName;
  final String moveTime;
  final String distance;
  final String status;
  final String province;
  final String city;
  final String description;
  final List<String> tags;
  final List<NLatLng> coordinates;
  final int likeCount;

  CourseModel({
    required this.courseId,
    required this.courseName,
    required this.moveTime,
    required this.distance,
    required this.status,
    required this.province,
    required this.city,
    required this.description,
    required this.tags,
    required this.coordinates,
    required this.likeCount,
  });

  // fromJson method
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['courseID'] as String,
      courseName: json['courseName'] as String,
      moveTime: json['moveTime'] as String,
      distance: json['moveDistance'] as String,
      status: json['isShared'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((coord) => NLatLng(
        coord['latitude'] as double,
        coord['longitude'] as double,
      ))
          .toList(),
      likeCount: json['likeCount'] as int,
    );
}}
