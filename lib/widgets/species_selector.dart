import 'package:flutter/material.dart';
import '../const/style.dart';
import '../const/species.dart';

class SpeciesSelector extends StatefulWidget {
  final String? selectedCatOrDog;
  final String? selectedSpecies;
  final ValueChanged<String?> onCatOrDogChanged;
  final ValueChanged<String?> onSpeciesChanged;

  const SpeciesSelector({
    super.key,
    this.selectedCatOrDog,
    this.selectedSpecies,
    required this.onCatOrDogChanged,
    required this.onSpeciesChanged,
  });

  @override
  _SpeciesSelectorState createState() => _SpeciesSelectorState();
}

class _SpeciesSelectorState extends State<SpeciesSelector> {
  List<String> _species = [];

  @override
  void initState() {
    super.initState();
    _updateSpecies(widget.selectedCatOrDog);
  }

  @override
  void didUpdateWidget(covariant SpeciesSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCatOrDog != widget.selectedCatOrDog) {
      _updateSpecies(widget.selectedCatOrDog);
    }
  }

  void _updateSpecies(String? catOrDog) {
    setState(() {
      _species = speciesMap[catOrDog] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '동물',
            enabledBorder: defaultInputBorder,
            focusedBorder: defaultInputBorder,
          ),
          value: widget.selectedCatOrDog,
          onChanged: (String? newCatOrDog) {
            widget.onCatOrDogChanged(newCatOrDog);
          },
          items: speciesMap.keys.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '동물을 선택해주세요';
            }
            return null;
          },
        ),
        SizedBox(height: 20),

        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '품종',
            enabledBorder: defaultInputBorder,
            focusedBorder: defaultInputBorder,
          ),
          value: widget.selectedSpecies,
          onChanged: (String? newSpecies) {
            widget.onSpeciesChanged(newSpecies);
          },
          items: _species.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '품종을 선택해주세요';
            }
            return null;
          },
        ),
      ],
    );
  }
}