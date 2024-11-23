import 'package:flutter/material.dart';

import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/const/style.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: MAIN_COLOR),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
      onPressed: (){
        //TODO: 필터링 창 구현
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_alt, color: Colors.black),
          SizedBox(width: 8),
          Text('필터링', style: TextStyle(color: Colors.black)),
        ],
      )
    );
  }
}
