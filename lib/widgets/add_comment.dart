import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/style.dart';

class AddComment extends StatelessWidget {
  final String courseID;

  AddComment(
      {super.key,
      required this.courseID,});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("댓글 작성", style: titleTextStyle),
          SizedBox(height: 10),
          TextFormField(
            maxLength: 300,
            minLines: 3,
            maxLines: 10,
            decoration: InputDecoration(
                filled: true,
                fillColor: LIGHT_GRAY_COLOR,
                enabledBorder: defaultInputBorder,
                focusedBorder: defaultInputBorder),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '작성된 내용이 없습니다';
              }
              return null;
            },
          ),
          SizedBox(height: 10,),
          TextButton(onPressed: (){}, child: Text("작성 완료"), style: defaultTextButtonStyle,)
        ]),
      ),
    );
  }
}
