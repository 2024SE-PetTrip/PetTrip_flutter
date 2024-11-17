import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/screens/course_save_page.dart';

import '../const/style.dart';
import '../services/location_service.dart';
import '../widgets/map_widget.dart';

class CourseMakerPage extends StatefulWidget {
  const CourseMakerPage({super.key});

  @override
  State<CourseMakerPage> createState() => _CourseMakerPageState();
}

class _CourseMakerPageState extends State<CourseMakerPage> {
  late LocationService _locationService;
  bool _isTracking = false;
  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _trackedTime = '00:00:00';

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
  }

  // 코스 추적 시작
  void _startTracking() {
    _stopwatch.start();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {_isTracking = true;});
    });

    _locationService.startLocationTracking();
  }

  // 코스 추적 종료
  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });
    _stopwatch.stop();
    _trackedTime = _stopwatchFormat();
    _stopwatch.reset();
    _timer.cancel();

    _locationService.stopLocationTracking();
  }

  String _stopwatchFormat() {
    final hours = _stopwatch.elapsed.inHours;
    final minutes = _stopwatch.elapsed.inMinutes.remainder(60);
    final seconds = _stopwatch.elapsed.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text('코스 생성')
      // ),
      body: Column(
        children: [
          mapWidget(locationService: _locationService),
          Text(
            _stopwatchFormat(),
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30,),
          _isTracking?
          TextButton(
              onPressed: () {
                _stopTracking();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseSavePage(trackedTime: _trackedTime, pathCoordinates: _locationService.pathCoordinates),
                  ),
                );},
              child: Text('코스 기록 종료'), style: TEXT_BUTTON_STYLE) :
          TextButton(
              onPressed: () {_startTracking();},
              child: Text('코스 기록 시작'), style: TEXT_BUTTON_STYLE),
        ],
      ),
    );
  }
}
