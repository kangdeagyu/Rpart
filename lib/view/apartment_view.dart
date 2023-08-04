import 'package:flutter/material.dart';
import 'package:fluttermainproject/widget/apartment_widget.dart';


class ApartmentView extends StatelessWidget {
  const ApartmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('d'),
        centerTitle: true,
        elevation: 0, // 앱 바 그림자 제거
      ),
      body: const ApartmentWidget()
    );
  }
}
