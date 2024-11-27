import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/colors.dart';

import '../const/dummy_data.dart';
import '../const/style.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    // TODO: 코스 가져오는 실제 메서드로 수정
    // try {
    //   _courses = await _courseService.getUserCourses(testUserID); // 코스 목록 가져오기
    //   setState(() {});
    // } catch (e) {
    //   print('코스 목록 로드 실패: $e');
    // }
    _courses = [dummyCourseData1, dummyCourseData2];
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
