import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
    late String userid;
  late String password;

  @override
  void initState() {
    super.initState();
    userid = '';
    password = '';
    _initSharedpreferences();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  _initSharedpreferences() async{
  final prefs = await SharedPreferences.getInstance();
  userid = prefs.getString('userid')!;
  password = prefs.getString('password')!;
setState(() {
  
});
}
}