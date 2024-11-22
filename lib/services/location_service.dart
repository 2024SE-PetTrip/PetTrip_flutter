import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

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
    _locationTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
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
}

