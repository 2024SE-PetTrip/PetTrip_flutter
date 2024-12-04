import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/style.dart';
import '../widgets/province_city_selector.dart';
import '../widgets/tag_selector.dart';
import '../const/colors.dart';

class FilterModal extends StatelessWidget {
  final String? selectedProvince;
  final String? selectedCity;
  final List<String> selectedTags;
  final List<String> tagList;
  final ValueChanged<String?> onProvinceChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<List<String>> onTagsChanged;
  final VoidCallback onApply;

  const FilterModal({
    super.key,
    this.selectedProvince,
    this.selectedCity,
    required this.selectedTags,
    required this.onProvinceChanged,
    required this.onCityChanged,
    required this.onTagsChanged,
    required this.onApply,
    required this.tagList,
  });

  @override
  Widget build(BuildContext context) {
    String? tempProvince = selectedProvince;
    String? tempCity = selectedCity;
    List<String> tempTags = List.from(selectedTags);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '지역',
                  style: titleTextStyle,
                ),
                const SizedBox(height: 20),
                // 지역 선택 위젯
                ProvinceCitySelector(
                  selectedProvince: tempProvince,
                  selectedCity: tempCity,
                  onProvinceChanged: (province) {
                    setState((){
                      tempProvince = province;
                      tempCity = null;
                      onProvinceChanged(province);
                      onCityChanged(null);
                    });
                  },
                  onCityChanged: (city) {
                    setState((){
                      tempCity = city;
                      onCityChanged(city);
                    });
                  },
                ),
                SizedBox(height: 30),
                Text(
                  '태그',
                  style: titleTextStyle,
                ),
                // 태그 선택 위젯
                TagSelector(
                  initialSelectedTags: tempTags,
                  tagList: tagList,
                  onTagChanged: (tags) {
                    setState((){
                      tempTags = tags;
                      onTagsChanged(tags);
                    });
                  },
                ),
                const SizedBox(height: 16),
                // 적용 버튼
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onApply(); // 필터 적용 로직 호출
                    },
                    style: defaultTextButtonStyle,
                    child: Text('필터 적용', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
