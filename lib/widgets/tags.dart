import 'package:flutter/cupertino.dart';
import 'package:pettrip_fe/const/colors.dart';

class Tags extends StatelessWidget {
  final List<String> tags;

  const Tags({super.key, required this.tags});


@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: tags.map((tag) {
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            decoration: BoxDecoration(
              color: MAIN_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text('#$tag', style: TextStyle(fontSize: 12),),
          ),
        );
      }).toList(),
    ),
  );
}
}
