import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pettrip_fe/const/category.dart';
import 'package:pettrip_fe/services/walk_group_service.dart';
import 'package:pettrip_fe/widgets/province_city_selector.dart';

import '../const/colors.dart';
import '../const/dummy_data.dart';
import '../const/style.dart';
import '../widgets/tag_selector.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final WalkGroupService _walkGroupService = WalkGroupService();
  final _formKey = GlobalKey<FormState>();

  String? _groupName;
  int? _courseId;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _walkingDate;
  int? _maxParticipants;
  int? _maxPetsPerUser;
  String? _groupDescription;
  String? _province;
  String? _city;
  List<String>? _selectedTag;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _walkingDateController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final groupData = {
        "creatorID": testUserId, // TODO: 실제 userID로 변경 필요
        "groupName": _groupName,
        "courseId": _courseId,
        "startDate": _startDateController.text,
        "endDate": _endDateController.text,
        "walkingDate": _walkingDateController.text,
        "maxParticipants": _maxParticipants,
        "maxPetsPerUser": _maxPetsPerUser,
        "groupDescription": _groupDescription,
        "groupAddress": "$_province $_city",
        "tags": _selectedTag,
      };

      try {
          await _walkGroupService.saveWalkGroup(groupData);

        // 성공 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("산책 모임이 등록되었습니다")),
        );
        Navigator.pop(context);
      } catch (e) {
        // 실패 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("모임 등록에 실패했습니다")),
        );
      }
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _walkingDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('모임 등록'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('모임 정보'),
                SizedBox(height: 10),

                // 그룹 이름
                TextFormField(
                  maxLength: 15,
                  decoration: InputDecoration(
                      labelText: '모임명',
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
                  onSaved: (value) {
                    _groupName = value;
                  },
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    // 최대 멤버 수
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "최대 멤버 수",
                          filled: true,
                          fillColor: LIGHT_GRAY_COLOR,
                          enabledBorder: defaultInputBorder,
                          focusedBorder: defaultInputBorder,
                          counterText: ''),
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      // 숫자만 입력
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '최대 멤버 수를 입력해 주세요';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _maxParticipants = int.tryParse(value!);
                      },
                    )),
                    SizedBox(width: 10),

                    // 인당 최대 동물 수
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "인당 최대 동물 수",
                            filled: true,
                            fillColor: LIGHT_GRAY_COLOR,
                            enabledBorder: defaultInputBorder,
                            focusedBorder: defaultInputBorder,
                            counterText: ''),
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        // 숫자만 입력
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '인당 최대 동물 수를 입력해 주세요';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _maxPetsPerUser = int.tryParse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // 지역 선택
                ProvinceCitySelector(
                  selectedProvince: _province,
                  selectedCity: _city,
                  onProvinceChanged: (province) {
                    setState(() {
                      _province = province;
                      _city = null;
                    });
                  },
                  onCityChanged: (city) {
                    setState(() {
                      _city = city;
                    });
                  },
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    // 모임 시작일
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "모임 시작일",
                          filled: true,
                          fillColor: LIGHT_GRAY_COLOR,
                          enabledBorder: defaultInputBorder,
                          focusedBorder: defaultInputBorder,
                        ),
                        controller: _startDateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null && pickedDate != _startDate) {
                            setState(() {
                              _startDate = pickedDate;
                              _startDateController.text =
                                  _dateFormat.format(_startDate!);
                            });
                          }
                        },
                        validator: (value) {
                          if (_startDate == null) {
                            return '시작 날짜를 선택해 주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),

                    // 모임 종료일
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "모임 종료일",
                          filled: true,
                          fillColor: LIGHT_GRAY_COLOR,
                          enabledBorder: defaultInputBorder,
                          focusedBorder: defaultInputBorder,
                        ),
                        controller: _endDateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null && pickedDate != _endDate) {
                            setState(() {
                              _endDate = pickedDate;
                              _endDateController.text =
                                  _dateFormat.format(_endDate!);
                            });
                          }
                        },
                        validator: (value) {
                          if (_endDate == null) {
                            return '종료 날짜를 선택해 주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    // 산책 예정일
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "산책 예정일",
                          filled: true,
                          fillColor: LIGHT_GRAY_COLOR,
                          enabledBorder: defaultInputBorder,
                          focusedBorder: defaultInputBorder,
                        ),
                        controller: _walkingDateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null &&
                              pickedDate != _walkingDate) {
                            setState(() {
                              _walkingDate = pickedDate;
                              _walkingDateController.text =
                                  _dateFormat.format(_walkingDate!);
                            });
                          }
                        },
                        validator: (value) {
                          if (_walkingDate == null) {
                            return '산책 날짜를 선택해 주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),

                    // 코스 코드
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "산책 코스 코드",
                          filled: true,
                          fillColor: LIGHT_GRAY_COLOR,
                          enabledBorder: defaultInputBorder,
                          focusedBorder: defaultInputBorder,
                        ),
                        keyboardType: TextInputType.number,
                        // 숫자만 입력
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '산책 코스의 코드를 입력해 주세요';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _courseId = int.tryParse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Text('소개글'),
                SizedBox(height: 10),
                // 모임 설명
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "모임에 대한 설명을 입력해 주세요",
                      filled: true,
                      fillColor: LIGHT_GRAY_COLOR,
                      enabledBorder: defaultInputBorder,
                      focusedBorder: defaultInputBorder),
                  maxLength: 500,
                  minLines: 3,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '모임에 대한 설명을 입력해 주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _groupDescription = value;
                  },
                ),
                SizedBox(height: 10),

                // 태그 선택
                TagSelector(
                  initialSelectedTags: _selectedTag ?? [],
                  tagList: groupTags,
                  onTagChanged: (tags) {
                    setState(() {
                      _selectedTag = tags;
                    });
                  },
                ),
                SizedBox(height: 20),

                // 제출 버튼
                Center(
                  child: TextButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: Text('모임 등록'),
                    style: defaultTextButtonStyle,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
