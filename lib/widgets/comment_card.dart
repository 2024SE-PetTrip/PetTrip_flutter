import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/const/style.dart';

class CommentCard extends StatelessWidget {
  final String userImage;
  final String userName;
  final String comment;

  const CommentCard(
      {super.key,
      required this.userImage,
      required this.userName,
      required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: LIGHT_GRAY_COLOR),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              userImage.isNotEmpty
                  ? ClipOval(
                      child: Image.network(userImage,
                          width: 30, height: 30, fit: BoxFit.cover))
                  : SizedBox(
                      width: 30,
                      height: 30,
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          size: 20,
                        ),
                      ),
                    ),
              SizedBox(
                width: 10,
              ),
              Text(
                userName,
                style: smallTextStyle,
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(comment),
        ],
      ),
    );
  }
}
