import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/style.dart';

class GroupMemberCard extends StatelessWidget {
  final String userImage;
  final String userName;

  final bool isCreator;
  final VoidCallback onRemove;

  const GroupMemberCard({super.key, required this.userImage, required this.userName, required this.isCreator, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: LIGHT_GRAY_COLOR), borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(child: Image.network(userImage, width: 30, height: 30, fit:BoxFit.cover)),
              SizedBox(width: 10,),
              Text(userName)
            ],
          ),
          isCreator? TextButton(
            onPressed: onRemove,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: WARNING_COLOR,
            ),
            child: Text('삭제'),
          ): SizedBox()
        ],
      ),
    );
  }
}
