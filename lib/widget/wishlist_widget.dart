import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/wishlist_sqlitedb.dart';
import 'package:get/get.dart';

class WishlistWidget extends StatelessWidget {
  WishlistDatabaseHandler handler = Get.put(WishlistDatabaseHandler());

  WishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: handler.queryWishList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.04),
                    child: Text(
                      snapshot.data![index].aptname,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }else{
          return const Center(
            child: Text('데이터 읎다'),
          );
        }
      },
    );
  }
}