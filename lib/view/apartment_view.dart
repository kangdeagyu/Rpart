import 'package:flutter/material.dart';
import 'package:fluttermainproject/widget/apartment/apartment_widget_map.dart';


class ApartmentView extends StatelessWidget {
  const ApartmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ApartmentWidgetMap()
    );
  }
}
