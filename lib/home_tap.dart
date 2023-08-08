import 'package:flutter/material.dart';
import 'package:fluttermainproject/view/apartment_view.dart';
import 'package:fluttermainproject/view/prediction_lease_view.dart';
import 'package:fluttermainproject/view/user_view.dart';
import 'package:fluttermainproject/view/wishlist_view.dart';
import 'package:get/get.dart';

class HomeTap extends StatefulWidget{
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> with SingleTickerProviderStateMixin {

  // Property
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
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
        children: const [
          ApartmentView(),
          WishlistView(),
          UserView(),
          PredictionLeaseView(),
        ],
      ),
      bottomNavigationBar: TabBar(
        labelColor: Colors.green,
        controller: _tabController,
        tabs: const [
          Tab(
            icon: Icon(
              Icons.pin_drop,
            ),
            text: 'Map',
          ),
          Tab(
            icon: Icon(
              Icons.star,
            ),
            text: 'WishList',
          ),
          Tab(
            icon: Icon(
              Icons.add_circle,
            ),
            text: '더보기',
          ),
          Tab(
            icon: Icon(
              Icons.addchart,
            ),
            text: '분석',
          ),
        ],
      ),
    );
  }
}