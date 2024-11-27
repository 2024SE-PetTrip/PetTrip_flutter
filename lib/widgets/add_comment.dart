import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/services/comment_service.dart';

import '../const/colors.dart';
import '../const/style.dart';

class AddComment extends StatelessWidget {
  final int courseId;
  final int userId;
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();

  AddComment({super.key, required this.courseId, required this.userId});

  Future<void> _submitComment(context) async {
    final commentData = {
      "userId": userId,
      "commentContent": _commentController.text,
    };

    try {
      await _commentService.addComment(courseId, commentData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('댓글이 작성되었습니다')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("댓글 작성에 실패했습니다")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("댓글 작성", style: titleTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _commentController,
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
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              _submitComment(context);
            },
            style: defaultTextButtonStyle,
            child: Text("작성 완료"),
          )
        ]),
      ),
    );
  }
}
