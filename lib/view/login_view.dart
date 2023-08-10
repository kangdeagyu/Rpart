import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermainproject/home_tap.dart';
import 'package:fluttermainproject/view/join_view.dart';
import 'package:fluttermainproject/view/user_view.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  late String kakaoinfo;
  late List data;
  late bool login;
  late AppLifecycleState _lastLifeCycleState;
  late TextEditingController useridController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    kakaoinfo = '';
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
                child: const Text('login'),
              ),
              ElevatedButton(
                // 회원가입
                onPressed: () {
                  Get.to(JoinPage());
                },
                child: const Text('회원가입'),
              ),
              //카카오톡 로그인 버튼
              //유저 상황에 따른 조건식 진행
              ElevatedButton(
                onPressed: () async {
                  if (await isKakaoTalkInstalled()) {
                    try {
                      await UserApi.instance.loginWithKakaoTalk();
                       Get.to(HomeTap(), arguments: kakaoinfo);
                      print('카카오톡으로 로그인 성공');
                    } catch (error) {
                      print('카카오톡으로 로그인 실패 $error');

                      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
                      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
                      if (error is PlatformException &&
                          error.code == 'CANCELED') {
                        return;
                      }
                      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                      try {
                        await UserApi.instance.loginWithKakaoAccount();
                        print('카카오계정으로 로그인 성공');
                        Get.to(HomeTap(), arguments: kakaoinfo);
                      } catch (error) {
                        print('카카오계정으로 로그인 실패 $error');
                      }
                    }
                  } else {
                    try {
                      await UserApi.instance.loginWithKakaoAccount();
                      print('카카오계정으로 로그인 성공');
                      Get.to(HomeTap(), arguments: kakaoinfo);
                    } catch (error) {
                      print('카카오계정으로 로그인 실패 $error');
                    }
                  } 
                  Get.to(HomeTap());
                },
                child: const Text('카카오 로그인'),
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
