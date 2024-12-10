import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/category.dart';
import 'package:pettrip_fe/const/dummy_data.dart';
import 'package:pettrip_fe/models/course_model.dart';
import 'package:pettrip_fe/screens/upload_course_page.dart';
import 'package:pettrip_fe/services/course_service.dart';
import 'package:pettrip_fe/widgets/course_card.dart';
import 'package:pettrip_fe/widgets/filter_modal.dart';

import '../const/colors.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final CourseService _courseService = CourseService();

  // 검색 및 필터링 관련 상태 변수
  String? _searchTitle; // 검색어
  String? _selectedProvince; // 선택된 도/광역시
  String? _selectedCity; // 선택된 시/군/구
  List<String> _selectedTags = []; // 선택된 태그
  bool _isFilterApplied = false; // 핕터 적용 여부

  late List<CourseModel> _allCourses; // 모든 코스
  late List<CourseModel> _filteredCourses; // 필터링 된 코스

  bool _isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true; // 로딩 시작
    });
    _allCourses = await _courseService.getAllCourses();
    setState(() {
      _filteredCourses = _allCourses;
      _isLoading = false;
    });
  }

  // 코스 필터링 메서드
  void _filterCourses() {
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final matchesTitle = _searchTitle == null ||
            course.courseName
                .toLowerCase()
                .contains(_searchTitle!.toLowerCase());
        final matchesLocation = (_selectedProvince == null ||
                course.province == _selectedProvince) &&
            (_selectedCity == null || course.city == _selectedCity);
        final matchesTags = _selectedTags.isEmpty ||
            _selectedTags.every((tag) => course.tags.contains(tag));

        return matchesTitle && matchesLocation && matchesTags;
      }).toList();
    });
  }

// 필터 모달 호출
  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterModal(
          selectedProvince: _selectedProvince,
          selectedCity: _selectedCity,
          selectedTags: _selectedTags,
          tagList: courseTags,
          onProvinceChanged: (province) {
            setState(() {
              _selectedProvince = province;
            });
          },
          onCityChanged: (city) {
            setState(() {
              _selectedCity = city;
            });
          },
          onTagsChanged: (tags) {
            setState(() {
              _selectedTags = tags;
            });
          },
          onApply: () {
            setState(() {
              _isFilterApplied = true;
            });
            _filterCourses();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('코스 찾기')),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        // 검색창
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '코스 이름 검색',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: MAIN_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: MAIN_COLOR),
                            ),
                          ),
                          onChanged: (value) {
                            _searchTitle = value;
                            _filterCourses();
                          },
                        ),
                      ),
                      SizedBox(width: 5),

                      // 필터링 버튼
                      TextButton(
                          onPressed: () {
                            if (_isFilterApplied) {
                              // 필터가 적용 중이라면 초기화
                              setState(() {
                                _selectedProvince = null;
                                _selectedCity = null;
                                _selectedTags = [];
                                _isFilterApplied = false;
                                _filterCourses(); // 필터 초기화 후 다시 필터링
                              });
                            } else {
                              // 필터 모달을 열기
                              _showFilterModal(context);
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: BorderSide(color: MAIN_COLOR),
                            backgroundColor:
                                _isFilterApplied ? MAIN_COLOR : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.filter_list,
                                  color: _isFilterApplied
                                      ? Colors.white
                                      : Colors.black),
                              Text(
                                _isFilterApplied ? '초기화' : '필터링',
                                style: TextStyle(
                                    color: _isFilterApplied
                                        ? Colors.white
                                        : Colors.black),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                // 필터링 된 코스 목록
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return CourseCard(
                        course: course,
                        isLiked: false,
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UploadCoursePage()));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: MAIN_COLOR,
        child: const Icon(
          color: Colors.white,
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
