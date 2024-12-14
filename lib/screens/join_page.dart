import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pettrip_fe/services/login_service.dart';

import '../const/style.dart';
import '../widgets/province_city_selector.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final LoginService _loginService = LoginService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); // email
  final TextEditingController _realnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedProvince; // 도/광역시
  String? _selectedCity; // 시/군/구

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // 입력 데이터
      final nickname = _nicknameController.text;
      final username = _usernameController.text;
      final realname = _realnameController.text;
      final password = _passwordController.text;
      final address = '$_selectedProvince $_selectedCity';

      // joinData 객체 구성
      final joinData = {
        'nickname': nickname,
        'username': username,
        'realname': realname,
        'password': password,
        'address': address,
      };

     final response = await _loginService.join(joinData);
      if (response['success']) {
        // 성공 시 직전 화면으로 pop
        Navigator.pop(context);
        print('회원가입 성공');
      } else {
        // 실패 시 오류 메시지 SnackBar로 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? '회원가입 실패'),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('회원가입'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("이메일"),
                TextFormField(
                  controller: _usernameController,
                  decoration: roundedInputDecoration(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해 주세요';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return '이메일 형식이 아닙니다';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text("비밀번호"),
                TextFormField(
                  controller: _passwordController,
                  decoration:  roundedInputDecoration(),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해 주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text("닉네임"),
                TextFormField(
                  controller: _nicknameController,
                  decoration: roundedInputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '닉네임을 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text("실명"),
                TextFormField(
                  controller: _realnameController,
                  decoration:  roundedInputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해 주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text("지역"),
                ProvinceCitySelector(
                  selectedProvince: _selectedProvince,
                  selectedCity: _selectedCity,
                  onProvinceChanged: (province) {
                    setState(() {
                      _selectedProvince = province;
                      _selectedCity = null; // 시/군/구 초기화
                    });
                  },
                  onCityChanged: (city) {
                    setState(() {
                      _selectedCity = city;
                    });
                  },
                ),
                SizedBox(height: 32),
                Center(
                  child: TextButton(
                    style: defaultTextButtonStyle,
                    onPressed: _submitForm,
                    child: Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _nicknameController.dispose();
    _usernameController.dispose();
    _realnameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}