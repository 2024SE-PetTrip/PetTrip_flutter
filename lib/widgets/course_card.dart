import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/models/comment_model.dart';
import 'package:pettrip_fe/models/course_model.dart';
import 'package:pettrip_fe/screens/course/course_detail_page.dart';
import 'package:pettrip_fe/widgets/like_button.dart';
import 'package:pettrip_fe/widgets/tag_scroll_view.dart';

import '../const/colors.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool isLiked;
  late List<CommentModel> _comments;

  CourseCard({
    super.key,
    required this.course,
    required this.isLiked,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(
              course: course,
              isLiked: isLiked,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: LIGHT_GRAY_COLOR),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.courseName,
                          style: titleTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text('${course.province} ${course.city}',
                          style: smallTextStyle),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                LikeButton(
                    initialIsLiked: isLiked,
                    initialLikeCount: course.likeCount,
                    courseId: course.courseId)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TagScrollView(tags: course.tags),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                      color: POINT_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                      (course.moveTime.split(':')[0] != '00'
                              ? '${course.moveTime.split(':')[0]}hr '
                              : '') +
                          ('${course.moveTime.split(':')[1]}min'),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
