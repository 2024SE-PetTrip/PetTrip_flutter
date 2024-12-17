import 'package:choice/choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/services/course_service.dart';
import 'package:pettrip_fe/widgets/info_box.dart';
import 'package:pettrip_fe/widgets/province_city_selector.dart';
import 'package:pettrip_fe/widgets/tag_selector.dart';

import '../const/category.dart';
import '../const/colors.dart';
import '../services/token_storage.dart';

class SaveCourseForm extends StatefulWidget {
  final int? initialCourseId;
  final String? initialCourseName;
  final String? initialMoveTime;
  final String? initialStatus;
  final String? initialProvince;
  final String? initialCity;
  final String? initialDescription;
  final List<String>? initialTag;
  final List<NLatLng>? pathCoordinates;
  final bool isUpload;

  // 생성자
  SaveCourseForm({
    super.key,
    this.initialCourseId,
    this.initialCourseName,
    this.initialMoveTime,
    this.initialStatus,
    this.initialProvince,
    this.initialCity,
    this.initialDescription,
    this.initialTag,
    this.pathCoordinates,
    this.isUpload = false,
  });

  @override
  State<SaveCourseForm> createState() => _SaveCourseFormState();
}

class _SaveCourseFormState extends State<SaveCourseForm> {
  final CourseService _courseService = CourseService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  String? _selectedProvince;
  String? _selectedCity;

  late String _status;
  List<String>? _selectedTag;

  int? _userId;

  @override
  void initState() {
    super.initState();

    _initializeUserId();

    // 전달된 값이 있으면 필드에 설정
    _courseNameController.text = widget.initialCourseName ?? '';
    _courseDescriptionController.text = widget.initialDescription ?? '';
    _selectedProvince = widget.initialProvince;
    _selectedCity = widget.initialCity;
    _status = widget.initialStatus ?? 'ACTIVE';
    _selectedTag = widget.initialTag;
  }

  Future<void> _initializeUserId() async {
    final userId = await getUserId();
    debugPrint("유저아이디: $userId");
    setState(() {
      _userId = userId;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // pathCoordinates를 변환
      final transformedCoordinates = widget.isUpload
          ? null
          : widget.pathCoordinates?.map((coord) {
              return {
                "latitude": coord.latitude,
                "longitude": coord.longitude,
              };
            }).toList();

      // 수집된 데이터
      final courseData = {
        "userId": _userId,
        "courseName": _courseNameController.text,
        "moveTime": widget.initialMoveTime,
        "status": _status,
        "province": _selectedProvince,
        "city": _selectedCity,
        "courseDescription": _courseDescriptionController.text,
        "tags": _selectedTag,
        "coordinates": transformedCoordinates,
      };

      try {
        if (widget.isUpload == false) {
          await _courseService.saveCourse(courseData);
        } else {
          await _courseService.updateCourse(widget.initialCourseId!, courseData);
        }

        // 성공 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("코스가 저장되었습니다")),
        );
        Navigator.pop(context);
      } catch (e) {
        // 실패 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("코스 저장에 실패했습니다")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 코스 이름
              TextFormField(
                controller: _courseNameController,
                maxLength: 15,
                decoration: InputDecoration(
                    labelText: "코스명",
                    filled: true,
                    fillColor: LIGHT_GRAY_COLOR,
                    enabledBorder: defaultInputBorder,
                    focusedBorder: defaultInputBorder),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '코스 이름을 입력해 주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  // 이동 시간
                  Expanded(
                      child: InfoBox(
                          title: '이동 시간',
                          content: '${widget.initialMoveTime}')),
                  SizedBox(width: 10),

                  // 공유 선택
                  Expanded(
                    child: Container(
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: LIGHT_GRAY_COLOR),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('공유 선택', style: smallTextStyle),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('전체공유'),
                              CupertinoSwitch(
                                value: _status == 'ACTIVE',
                                activeColor: MAIN_COLOR,
                                onChanged: widget.isUpload
                                    ? null
                                    : (bool value) {
                                        setState(() {
                                          _status =
                                              value ? 'ACTIVE' : 'PROTECTED';
                                        });
                                      },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // 지역 선택
              ProvinceCitySelector(
                selectedProvince: _selectedProvince,
                selectedCity: _selectedCity,
                onProvinceChanged: (province) {
                  setState(() {
                    _selectedProvince = province;
                    _selectedCity = null;
                  });
                },
                onCityChanged: (city) {
                  setState(() {
                    _selectedCity = city;
                  });
                },
              ),
              SizedBox(height: 10),

              // 코스 설명
              TextFormField(
                controller: _courseDescriptionController,
                maxLength: 500,
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: "코스에 대한 설명을 입력해 주세요",
                    filled: true,
                    fillColor: LIGHT_GRAY_COLOR,
                    enabledBorder: defaultInputBorder,
                    focusedBorder: defaultInputBorder),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '코스에 대한 설명을 입력해 주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // 태그 선택
              TagSelector(
                initialSelectedTags: _selectedTag ?? [],
                tagList: courseTags,
                onTagChanged: (tags) {
                  setState(() {
                    _selectedTag = tags;
                  });
                },
              ),
              SizedBox(height: 20),

              TextButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text('코스 등록'),
                  style: defaultTextButtonStyle),
            ],
          )),
    );
  }
}
