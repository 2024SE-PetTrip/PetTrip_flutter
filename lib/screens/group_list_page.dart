import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/dummy_data.dart';
import 'package:pettrip_fe/screens/create_group_page.dart';

import '../const/colors.dart';
import '../widgets/group_card.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('모임 찾기')),
      body: GroupCard(walkGroup: dummyGroupData,), // TODO: 그룹 리스트 불러오는 로직 추가
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateGroupPage()
              )
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: MAIN_COLOR,
        child: const Icon(
          color: Colors.white,
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
