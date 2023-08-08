import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttermainproject/home_tap.dart';
import 'package:fluttermainproject/view/login_view.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
const UserView({Key? key}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> with WidgetsBindingObserver{
     late AppLifecycleState _lastLifeCycleState;
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state){
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
      body: Center(
        
          child: Row(
            children: [
           Text(
            '$userid / $password'
           ),
           ElevatedButton(
            onPressed: () async {
        // final prefs = await SharedPreferences.getInstance();
        // prefs.remove('userid');
        // prefs.remove('password');
        _initSharedpreferences();
        _disposeSharedpreferences();
        Get.offAll(HomeTap());
            },
            child: Text('로그아웃'))
        
            ],
          ),
        )
       
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

}

  Future<void> _initSharedpreferences() async{
  final prefs = await SharedPreferences.getInstance();
  userid = prefs.getString('userid')??"";
  password = prefs.getString('password')??"";
  if (userid.isNotEmpty || password.isNotEmpty) {
    await getJSONData();
  }
setState(() {
  
});
}
_disposeSharedpreferences() async{
  final prefs = await SharedPreferences.getInstance();
  prefs.clear(); 
}


}