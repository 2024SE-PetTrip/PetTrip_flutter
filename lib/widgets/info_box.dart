import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/style.dart';

// 이동 시간, 이동 거리 등 정보 표시에 사용하는 작은 회색 박스
// title에 정보 이름, content에 정보 내용
class InfoBox extends StatelessWidget {
  final String title;
  final String content;

  const InfoBox({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: LIGHT_GRAY_COLOR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: smallTextStyle), // title 텍스트
          SizedBox(height: 8),
          Text(content), // content 텍스트
        ],
      ),
    );
  }
}