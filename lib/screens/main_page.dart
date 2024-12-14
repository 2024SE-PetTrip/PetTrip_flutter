import 'package:flutter/material.dart';
import 'package:pettrip_fe/screens/course_maker_page.dart';
import 'package:pettrip_fe/screens/course_list_page.dart';
import 'package:pettrip_fe/screens/group_list_page.dart';
import 'package:pettrip_fe/screens/care_service_page.dart';
import 'package:pettrip_fe/const/colors.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      CourseMakerPage(),
      CourseListPage(),
      GroupListPage(),
      CareServicePage(),
      Placeholder(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: '코스생성'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '코스찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: '산책모임'),
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: '돌봄요청'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: MAIN_COLOR,
        unselectedItemColor: DARK_GRAY_COLOR,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
