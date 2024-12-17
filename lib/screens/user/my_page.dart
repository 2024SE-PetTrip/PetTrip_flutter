import 'package:flutter/material.dart';
import 'package:pettrip_fe/const/style.dart';
import 'package:pettrip_fe/models/user_model.dart';
import 'package:pettrip_fe/screens/user/add_pet_page.dart';
import 'package:pettrip_fe/services/token_storage.dart';
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
  late int _userId;
  bool _isLoading = false;

  Future<void> fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final int? userId = await getUserId();
      user = await UserService().getProfile(userId.toString());
      setState(() {
        _userId = userId!;
        _isLoading = false;
      });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("내정보"),
      ),
      body: _isLoading?
      Center(
        child: CircularProgressIndicator(),
      ):
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  user.profileImageUrl!.isEmpty ?
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipOval(
                      child: Icon(
                        Icons.person,
                        size: 80,
                      ),
                    ),
                  ):
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.profileImageUrl!),
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
                SizedBox(width: 10),
                Text('|'),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: Text("로그아웃", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
              ),
            ),
            defaultDivider,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => AddPetPage(userID: _userId))
                );
              },
              child: Text("반려동물 추가"),
              style: defaultTextButtonStyle
            ),
          ]
        ),
      )
    );
  }
}


