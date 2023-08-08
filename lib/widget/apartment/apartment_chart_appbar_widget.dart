import 'package:flutter/material.dart';
import 'package:fluttermainproject/model/wishlist_sqlite/wishlist_sqllite.dart';
import 'package:fluttermainproject/widget/apartment/apartment_chart_body_widget.dart';
import 'package:get/get.dart';
import 'package:fluttermainproject/model/obs/apartmentcontroller.dart';
import 'package:fluttermainproject/viewmodel/wishlist_sqlitedb.dart';

class ApartmentChartWidget extends StatelessWidget {
  WishlistDatabaseHandler handler = Get.put(WishlistDatabaseHandler());

  ApartmentChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apartmentName =
        Get.find<ApartmentControllerObs>().apartmentName.value;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(apartmentName),
          actions: [
            GetBuilder<WishlistDatabaseHandler>(
              builder: (controller) {
                return FutureBuilder<List<WishlistSql>>(
                  future: handler.queryWishListstar(apartmentName),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return IconButton(
                        onPressed: () {
                          handler.insertWishList(apartmentName);
                          Get.snackbar(
                            'WishList',
                            'WishList에 추가 되었습니다.',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.yellowAccent,
                          );
                        },
                        icon: const Icon(Icons.star_border),
                      );
                    } else {
                      return IconButton(
                        onPressed: () {
                          handler.deleteWishList(apartmentName);
                          Get.snackbar(
                            'WishList',
                            'WishList가 취소 되었습니다.',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.yellowAccent,
                          );
                        },
                        icon: const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      );
                    }
                  },
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
