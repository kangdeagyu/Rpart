import 'package:flutter/material.dart';
import 'package:fluttermainproject/view/apartment_view.dart';
import 'package:fluttermainproject/view/google_map_view.dart';
import 'package:fluttermainproject/view/prediction_lease_view.dart';
import 'package:fluttermainproject/view/login_view.dart';
import 'package:fluttermainproject/view/user_view.dart';
import 'package:fluttermainproject/view/wishlist_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({Key? key}) : super(key: key);

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> with SingleTickerProviderStateMixin {
  // Property
  late List data; 
  late bool login;
  late String userid;
  late String password;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    userid ='';
    password ='';
    login = true;
     _initSharedpreferences();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int initialTabIndex = Get.arguments ?? 0;
    _tabController.index = initialTabIndex;
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: login
            ? const [
                ApartmentView(),
                WishlistView(),
                GoogleMapView(),
                LoginPage(),
              ]
            : const [
                ApartmentView(),
                WishlistView(),
                GoogleMapView(),
                UserView(),
              ],
      ),
      bottomNavigationBar: TabBar(
        labelColor: Colors.green,
        controller: _tabController,
        tabs: login
            ? const [
                Tab(
                  icon: Icon(Icons.pin_drop),
                  text: '지도',
                ),
                Tab(
                  icon: Icon(Icons.star),
                  text: '찜 목록',
                ),
                Tab(
                  icon: Icon(Icons.addchart,),
                  text: '분석',
                ),
                Tab(
                  icon: Icon(Icons.add_circle),
                  text: '로그인',
                ),
              ]
            : const [
                Tab(
                  icon: Icon(Icons.pin_drop),
                  text: '지도',
                ),
                Tab(
                  icon: Icon(Icons.star),
                  text: '찜 목록',
                ),
                Tab(
                  icon: Icon(Icons.addchart,),
                  text: '분석',
                ),
                Tab(
                  icon: Icon(Icons.account_circle),
                  text: '사용자',
                ),
              ],
      ),
    );
  }
   Future<void> _initSharedpreferences() async {
      final prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid') ?? "";
      password = prefs.getString('password') ?? "";
      login = userid.trim().isEmpty;
      setState(() {});
    }

}
