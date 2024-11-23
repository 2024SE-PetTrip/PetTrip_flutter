// 네이버맵 테스트 코드
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pettrip_fe/const/colors.dart';
import 'package:pettrip_fe/const/style.dart';

import '../services/location_service.dart';

class CourseMakerMap extends StatefulWidget {
  final LocationService locationService;
  const CourseMakerMap({Key? key, required this.locationService});

  @override
  State<CourseMakerMap> createState() => _CourseMakerMapState();
}

class _CourseMakerMapState extends State<CourseMakerMap> {
  late NaverMapController _mapController;
  late StreamSubscription<List<NLatLng>> _pathSubscription;

  @override
  void initState() {
    super.initState();

    // 경로 업데이트 스트림 구독
    _pathSubscription = widget.locationService.pathStream.listen((pathCoordinates) {
      _updatePathOnMap(pathCoordinates);
    },
      onDone: () {
        _mapController.clearOverlays();
      },);
  }

  // 경로를 지도에 업데이트
  void _updatePathOnMap(List<NLatLng> pathCoordinates) {
    if (pathCoordinates.isEmpty || pathCoordinates.length < 2) return;

    final pathOverlay = NPathOverlay(
      id: 'path',
      coords: pathCoordinates,
      width: 5,
      color: POINT_COLOR,
    );

    _mapController.addOverlay(pathOverlay);
  }

  @override
  void dispose() {
    _pathSubscription.cancel(); // 스트림 구독 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return ShaderMask(
      shaderCallback: (Rect bound){
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white,Colors.transparent],
            stops: [0.7, 0.9]
        ).createShader(bound);
      },
      blendMode: BlendMode.dstIn,
      child: Container(
        height: 430,
        child: NaverMap(
          options: defaultNaverMapOptions,
          onMapReady: (controller) async {
            controller.setLocationTrackingMode(NLocationTrackingMode.follow);
            _mapController = controller;
            mapControllerCompleter.complete(controller);
            },
        ),
      ),
    );
  }
}
