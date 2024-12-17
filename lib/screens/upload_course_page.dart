import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/colors.dart';

import '../const/style.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../services/token_parser.dart';
import '../services/token_storage.dart';
import '../widgets/save_course_form.dart';

class UploadCoursePage extends StatefulWidget {
  const UploadCoursePage({super.key});

  @override
  State<UploadCoursePage> createState() => _UploadCoursePageState();
}

class _UploadCoursePageState extends State<UploadCoursePage> {
  final CourseService _courseService = CourseService();
  List<CourseModel> _courses = [];
  CourseModel? _selectedCourse;

  int? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
    _loadCourses();
  }

  Future<void> _initializeUserId() async {
    final userId = await getUserId();
    setState(() {
      _userId = userId;
    });
  }

  Future<void> _loadCourses() async {
    try {
      _courses = await _courseService.getUserCourses(_userId!);
      setState(() {});
    } catch (e) {
      print('코스 목록 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('코스 등록'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: DropdownButtonFormField<CourseModel>(
              decoration: InputDecoration(
                  enabledBorder: defaultInputBorder.copyWith(borderSide: BorderSide(color: MAIN_COLOR)),
                  focusedBorder: defaultInputBorder.copyWith(borderSide: BorderSide(color: MAIN_COLOR))),
              hint: Text('코스를 선택해 주세요'),
              value: _selectedCourse,
              onChanged: (CourseModel? newValue) {
                setState(() {
                  _selectedCourse = newValue;
                });
              },
              items: _courses.map((course) {
                return DropdownMenuItem(
                    value: course, child: Text(course.courseName));
              }).toList(),
            ),
          ),
          if (_selectedCourse != null)
            Expanded(child: SaveCourseForm(
              key: ValueKey(_selectedCourse),
              initialCourseId: _selectedCourse!.courseId,
              initialCourseName: _selectedCourse!.courseName,
              initialMoveTime: _selectedCourse!.moveTime,
              initialProvince: _selectedCourse!.province,
              initialCity: _selectedCourse!.city,
              initialDescription: _selectedCourse!.courseDescription,
              initialTag: _selectedCourse!.tags,
              isUpload: true,
            ))
        ],
      ),
    );
  }
}
