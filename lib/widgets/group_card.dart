import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/models/walk_group_model.dart';
import 'package:pettrip_fe/screens/group_detail_page.dart';
import 'package:pettrip_fe/widgets/tag_scroll_view.dart';

import '../const/colors.dart';
import '../const/dummy_data.dart';

class GroupCard extends StatelessWidget {
  final WalkGroupModel walkGroup;

  const GroupCard({super.key, required this.walkGroup});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // TODO: 실제 참가신청자 받아오는 로직으로 수정
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupDetailPage(
                        walkGroup: walkGroup,
                        applicants: [
                          {'userImage': testUserImage, 'userName': '유저1'},
                          {'userImage': testUserImage, 'userName': '유저2'}
                        ],
                        members: [
                          {'userImage': testUserImage, 'userName': '유저3'},
                          {'userImage': testUserImage, 'userName': '유저4'},
                          {'userImage': testUserImage, 'userName': '유저5'}
                        ],
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
                      walkGroup.groupName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleTextStyle,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${walkGroup.province} ${walkGroup.city}',
                    style: smallTextStyle,
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TagScrollView(tags: walkGroup.tags),
                  Padding(padding: EdgeInsets.only(right: 5),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                      color: POINT_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                    '${walkGroup.maxParticipants}명',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),),
                ],
              )
            ],
          ),
        ));
  }
}
