import 'package:flutter/material.dart';
import 'package:fluttermainproject/model/obs/wishlistcontoller.dart';
import 'package:fluttermainproject/widget/apartment/apartment_chart_body_widget.dart';
import 'package:get/get.dart';
import 'package:fluttermainproject/model/obs/apartmentcontroller.dart';
import 'package:fluttermainproject/viewmodel/wishlist_sqlitedb.dart';

class ApartmentChartWidget extends StatelessWidget {
  final wishlistController = Get.put(WishListControllerObs());
  WishlistDatabaseHandler handler = Get.put(WishlistDatabaseHandler());

  ApartmentChartWidget({super.key});
  
  @override
  Widget build(BuildContext context) {

    // Getx로부터 데이터를 가져옵니다.
    final apartmentName = Get.find<ApartmentControllerObs>().apartmentName.value;
    //
    final wishlistStar = Get.find<WishListControllerObs>().apartmentStar.value;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(apartmentName),
          actions: [
            GetBuilder<WishlistDatabaseHandler>(
              builder: (controller) {
                return IconButton(
                  onPressed: () {
                    if (wishlistStar == 'false') {
                      handler.insertWishList(apartmentName);
                      Get.snackbar(
                        'WishList',
                        'WishList에 추가 되었습니다.',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.yellowAccent,
                      );
                      wishlistController.setApartmentStar('true');
                    } else {
                      handler.deleteWishList(apartmentName);
                      Get.snackbar(
                        'WishList',
                        'WishList가 취소 되었습니다.',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.yellowAccent,
                      );
                      wishlistController.setApartmentStar('false');
                    }
                  },
                  icon: Icon(
                    Icons.star,
                    color: wishlistStar == 'true' ? Colors.yellow : Colors.black,
                  ),
                );
              },
            ),
          ],
        ),
        body: const ApartmentChartBody(),
      ),
    );
  }
}
