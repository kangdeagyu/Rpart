import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttermainproject/home_tap.dart';
import 'package:fluttermainproject/view/apartment_view.dart';
import 'package:fluttermainproject/view/login_view.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> with WidgetsBindingObserver{
  // late AuthController authController;
//   var tokenResponse = AccessTokenResponse.fromJson(response);
// var token = OAuthToken.fromResponse(tokenResponse);

     late List data;
    late String userid = '';
  late String password = '';
    late TextEditingController useridController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    data = [];
    useridController = TextEditingController();
    passwordController = TextEditingController();
    _initSharedpreferences();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        
          child: Row(
            children: [
          Text(
            '$userid / $password'
          ),
          ElevatedButton(
            onPressed: ()  {
              _initSharedpreferences();
              _disposeSharedpreferences();
              Get.toNamed('/next');
            },
            child: Text('로그아웃'))
        
            ],
          ),
        )
      
      );
    
  }



_initSharedpreferences() async{
  final prefs = await SharedPreferences.getInstance();
  userid = prefs.getString('userid')!;
  password = prefs.getString('password')!;
//setState를 사용해야 UserPage에서 userid,password가 표시
setState(() {
  
});
}
_disposeSharedpreferences() async{
  final prefs = await SharedPreferences.getInstance();
  prefs.clear(); 
}


}