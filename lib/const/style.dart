import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/colors.dart';

ButtonStyle TEXT_BUTTON_STYLE = TextButton.styleFrom(
  padding: EdgeInsets.symmetric(horizontal: 80),
  foregroundColor: Colors.white,
  backgroundColor: MAIN_COLOR,
  splashFactory: NoSplash.splashFactory,
  textStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  ),
);

OutlineInputBorder INPUT_BORDER = OutlineInputBorder(
  borderSide: BorderSide(
    color: LIGHT_GRAY_COLOR,
  ),
  borderRadius: BorderRadius.all(Radius.circular(15)),
);