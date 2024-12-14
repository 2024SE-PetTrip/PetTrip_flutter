import 'package:flutter/material.dart';
import 'package:pettrip_fe/models/care_model.dart';
import 'package:pettrip_fe/services/care_community_service.dart';

class CareRequestPage extends StatefulWidget {
  const CareRequestPage({super.key});

  @override
  State<CareRequestPage> createState() => _CareRequestPageState();
}

class _CareRequestPageState extends State<CareRequestPage> {
  final CareCommunityService _careCommunityService = CareCommunityService();

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // State for dropdowns and image URL
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _requestImageUrl; // Placeholder for image upload logic
  DateTime? _startDate;
  // Mock data (Replace with real IDs from your app's logic)
  final int requesterId = 1; // Example user ID
  final int petId = 101; // Example pet ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("대표 사진을 추가하세요"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Input
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "제목",
                  hintText: "돌봄 1",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Address Inputs
              Row(
                children: [
                  // Province Dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "도/특별시/광역시",
                        border: OutlineInputBorder(),
                      ),
                      items: ["서울시", "부산시", "대구시"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProvince = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  // District Dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "시/군/구",
                        border: OutlineInputBorder(),
                      ),
                      items: ["중구", "강남구", "서초구"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Input
              TextField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "돌봄 희망일",
                  hintText: "2024-11-15 / 12:30",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  // Date Picker Logic
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _startDate = selectedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Description Input
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "설명글 작성",
                  hintText: "돌봄 설명글 부분입니다",
                  border: OutlineInputBorder(),
                ),
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
      address: "${_selectedProvince ?? ''} ${_selectedDistrict ?? ''}",
      startDate: _startDate!,
      endDate: _startDate!.add(Duration(days: 7)),
      requestDescription: _descriptionController.text,
      requestImageUrl: _requestImageUrl ?? '',
      petId: petId,
    );

    _careCommunityService.addCareRequest(careRequest);
  }
}