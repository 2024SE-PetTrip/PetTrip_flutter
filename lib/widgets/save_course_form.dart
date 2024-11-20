import 'package:choice/choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/services/course_service.dart';
import 'package:pettrip_fe/widgets/info_box.dart';

import '../const/category.dart';
import '../const/colors.dart';

class SaveCourseForm extends StatefulWidget {

  final String? initialCourseName;
  final String? initialMoveTime;
  final bool? initialIsShared;
  final String? initialProvince;
  final String? initialCity;
  final String? initialDescription;
  final List<String>? initialTag;
  final List<NLatLng>? pathCoordinates;

  // 생성자
  SaveCourseForm({
    super.key,
    this.initialCourseName,
    this.initialMoveTime,
    this.initialIsShared,
    this.initialProvince,
    this.initialCity,
    this.initialDescription,
    this.initialTag,
    this.pathCoordinates,
  });

  @override
  State<SaveCourseForm> createState() => _SaveCourseFormState();
}

class _SaveCourseFormState extends State<SaveCourseForm> {
  late CourseService _courseService;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController = TextEditingController();
  String? _selectedProvince;
  String? _selectedCity;

  bool _isShared = false;
  List<String>? _selectedTag;

  List<String> _cities = []; // 도,광역시마다 다른 시,군,구 선택을 위한 리스트

  @override
  void initState() {
    super.initState();

    _courseService = CourseService();

    // 전달된 값이 있으면 필드에 설정
    _courseNameController.text = widget.initialCourseName ?? '';
    _courseDescriptionController.text = widget.initialDescription ?? '';
    _selectedProvince = widget.initialProvince;
    _selectedCity = widget.initialCity;
    _isShared = widget.initialIsShared ?? false;
    _selectedTag = widget.initialTag;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 수집된 데이터
      final courseData = {
        "courseName": _courseNameController.text,
        "moveTime": widget.initialMoveTime,
        "isShared": _isShared,
        "province": _selectedProvince,
        "city": _selectedCity,
        "description": _courseDescriptionController.text,
        "tags": _selectedTag,
        "coordinates": widget.pathCoordinates,
      };

      try {
        await _courseService.saveCourse(courseData);

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
    return Form(
        key: _formKey,
        child: Column(
          children: [
            // 코스 이름
            TextFormField(
              controller: _courseNameController,
              decoration: InputDecoration(
                  hintText: "코스명",
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
                  child: InfoBox(title: '이동 시간', content: '${widget.initialMoveTime}')
                ),
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
                              value: _isShared,
                              activeColor: MAIN_COLOR,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isShared = value ?? false;
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
            SizedBox(height: 20,),

            // 도/광역시 선택
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: '도/광역시',
                  enabledBorder: defaultInputBorder,
                  focusedBorder: defaultInputBorder),
              value: _selectedProvince,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProvince = newValue;
                  // 도/광역시 선택 시 해당 시/군/구 목록을 업데이트
                  _selectedCity = null; // 시/군/구 선택 초기화
                  _cities = cityMap[newValue!] ?? []; // 선택된 도에 맞는 시/군/구 목록 설정
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '도/광역시를 선택해 주세요';
                }
                return null;
              },
              items: cityMap.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // 시/군/구 선택
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: '시/군/구',
                  enabledBorder: defaultInputBorder,
                  focusedBorder: defaultInputBorder),
              value: _selectedCity,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '시/군/구를 선택해 주세요';
                }
                return null;
              },
              items: _cities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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

            // 태그 선택 (Dropdown)
            FormField<List<String>>(
              autovalidateMode: AutovalidateMode.always,
              initialValue: _selectedTag,
              onSaved: (List<String>? value) {
                setState(() => _selectedTag = value ?? []);
              },
              validator: (value) {
                if (value?.isEmpty ?? value == null) {
                  return '태그를 선택해 주세요';
                }
                if (value!.length > 3) {
                  return "태그는 3개까지 선택 가능합니다";
                }
                return null;
              },
              builder: (formState) {
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: LIGHT_GRAY_COLOR,)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InlineChoice<String>(
                        multiple: true,
                        clearable: true,
                        value: formState.value ?? [],
                        onChanged: (val) => formState.didChange(val),
                        itemCount: courseTags.length,
                        itemBuilder: (selection, i) {
                          return ChoiceChip(
                            backgroundColor: LIGHT_GRAY_COLOR,
                            selectedColor: MAIN_COLOR,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.transparent,
                                ),
                            ),
                            selected: selection.selected(courseTags[i]),
                            onSelected: selection.onSelected(courseTags[i]),
                            label: Text(courseTags[i]),
                          );
                        },
                        listBuilder: ChoiceList.createWrapped(
                          spacing: 10,
                          runSpacing: 10,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formState.errorText ??
                              '${formState.value!.length}/3 선택됨',
                          style: TextStyle(
                            color: formState.hasError
                                ? WARNING_COLOR
                                : Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20,),
            TextButton(
                onPressed: () {_submitForm();},
                child: Text('코스 등록'), style: defaultTextButtonStyle),
          ],
        ));
  }
}
