import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ApartmentChartBody extends StatelessWidget {
  const ApartmentChartBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
            children: [
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // 타이틀
                title: ChartTitle(text: '실 거래가 현황'),
                // 범례
                legend: const Legend(isVisible: false),
                // 데이터 입력
                series: <LineSeries<SalesData, String>>[
                  LineSeries<SalesData, String>(
                    dataSource:  <SalesData>[
                      SalesData('Jan', 35),
                      SalesData('Feb', 28),
                      SalesData('Mar', 34),
                      SalesData('Apr', 32),
                      SalesData('May', 40)
                    ],
                    // x, y 축
                    xValueMapper: (SalesData sales, _) => sales.year,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    // 그래프 값
                    dataLabelSettings: const DataLabelSettings(isVisible: true)
                  )
                ]
              )
            ],
          ),
        );
  }
}

// 실 거래가와 년도로 바꿔주면 될듯
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}