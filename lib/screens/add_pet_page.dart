import 'package:flutter/material.dart';

import 'package:pettrip_fe/services/pet_service.dart';
import 'package:pettrip_fe/models/pet_model.dart';
import 'package:pettrip_fe/widgets/species_selector.dart';
import 'package:pettrip_fe/const/colors.dart';

import '../const/style.dart';

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

  String? petImageUrl;

  String? _selectedCatOrDog;
  String? _selectedSpecies;

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
                      Text("대표 사진을 추가하세요")
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: "이름",
                          filled: true,
                          fillColor: LIGHT_GRAY_COLOR,
                          enabledBorder: defaultInputBorder,
                          focusedBorder: defaultInputBorder),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                          hintText: "나이",
                          filled: true,
                          fillColor: LIGHT_GRAY_COLOR,
                          enabledBorder: defaultInputBorder,
                          focusedBorder: defaultInputBorder),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              SpeciesSelector(
                  selectedCatOrDog: _selectedCatOrDog,
                  selectedSpecies: _selectedSpecies,
                  onCatOrDogChanged: (catOrDog) {
                    setState(() {
                      _selectedCatOrDog = catOrDog;
                      _selectedSpecies = null;
                    });
                  },
                  onSpeciesChanged: (species) {
                    setState(() {
                      _selectedSpecies = species;
                    });
                  }
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _submitAddPet,
                  style: defaultTextButtonStyle,
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
        breed: _selectedSpecies!,
        petImageUrl: petImageUrl ?? '');

    _petService.addPet(petModel);
    Navigator.pop(context);
  }
}