import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/models/care_model.dart';
import 'package:pettrip_fe/services/care_community_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pettrip_fe/widgets/province_city_selector.dart';

import '../../const/colors.dart';
import '../../const/style.dart';

class CareRequestPage extends StatefulWidget {
  const CareRequestPage({super.key});

  @override
  State<CareRequestPage> createState() => _CareRequestPageState();
}

class _CareRequestPageState extends State<CareRequestPage> {
  final CareCommunityService _careCommunityService = CareCommunityService();

  File? _selectedImage;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd / HH:mm ');

  // State for dropdowns and image URL
  String? _selectedProvince;
  String? _selectedCity;
  String? _requestImageUrl; // Placeholder for image upload logic
  DateTime? _startDate;

  // Mock data (Replace with real IDs from your app's logic)
  final int requesterId = 1; // Example user ID
  final int petId = 101; // Example pet ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("돌봄 요청 등록"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Image Placeholder
              GestureDetector(
                onTap: _pickImage, // 사진 선택 동작
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("대표 사진을 추가하세요"),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Input
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: "제목",
                    filled: true,
                    fillColor: LIGHT_GRAY_COLOR,
                    enabledBorder: defaultInputBorder,
                    focusedBorder: defaultInputBorder),
              ),
              const SizedBox(height: 16),

              ProvinceCitySelector(
                  selectedCity: _selectedProvince,
                  selectedProvince: _selectedCity,
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
                  }),
              const SizedBox(height: 16),

              // Date Input
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                    hintText: "돌봄 희망일",
                    filled: true,
                    fillColor: LIGHT_GRAY_COLOR,
                    enabledBorder: defaultInputBorder,
                    focusedBorder: defaultInputBorder),
                onTap: () async {
                  // Date Picker Logic
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );

                  TimeOfDay? selectedTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());

                  if (selectedDate != null && selectedTime != null) {
                    setState(() {
                      _startDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      _dateController.text = _dateFormat.format(_startDate!);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              Text('설명글'),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLength: 500,
                maxLines: null,
                minLines: 3,
                decoration: InputDecoration(
                    hintText: "돌봄 요청 설명을 작성해 주세요.",
                    filled: true,
                    fillColor: LIGHT_GRAY_COLOR,
                    enabledBorder: defaultInputBorder,
                    focusedBorder: defaultInputBorder),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitCareRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "게시물 등록",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitCareRequest() {
    final careRequest = CareRequestDTO(
      requesterId: requesterId,
      title: _titleController.text,
      address: "${_selectedProvince ?? ''} ${_selectedCity ?? ''}",
      startDate: _startDate!,
      endDate: _startDate!.add(Duration(days: 7)),
      requestDescription: _descriptionController.text,
      requestImageUrl: _requestImageUrl ?? '',
      petId: petId,
    );

    _careCommunityService.addCareRequest(careRequest);
    Navigator.pop(context);
  }
}
