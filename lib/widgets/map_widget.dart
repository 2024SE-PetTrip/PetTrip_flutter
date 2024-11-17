// 네이버맵 테스트 코드
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pettrip_fe/const/colors.dart';

import '../services/location_service.dart';

class mapWidget extends StatefulWidget {
  final LocationService locationService;
  const mapWidget({Key? key, required this.locationService});

  @override
  State<mapWidget> createState() => _mapWidgetState();
}

class _mapWidgetState extends State<mapWidget> {
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
      width: 6,
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
    // NaverMapController 객체의 비동기 작업 완료를 나타내는 Completer 생성
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
          options: const NaverMapViewOptions(
            logoAlign: NLogoAlign.rightTop,
            logoMargin: EdgeInsets.all(10),
            logoClickEnable: false,
            rotationGesturesEnable: false,
            scrollGesturesEnable: false,
            tiltGesturesEnable: false,
            stopGesturesEnable: false,
            extent: NLatLngBounds(
              southWest: NLatLng(31.43, 122.37),
              northEast: NLatLng(44.35, 132.0),
            ),
            minZoom: 9,
          ),
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
