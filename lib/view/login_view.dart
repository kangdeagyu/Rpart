import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttermainproject/home_tap.dart';
import 'package:fluttermainproject/main.dart';
import 'package:fluttermainproject/view/apartment_view.dart';
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
    late AppLifecycleState _lastLifeCycleState;
  late List data;
  late TextEditingController useridController;
  late TextEditingController passwordController;
  late String str;
  late String str2;
  late var userinfo = '';
  // late bool checklogin;
  
  

  @override
  void initState() {
    super.initState();
    data = [];
    useridController = TextEditingController();
    passwordController = TextEditingController();
     _initSharedpreferences();
    getJSONData();
    str = '';
    str2 = '';
    // checklogin = false;
  }
@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state){
      case AppLifecycleState.detached:
      print('detached');
      break;
      case AppLifecycleState.resumed:
      print('resumed');
      break;
      case AppLifecycleState.inactive:
      _disposeSharedPreferences();
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
                onPressed: () {
                  print(getJSONData());
              
                 
                },
                child: const Text('로그인'),
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
        'http://localhost:8080/Flutter/login_select_flutter.jsp?userid=${useridController.text}&password=${passwordController.text}'); //uri는 정보를 주고 가져오는 것
    var response = await http.get(url);
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];


    data.addAll(result);
    setState(( ) {});
   print(data);
    if(result.isNotEmpty){
      Get.offAll(HomeTap());
    }else {
      
    }
  }

_initSharedpreferences()async{
  final prefs = await SharedPreferences.getInstance();
  useridController.text = prefs.getString('userid') ?? "";
  passwordController.text = prefs.getString('password') ?? "";

  //앱을 종료하고 다시 실행하면 SharedPreferences에 남아 있으므로 앱을 종료시 정리해야한다.
  print(useridController);
  print(passwordController);
}

_saveSharedPreferences() async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', useridController.text);
  prefs.setString('password', passwordController.text);
}


_disposeSharedPreferences() async{
  final prefs = await SharedPreferences.getInstance();
  prefs.clear(); 
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

