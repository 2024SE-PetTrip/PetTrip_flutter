import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/widgets/course_detail_map.dart';

import '../models/course_model.dart';
import '../widgets/info_box.dart';
import '../widgets/tag.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseModel course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('코스 보기'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  // 맵
                  CourseDetailMap(pathCoordinates: widget.course.coordinates),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 코스 이름
                      Text(widget.course.courseName, style: titleTextStyle),

                      // 좋아요 버튼
                      IconButton(
                        icon: Icon(CupertinoIcons.heart),
                        onPressed: () {},
                      )
                    ],
                  ),
                  SizedBox(height: 10),

                  // 태그
                  Row(
                    children: [
                      Text('태그', style: smallTextStyle),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.course.tags.map((tag) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Tag(tagName: tag),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),

                  // 코드
                  Row(
                    children: [
                      Text('코드', style: smallTextStyle),
                      SizedBox(width: 10),
                      Text(widget.course.courseID),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            defaultDivider,
            SizedBox(height: 10),

            Text('코스 정보'),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                // 이동 시간
                Expanded(
                    child: InfoBox(
                  title: '이동 시간',
                  content: widget.course.moveTime,
                )),
                SizedBox(
                  width: 10,
                ),

                // 이동 거리
                Expanded(
                    child: InfoBox(
                  title: '이동 거리',
                  content: '${widget.course.moveDistance}m',
                )),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            // 지역
            InfoBox(
              title: '지역',
              content: '${widget.course.province} ${widget.course.city}',
            ),
            SizedBox(
              height: 20,
            ),

            // 소개글
            Text('소개글'),
            SizedBox(
              height: 10,
            ),
            Text(widget.course.description),

            SizedBox(
              height: 10,
            ),
            defaultDivider,
            SizedBox(
              height: 10,
            ),

            // 댓글
            Text('댓글'),
            TextButton(
              child: Text("댓글 작성"),
              style: defaultTextButtonStyle,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: Colors.red,
                      height: 200,
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
