import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/style.dart';
import '../services/walk_group_service.dart';

class GroupApplicantCard extends StatelessWidget {
  final String userImage;
  final String userName;
  final int userId;
  final int groupId;

  final VoidCallback onAccept;
  final VoidCallback onReject;

  final WalkGroupService _groupService = WalkGroupService();

  GroupApplicantCard({super.key,
    required this.userImage,
    required this.userName,
    required this.onAccept,
    required this.onReject, required this.userId, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: LIGHT_GRAY_COLOR),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                  child: Image.network(userImage,
                      width: 30, height: 30, fit: BoxFit.cover)),
              SizedBox(width: 10),
              Text(userName)
            ],
          ),
          Row(
            children: [
              // 거절 버튼
              TextButton(
                onPressed: () async {
                  try {
                    await _groupService.rejectApplicant(groupId, userId);
                    onReject;
                  } catch (e) {}
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: LIGHT_GRAY_COLOR,
                ),
                child: Text('거절'),
              ),
              SizedBox(width: 5),

              // 수락 버튼
              TextButton(
                onPressed: () async {
                  try {
                    await _groupService.acceptApplicant(groupId, userId);
                    onAccept;
                  } catch (e) {}
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: MAIN_COLOR,
                ),
                child: Text('수락'),
              )
            ],
          )
        ],
      ),
    );
  }
}
