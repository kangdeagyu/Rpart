import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/wishlist_sqlitedb.dart';

class WishlistWidget extends StatelessWidget {
  WishlistDatabaseHandler handler = WishlistDatabaseHandler();

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
              return Card(
                child: Text(
                  snapshot.data![index].aptname
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