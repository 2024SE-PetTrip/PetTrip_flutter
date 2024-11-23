import 'package:flutter/cupertino.dart';
import 'package:pettrip_fe/services/course_service.dart';

import '../const/colors.dart';
import '../const/style.dart';

class LikeButton extends StatefulWidget {
  final String courseID;
  final bool initialIsLiked;
  final int initialLikeCount;
  const LikeButton({super.key, required this.initialIsLiked, required this.initialLikeCount, required this.courseID});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  final CourseService _courseService = CourseService();
  late int _likeCount;
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.initialLikeCount;
    _isLiked = widget.initialIsLiked;
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          GestureDetector(
            child: Icon(
              _isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color: MAIN_COLOR,
            ),
            onTap: () {
              setState(() {
                _courseService.likeCourse(widget.courseID);
                if (_isLiked) {
                  _likeCount--; // 좋아요 취소
                } else {
                  _likeCount++; // 좋아요 추가
                }
                _isLiked = !_isLiked;
              });
            },
          ),
          Text(
            '$_likeCount', // 좋아요 개수 표시
            style: smallTextStyle,
          ),
        ]
    );
  }
}
