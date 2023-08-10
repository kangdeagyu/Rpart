import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttermainproject/home_tap.dart';
import 'package:fluttermainproject/view/join_view.dart';
import 'package:fluttermainproject/view/user_view.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  late List data;
  late bool login;
  late AppLifecycleState _lastLifeCycleState;
  late TextEditingController useridController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    data = [];
    login = true;
    useridController = TextEditingController();
    passwordController = TextEditingController();
    _initSharedpreferences();
  }

  @override
  void dispose() {
    _disposeSharedpreferences();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        print('detached');
        break;
      case AppLifecycleState.resumed:
        print('resumed');
        break;
      case AppLifecycleState.inactive:
        _disposeSharedpreferences();
        print('inactive');
        break;
      case AppLifecycleState.paused:
        print('paused');
        break;
    }
    _lastLifeCycleState = state;
    super.didChangeAppLifecycleState(state);
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
                controller: useridController,
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
                // 로그인
                onPressed: () async {
                  var url = Uri.parse(
                      'http://localhost:8080/Flutter/login_select_flutter.jsp?userid=${useridController.text}&password=${passwordController.text}'); //uri는 정보를 주고 가져오는 것
                  var response = await http.get(url);
                  var dataConvertedJSON =
                      json.decode(utf8.decode(response.bodyBytes));
                  String result = dataConvertedJSON['result'];

                  print("result = $result");
                  if (result == 'fail') {
                    Get.snackbar('로그인', '실패했찌롱~~~');
                  } else {
                    _disposeSharedpreferences();
                    _saveSharedpreferences();
                    print("shared saved222!");
                    Get.to(const HomeTap(), arguments: 0);
                  }
                },
                child: const Text('llllllogin'),
                // 강현이가 함!
              ),
              ElevatedButton(
                // 회원가입
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

  Future<void> _initSharedpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    useridController.text = prefs.getString('userid') ?? "";
    passwordController.text = prefs.getString('password') ?? "";

    //앱을 종료하고 다시 실행하면 SharedPreferences에 남아 있으므로 앱을 종료시 정리해야한다.
    print(useridController);
    print(passwordController);
  }

  _saveSharedpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', useridController.text);
    prefs.setString('password', passwordController.text);
    print("shared saved!");
    setState(() {});
  }

  _disposeSharedpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    prefs.clear();
  }
}
