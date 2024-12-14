import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/services/pet_service.dart';
import 'package:pettrip_fe/models/pet_model.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:image_picker/image_picker.dart';

class AddPetPage extends StatefulWidget {
  final int userID;

  const AddPetPage({super.key, required this.userID});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _petService = PetService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

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

  String? petImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("반려동물 추가"),
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
                        Icon(Icons.camera_alt, size: 40, color: Colors.grey),
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
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "이름",
                      hintText: "나비",
                    ),
                  ),
                  TextField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: "나이",
                      hintText: "3",
                    ),
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitAddPet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MAIN_COLOR,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                  child: const Text(
                    "반려동물 추가",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _submitAddPet() {
    final petModel = PetModel(
        userId: widget.userID,
        petName: _nameController.text,
        petAge: int.parse(_ageController.text),
        breed: "",
        petImageUrl: petImageUrl ?? '');

    _petService.addPet(petModel);
    Navigator.pop(context);
  }
}





