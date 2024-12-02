import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/style.dart';

class GroupApplicantCard extends StatelessWidget {
  final String userImage;
  final String userName;

  final VoidCallback onAccept;
  final VoidCallback onReject;

  const GroupApplicantCard(
      {super.key,
      required this.userImage,
      required this.userName,
      required this.onAccept,
      required this.onReject});

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
              TextButton(
                onPressed: onReject,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: LIGHT_GRAY_COLOR,
                ),
                child: Text('거절'),
              ),
              SizedBox(width: 5),
              TextButton(
                onPressed: onAccept,
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
