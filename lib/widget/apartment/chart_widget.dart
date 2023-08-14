import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/chart_getx.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fluttermainproject/model/price_data.dart';

class ChartWidget extends StatelessWidget {
  final String address;
  final String floor;

  const ChartWidget(
    {required this.address, 
    required this.floor, 
    Key? key
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChartGetX controller = Get.put(ChartGetX());
    controller.init();

    return GetBuilder<ChartGetX>(
      builder: (controller) {
        // print(address);
        // print(floor);
        controller.getChartJSON(address, floor);
        return Obx(() {
          if (controller.priceDataList.value == null) {
            // 데이터가 없는 경우
            return const CircularProgressIndicator();
          } else {
            // 비동기 작업 완료
            // print("result : ${controller.priceDataList.value}");
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // 타이틀
              title: ChartTitle(text: '최근 2년 매매 거래가격 현황'),
              // 범례
              legend: const Legend(isVisible: false),
              // 데이터 입력
              series: <LineSeries<PriceData, String>>[
                LineSeries<PriceData, String>(
                    //dataSource: controller.priceDataList,
                    dataSource: controller.priceDataList,
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
