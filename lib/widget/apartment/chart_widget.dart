import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_chart_test_app/model/price_data.dart';
import 'package:firebase_chart_test_app/viewmodel/chart_getx.dart';

class ChartWidget extends StatelessWidget {
  final String address;
  final String floor;

  const ChartWidget({required this.address, required this.floor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChartGetX controller = Get.put(ChartGetX());

    return GetBuilder<ChartGetX>(
      builder: (controller) {
        return Obx(() {
          if (controller.result.value == null) {
            // 데이터가 없는 경우 (빈 화면 또는 다른 처리)
            return CircularProgressIndicator();
          } else {
            // 비동기 작업이 완료되었을 때
            print("result : ${controller.result.value}");
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // 타이틀
              title: ChartTitle(text: '실 거래가 현황'),
              // 범례
              legend: const Legend(isVisible: false),
              // 데이터 입력
              series: <LineSeries<PriceData, String>>[
                LineSeries<PriceData, String>(
                  dataSource: controller.result.value,
                  // x, y 축
                  xValueMapper: (PriceData data, _) => data.yearMonth,
                  yValueMapper: (PriceData data, _) => data.price,
                  // 그래프 값
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            );
          }
        });
      },
    );
  }
}
