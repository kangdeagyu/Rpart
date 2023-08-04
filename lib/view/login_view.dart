import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermainproject/view/apartment_view.dart';
import 'package:fluttermainproject/view/join_view.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late List data;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController userIdController;
  late TextEditingController passwordController;
  
  late String userid;

  @override
  void initState() {
    super.initState();
    data = [];
    userIdController = TextEditingController();
    passwordController = TextEditingController();
    getJSONData();
    userid = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: '아이디를 입력해주세요',
                ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호를 입력해주세요',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // = getJSONData()data.[Index]['userid'];
                },
                child: const Text('로그인이라는 건 없다!'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(JoinPage());
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getJSONData() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/login_select_flutter.jsp'); //uri는 정보를 주고 가져오는 것
    var response = await http.get(url);
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    data.addAll(result);
    setState(() {});
    print(response.body);
  }


  //  if (userIdController.text.trim().isEmpty) {
  //                   // 유저 아이디 필드가 비어있을 경우
  //                   Get.snackbar(
  //                     '빈칸을 채워주세요',
  //                     '아이디를 입력해주세요',
  //                     snackPosition: SnackPosition.TOP,
  //                     duration: const Duration(seconds: 2),
  //                     backgroundColor: Colors.teal,
  //                   );
  //                 } else if (passwordController.text.trim().isEmpty) {
  //                   // 비밀번호 필드가 비어있을 경우
  //                   Get.snackbar(
  //                     '빈칸을 채워주세요',
  //                     '비밀번호를 입력해주세요',
  //                     snackPosition: SnackPosition.TOP,
  //                     duration: const Duration(seconds: 2),
  //                     backgroundColor: Colors.teal,
  //                   );
  //                 }
}
