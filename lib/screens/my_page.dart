import 'package:flutter/material.dart';
import 'package:pettrip_fe/models/user_model.dart';
import 'package:pettrip_fe/screens/add_pet_page.dart';
import 'package:pettrip_fe/services/user_service.dart';

import 'package:pettrip_fe/models/pet_model.dart';
import 'package:pettrip_fe/models/user_model.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late UserModel user;
  Future<void> fetchUserProfile() async {
    try {
      user = await UserService().getProfile('1'/*userID*/);
    } catch(e) {
      throw Exception("프로필 로딩 실패");
    }
  }
  @override
  void initState() {
    fetchUserProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내정보"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.profileImageUrl),
            ),
            SizedBox(height: 8),
            Text(
              user.nickname,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(user.address, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("회원정보수정"),
                ),
                VerticalDivider(),
                TextButton(
                  onPressed: () {},
                  child: Text("로그아웃", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => AddPetPage(userID: 1))
                );
              },
              child: Text("반려동물 추가"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ]
        ),
      )
    );
  }
}


