import 'package:flutter/cupertino.dart';
import 'package:pettrip_fe/const/colors.dart';

class Tag extends StatelessWidget {
  final String tagName;

  const Tag({super.key, required this.tagName});


@override
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
    decoration: BoxDecoration(
      color: MAIN_COLOR,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Text('#${tagName}', style: TextStyle(fontSize: 12),),
  );
}
}