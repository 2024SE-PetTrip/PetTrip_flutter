 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/models/walk_group_model.dart';
import 'package:pettrip_fe/services/walk_group_service.dart';
import 'package:pettrip_fe/widgets/group_member_card.dart';

import '../const/dummy_data.dart';
import '../widgets/group_applicant_card.dart';
import '../widgets/info_box.dart';
import '../widgets/tag_scroll_view.dart';

class GroupDetailPage extends StatefulWidget {
  final WalkGroupModel walkGroup;

  // TODO: 자료형 수정
  final List<Map<String, dynamic>> applicants;
  final List<Map<String, dynamic>> members;

  const GroupDetailPage(
      {super.key,
      required this.walkGroup,
      required this.applicants,
      required this.members});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final WalkGroupService _groupService = WalkGroupService();

  late bool _isCreator = true; // TODO: 작성자 확인 로직 추가
  late bool _isApplicantOrMember = false; // TODO: 참가 신청자 / 멤버 확인 로직 추가

  // 참가 신청
  Future<void> submitApplicant() async {
    try {
      // TODO: 실제 아이디로 바꾸기
      await _groupService.submitApplicant(widget.walkGroup.groupId, testUserId);

      // 성공 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("신청되었습니다")),
      );
      setState(() {
        _isApplicantOrMember = true;
      });
    } catch(e) {
      // 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("신청에 실패했습니다")),
      );
    }
  }

  // 신청 수락
  void acceptApplicant(Map<String, dynamic> applicant) {
    setState(() {
      widget.applicants.remove(applicant);
      widget.members.add(applicant);
    });
  }

  // 신청 거절
  void rejectApplicant(Map<String, dynamic> applicant) {
    setState(() {
      widget.applicants.remove(applicant);
    });
  }

  // 멤버 삭제
  void removeMember(Map<String, dynamic> member) {
    setState(() {
      widget.members.remove(member);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('모임 보기'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 모임 이름
                    Text(
                      widget.walkGroup.groupName,
                      style: titleTextStyle,
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
                          tags: widget.walkGroup.tags,
                        ))
                      ],
                    ),
                    SizedBox(height: 10)
                  ],
                ),
              ),
              defaultDivider,
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('모임 정보'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        // 멤버 수
                        Expanded(
                            child: InfoBox(
                          title: '멤버 수',
                          content:
                              '${widget.members.length}/${widget.walkGroup.maxParticipants}',
                        )),
                        SizedBox(width: 10),

                        // 인당 최대 동물 수
                        Expanded(
                            child: InfoBox(
                                title: '인당 최대 동물 수',
                                content: widget.walkGroup.maxPetsPerUser
                                    .toString())),
                      ],
                    ),
                    SizedBox(height: 10),

                    // 지역
                    InfoBox(
                      title: '지역',
                      content: '${widget.walkGroup.province} ${widget.walkGroup.city}'
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        // 모임 시작일
                        Expanded(
                            child: InfoBox(
                          title: '모임 시작일',
                          content: DateFormat('yyyy-MM-dd')
                              .format(widget.walkGroup.startDate),
                        )),
                        SizedBox(width: 10),

                        // 인당 최대 동물 수
                        Expanded(
                            child: InfoBox(
                          title: '모임 종료일',
                          content: DateFormat('yyyy-MM-dd')
                              .format(widget.walkGroup.endDate),
                        )),
                      ],
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        // 산책 예정일
                        Expanded(
                            child: InfoBox(
                          title: '산책 예정일',
                          content: DateFormat('yyyy-MM-dd')
                              .format(widget.walkGroup.walkingDate),
                        )),
                        SizedBox(width: 10),

                        // 산책 코스 코드
                        Expanded(
                            child: InfoBox(
                                title: '산책 코스 코드',
                                content: widget.walkGroup.courseId.toString())),
                      ],
                    ),
                    SizedBox(height: 20),

                    // 소개글
                    Text('소개글'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.walkGroup.groupDescription),
                  ],
                ),
              ),
              _isCreator && widget.applicants.isNotEmpty
                  ? Column(
                      children: [
                        defaultDivider,
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('참가 신청자'),
                              SizedBox(height: 20),
                              Column(
                                children: widget.applicants.map((applicant) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GroupApplicantCard(
                                      groupId: widget.walkGroup.groupId,
                                      userId: applicant["userId"]!,
                                      userImage: applicant["userImage"]!,
                                      userName: applicant["userName"]!,
                                      onAccept: () =>
                                          acceptApplicant(applicant),
                                      onReject: () =>
                                          rejectApplicant(applicant),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
              defaultDivider,
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 멤버 목록
                    Text('멤버'),
                    SizedBox(height: 20),

                    Column(
                      children: widget.members.map((member) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GroupMemberCard(
                            groupId: widget.walkGroup.groupId,
                            userId: member["userId"]!,
                            userImage: member["userImage"]!,
                            userName: member["userName"]!,
                            onRemove: () => removeMember(member),
                            isCreator: _isCreator,
                          ),
                        );
                      }).toList(),
                    ),

                    _isCreator || _isApplicantOrMember
                        ? SizedBox()
                        : Center(
                            child: TextButton(
                              child: Text("참가 신청"),
                              style: defaultTextButtonStyle,
                              onPressed: () {
                                submitApplicant();
                              },
                            ),
                          )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}