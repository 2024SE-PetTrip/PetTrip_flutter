import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/style.dart';
import '../services/login_service.dart';
import 'join_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginService _loginService = LoginService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(); // email
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // 입력된 이메일과 비밀번호
      final username = _usernameController.text;
      final password = _passwordController.text;

      final jwtToken = await _loginService.login(username, password);
      // 응답 확인
      if (jwtToken != null) {
        Navigator.pushReplacementNamed(context, '/home'); // 홈 화면으로 이동
        print('로그인 성공');
      } else {
        // 실패 시 오류 메시지 SnackBar로 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 실패! 이메일 또는 비밀번호를 확인해 주세요'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Center(
                child: Image.asset(
                  'assets/images/pettrip_logo.png',
                  width: 200
                ),
              ),
              SizedBox(height: 20),
              Text("이메일"),
              TextFormField(
                controller: _usernameController,
                decoration: roundedInputDecoration(),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해 주세요';
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
              SizedBox(height: 32),
              Center(
                child: TextButton(
                  style: defaultTextButtonStyle,
                  onPressed: _submitForm,
                  child: Text('로그인'),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero, // 패딩을 0으로 설정해서 여백 없애기
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 클릭 영역을 글자만큼만 설정
                  ),
                  onPressed: () {
                    // 회원가입 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoinPage()),
                    );
                  },
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
}
