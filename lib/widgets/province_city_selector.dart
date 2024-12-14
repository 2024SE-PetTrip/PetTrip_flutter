import 'package:flutter/material.dart';
import '../const/style.dart';
import '../const/category.dart';

class ProvinceCitySelector extends StatefulWidget {
  final String? selectedProvince;
  final String? selectedCity;
  final ValueChanged<String?> onProvinceChanged;
  final ValueChanged<String?> onCityChanged;

  const ProvinceCitySelector({
    super.key,
    this.selectedProvince,
    this.selectedCity,
    required this.onProvinceChanged,
    required this.onCityChanged,
  });

  @override
  _ProvinceCitySelectorState createState() => _ProvinceCitySelectorState();
}

class _ProvinceCitySelectorState extends State<ProvinceCitySelector> {
  List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    _updateCities(widget.selectedProvince);
  }

  @override
  void didUpdateWidget(covariant ProvinceCitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedProvince != widget.selectedProvince) {
      _updateCities(widget.selectedProvince);
    }
  }

  void _updateCities(String? province) {
    setState(() {
      _cities = cityMap[province] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 도/광역시 선택 Dropdown
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '도/광역시',
            enabledBorder: defaultInputBorder,
            focusedBorder: defaultInputBorder,
          ),
          value: widget.selectedProvince,
          onChanged: (String? newProvince) {
            widget.onProvinceChanged(newProvince);
          },
          items: cityMap.keys.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '도/광역시를 선택해 주세요';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        // 시/군/구 선택 Dropdown
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '시/군/구',
            enabledBorder: defaultInputBorder,
            focusedBorder: defaultInputBorder,
          ),
          value: widget.selectedCity,
          onChanged: (String? newCity) {
            widget.onCityChanged(newCity);
          },
          items: _cities.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '시/군/구를 선택해 주세요';
            }
            return null;
          },
        ),
      ],
    );
  }
}
