import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/wishlist_sqlitedb.dart';
import 'package:get/get.dart';

class WishlistWidget extends StatefulWidget {
  WishlistWidget({Key? key}) : super(key: key);

  @override
  _WishlistWidgetState createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends State<WishlistWidget> {
  WishlistDatabaseHandler handler = Get.put(WishlistDatabaseHandler());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: handler.queryWishList(),
      builder: (context, snapshot) {
        if (snapshot.data == null || (snapshot.data as List).isEmpty) {
          // 데이터가 비어있거나 null인 경우 또는 에러가 발생한 경우
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/marker.png'),
                const Text('찜 아파트가 없습니다.'),
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: (snapshot.data as List).length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete_forever),
                  ),
                  key: ValueKey(index),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await Get.defaultDialog(
                        title: '삭제',
                        middleText: '정말 삭제하시겠습니까?',
                        onCancel: () => Get.back(),
                        onConfirm: () async {
                          // sql 삭제
                          await handler.deleteWishList(snapshot.data![index].aptname);
                          Get.back();

                          // 다시 데이터를 가져와서 리빌드
                          setState(() {
                            // Empty setState to trigger rebuild
                          });

                          Get.snackbar('찜 목록', '찜목록이 삭제 되었습니다.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
                        },
                      );
                    }
                  },
                  child: Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                        child: Text(
                          snapshot.data![index].aptname,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
