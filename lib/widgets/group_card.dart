import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/models/walk_group_model.dart';
import 'package:pettrip_fe/screens/group/group_detail_page.dart';
import 'package:pettrip_fe/widgets/tag_scroll_view.dart';

import '../const/colors.dart';
import '../services/walk_group_service.dart';

class GroupCard extends StatefulWidget {
  final WalkGroupModel walkGroup;

  const GroupCard({super.key, required this.walkGroup});

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  final WalkGroupService _walkGroupService = WalkGroupService();

  List<Map<String, dynamic>> applicants = [];
  List<Map<String, dynamic>> members = [];

  Future<void> _fetchData() async {
    try {
      final result = await _walkGroupService.getApplicantsAndMembers(
        widget.walkGroup.groupId,
        widget.walkGroup.creatorId,
      );

      setState(() {
        applicants = result['applicants']!;
        members = result['members']!;
      });
    } catch (e) {
      print("멤버 불러오기 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await _fetchData();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupDetailPage(
                        walkGroup: widget.walkGroup,
                        applicants: applicants ?? [],
                        members: members ?? [],
                      )));
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
                children: [
                  Expanded(
                    child: Text(
                      widget.walkGroup.groupName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleTextStyle,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${widget.walkGroup.province} ${widget.walkGroup.city}',
                    style: smallTextStyle,
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TagScrollView(tags: widget.walkGroup.tags),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      decoration: BoxDecoration(
                        color: POINT_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text(
                        '${widget.walkGroup.maxParticipants}명',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
