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