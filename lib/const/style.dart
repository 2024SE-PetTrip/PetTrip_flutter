import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pettrip_fe/const/colors.dart';

ButtonStyle defaultTextButtonStyle = TextButton.styleFrom(
  padding: EdgeInsets.symmetric(horizontal: 80),
  foregroundColor: Colors.white,
  backgroundColor: MAIN_COLOR,
  splashFactory: NoSplash.splashFactory,
  textStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  ),
);

OutlineInputBorder defaultInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: LIGHT_GRAY_COLOR,
  ),
  borderRadius: BorderRadius.all(Radius.circular(15)),
);

InputDecoration roundedInputDecoration() {
  return InputDecoration(
    filled: false,
    contentPadding: EdgeInsets.symmetric(horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: DARK_GRAY_COLOR), // 기본 테두리 색상
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: DARK_GRAY_COLOR), // 활성화 상태
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: DARK_GRAY_COLOR), // 포커스 상태
    ),
  );
}

NaverMapViewOptions defaultNaverMapOptions = NaverMapViewOptions(
  logoAlign: NLogoAlign.rightTop,
  logoMargin: EdgeInsets.all(10),
  logoClickEnable: false,
  rotationGesturesEnable: false,
  tiltGesturesEnable: false,
  stopGesturesEnable: false,
  extent: NLatLngBounds(
    southWest: NLatLng(33.0, 122.37),
    northEast: NLatLng(38.9, 132.0),
  ),
  minZoom: 9,
);

TextStyle smallTextStyle = TextStyle(fontSize: 10, color: DARK_GRAY_COLOR);
TextStyle titleTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

Divider defaultDivider =  Divider(thickness: 5, color: LIGHT_GRAY_COLOR,);