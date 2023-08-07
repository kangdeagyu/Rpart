import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/wishlist_sqlitedb.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ApartmentChart extends StatefulWidget {
  const ApartmentChart({super.key});

  @override
  State<ApartmentChart> createState() => _ApartmentChartState();
}

class _ApartmentChartState extends State<ApartmentChart> {
  WishlistDatabaseHandler handler = WishlistDatabaseHandler();
  late bool result;

  @override
  void initState() {
    super.initState();
    result = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:  MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("땡땡아파트"),
          actions: [
            FutureBuilder(
              future: handler.queryWishListstar("아파트"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return IconButton(
                    onPressed: () {
                      // 불러온 아파트 sqlite로 저장
                      handler.insertWishList("땡땡아파트");
                      Get.snackbar(
                        'WishList', 
                        'WishList에 추가 되었습니다.',
                        snackPosition: SnackPosition.BOTTOM,  // 스낵바 위치
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.yellowAccent,
                      );
                      setState(() {
                        
                      });
                    }, 
                    icon: const Icon(
                      Icons.star,
                      color:Colors.yellow,
                    ),
                  );
                }else{
                  return IconButton(
                    // 불러온 아파트 sqlite로 삭제
                    onPressed: () {
                      handler.deleteWishList("땡땡아파트");
                      Get.snackbar(
                        'WishList', 
                        'WishList가 취소 되었습니다.',
                        snackPosition: SnackPosition.BOTTOM,  // 스낵바 위치
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.yellowAccent,
                      );
                      setState(() {
                        
                      });
                    }, 
                    icon: const Icon(
                      Icons.star_border,
                    ),
                  );
                }
              }
            )
          ],
        ),
        body: Center(
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
        ),
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