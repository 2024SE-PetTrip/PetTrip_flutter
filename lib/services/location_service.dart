import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../const/secret_key.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final List<NLatLng> pathCoordinates = []; // 경로 좌표 저장 리스트
  late Timer _locationTimer;

  // StreamController로 위치 변화 알림
  final StreamController<List<NLatLng>> _pathStreamController = StreamController.broadcast();
  Stream<List<NLatLng>> get pathStream => _pathStreamController.stream;

  // 현재 위치를 가져오는 함수
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  // TODO: 좌표 저장 간격 조절
  // 10초마다 현재 위치를 받아서 경로를 추가하는 함수
  void startLocationTracking() {
    _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      Position? position = await _getCurrentLocation();
      if (position != null) {
        // 새로운 좌표를 저장
        NLatLng newCoordinate = NLatLng(position.latitude, position.longitude);
        pathCoordinates.add(newCoordinate);

        // 스트림을 통해 경로 업데이트 알림
        _pathStreamController.add(List.from(pathCoordinates));
      }
    });
  }

  // 위치 추적 중지
  void stopLocationTracking() {
    _locationTimer.cancel();
    _pathStreamController.close();
  }

  /// 경로를 포함하는 지도 이미지 URL 생성 메서드
  Future<String> getStaticMapUrl() async {
    if (pathCoordinates.isEmpty) {
      throw Exception('Path coordinates are empty');
    }

    // 경로를 문자열로 변환
    String pathString = pathCoordinates
        .map((coord) => '${coord.longitude},${coord.latitude}')
        .join('|');

    // Static Map API Base URL
    final String baseUrl = 'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster';

    // 쿼리 매개변수 직접 조립 (인코딩 문제 방지)
    final String queryString = Uri(queryParameters: {
      'center': '${pathCoordinates.last.longitude},${pathCoordinates.last.latitude}',
      'level': '14',
      'w': '800',
      'h': '600',
      'path': 'weight:5|color:0xFF0000|$pathString', // 여기에서 직접 작성
    }).query;

    final String requestUrl = '$baseUrl?$queryString';

    // 헤더 설정
    final headers = {
      'x-ncp-apigw-api-key-id': naverMapID,
      'x-ncp-apigw-api-key': naverMapSecret,
    };

    debugPrint('**requestUrl: $requestUrl');

    // HTTP 요청
    final response = await http.get(Uri.parse(requestUrl), headers: headers);

    if (response.statusCode == 200) {
      return requestUrl;
    } else {
      throw Exception('Failed to generate map URL: ${response.statusCode}, ${response.body}');
    }
  }
}

