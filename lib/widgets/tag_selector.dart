import 'package:flutter/material.dart';
import '../const/category.dart';
import '../const/style.dart';
import '../const/colors.dart';
import 'package:choice/choice.dart';

class TagSelector extends StatelessWidget {
  final List<String> initialSelectedTags;
  final List<String> tagList;
  final int maxTags;
  final ValueChanged<List<String>> onTagChanged;

  const TagSelector({
    super.key,
    required this.initialSelectedTags,
    required this.onTagChanged,
    this.maxTags = 3,
    required this.tagList,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      autovalidateMode: AutovalidateMode.always,
      initialValue: initialSelectedTags,
      onSaved: (List<String>? value) {
        onTagChanged(value ?? []);
      },
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '태그를 선택해 주세요';
        }
        if (value!.length > maxTags) {
          return "태그는 $maxTags개까지 선택 가능합니다";
        }
        return null;
      },
      builder: (formState) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: LIGHT_GRAY_COLOR,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InlineChoice<String>(
                multiple: true,
                clearable: true,
                value: formState.value ?? [],
                onChanged: (val) => formState.didChange(val),
                itemCount: tagList.length,
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
                    selected: selection.selected(tagList[i]),
                    onSelected: selection.onSelected(tagList[i]),
                    label: Text(tagList[i]),
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
                      '${formState.value!.length}/$maxTags 선택됨',
                  style: TextStyle(
                    color: formState.hasError ? WARNING_COLOR : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
