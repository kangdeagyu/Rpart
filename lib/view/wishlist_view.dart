import 'package:flutter/material.dart';
import 'package:fluttermainproject/widget/wishlist_widget.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WishList'),
      ),
      body: WishlistWidget(),
    );
  }
}