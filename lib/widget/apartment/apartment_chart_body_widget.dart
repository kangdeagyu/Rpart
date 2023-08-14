import 'package:flutter/material.dart';
import 'package:fluttermainproject/widget/apartment/chart_widget.dart';

class ApartmentChartBody extends StatelessWidget {
  final String address;
  final String floor;
  const ApartmentChartBody({super.key, required this.address, required this.floor});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
            children: [
              ChartWidget(address: address, floor: floor),
            ],
          ),
        );
  }
}

