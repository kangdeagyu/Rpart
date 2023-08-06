import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ApartmentChart extends StatelessWidget {
  const ApartmentChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:  MediaQuery.of(context).size.height * 0.8,
      child: Center(
        child: Column(
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // 타이틀
              title: ChartTitle(text: '실 거래가 현황'),
              // 범례
              legend: const Legend(isVisible: true),

              
              )
            // Text(latLng.latitude.toString()),
            // Text(latLng.longitude.toString()),
          ],
        ),
      ),
    );
  }
}