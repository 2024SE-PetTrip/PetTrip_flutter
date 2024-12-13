import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/const/dummy_data.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/services/course_service.dart';
import 'package:pettrip_fe/widgets/add_comment.dart';
import 'package:pettrip_fe/widgets/course_detail_map.dart';
import 'package:pettrip_fe/widgets/like_button.dart';

import '../models/comment_model.dart';
import '../models/course_model.dart';
import '../services/comment_service.dart';
import '../widgets/comment_card.dart';
import '../widgets/info_box.dart';
import '../widgets/tag_scroll_view.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseModel course;
  final bool isLiked;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.isLiked,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final CommentService _commentService = CommentService();
  late List<CommentModel> _comments;
  bool _isLoading = false;

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
    });
    _comments = await _commentService.getCourseComments(widget.course.courseId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // 맵
                        CourseDetailMap(
                            pathCoordinates: widget.course.coordinates),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 코스 이름
                            Text(widget.course.courseName,
                                style: titleTextStyle),

                            // 좋아요 버튼
                            LikeButton(
                                initialIsLiked: widget.isLiked,
                                initialLikeCount: widget.course.likeCount,
                                courseId: widget.course.courseId)
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
                                child: TagScrollView(
                              tags: widget.course.tags,
                            ))
                          ],
                        ),
                        SizedBox(height: 10),

                        // 코드
                        Row(
                          children: [
                            Text('코드', style: smallTextStyle),
                            SizedBox(width: 10),
                            Text('${widget.course.courseId}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  defaultDivider,
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              content: '${widget.course.distance}m',
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // 지역
                        InfoBox(
                          title: '지역',
                          content:
                              '${widget.course.province} ${widget.course.city}',
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // 소개글
                        Text('소개글'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(widget.course.courseDescription),
                      ],
                    ),
                  ),
                  defaultDivider,
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 댓글
                        Text('댓글'),
                        SizedBox(height: 20),

                        // 댓글 리스트
                        Column(
                          children: _comments.map((comment) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CommentCard(
                                userImage: comment.userImage,
                                userName: comment.userName,
                                comment: comment.commentContent,
                              ),
                            );
                          }).toList(),
                        ),

                        Center(
                          child: TextButton(
                            child: Text("댓글 작성"),
                            style: defaultTextButtonStyle,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                builder: (context) {
                                  // TODO: 임시 UserID 바꾸기
                                  return AddComment(
                                    loadComments: _loadComments,
                                    courseId: widget.course.courseId,
                                    userId: testUserId,
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
