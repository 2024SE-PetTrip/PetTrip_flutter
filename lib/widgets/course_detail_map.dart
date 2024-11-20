import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pettrip_fe/const/style.dart';

import '../const/colors.dart';

class CourseDetailMap extends StatefulWidget {
  final List<NLatLng> pathCoordinates;

  const CourseDetailMap({super.key, required this.pathCoordinates});

  @override
  State<CourseDetailMap> createState() => _CourseDetailMapState();
}

class _CourseDetailMapState extends State<CourseDetailMap> {
  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return SizedBox(
      height: 300,
      child: NaverMap(
        options: defaultNaverMapOptions.copyWith(
          initialCameraPosition: NCameraPosition(target: widget.pathCoordinates.first, zoom: 12),
        ),
        onMapReady: (controller) async {
          final startMarker = NMarker(
            id: "start",
            position: widget.pathCoordinates.first,
            caption: NOverlayCaption(text: "시작", haloColor: Colors.white),
          );
          final endMarker = NMarker(
            id: "end",
            position: widget.pathCoordinates.last,
            caption: NOverlayCaption(text: "도착", haloColor: Colors.white),
          );
          controller.addOverlayAll({startMarker, endMarker});
          if (widget.pathCoordinates.isNotEmpty &&
              widget.pathCoordinates.length > 1) {
            controller.addOverlay(NPathOverlay(
              id: 'path',
              coords: widget.pathCoordinates,
              width: 5,
              color: POINT_COLOR,
            ));
          }
          mapControllerCompleter.complete(controller);
        },
      ),
    );
  }
}
