import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttermainproject/model/price_data.dart';

class ChartGetX extends GetxController {
  RxList<PriceData> priceDataList = RxList<PriceData>([]);

  Future<void> getChartJSON(String address, String floor) async {
    var url = Uri.parse('http://192.168.0.7:8080/getPrice?address=$address&floor=$floor');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

    var results = dataConvertedJSON['results'];

    if(results == "EMPTY"){ // api에서 조회된 데이터가 없는 경우 쓰레기값 보여준다.
      priceDataList.add(PriceData("202108", 10000));
      priceDataList.add(PriceData("202307", 10000));
    }else{
      print(results);
      for (var resultObject in results) { // 월별 데이터 24번
        for (var entry in resultObject.entries) { // 한 월에 여러 데이터를 들고오기때문
          var yearMonth = entry.key;
          var dataArray = entry.value;
          
          double totalDeposit = 0.0;
          int dataCount = dataArray.length;
          
            for (var data in dataArray) {
              totalDeposit += data['보증금'];
            }
          
          int averageDeposit = (totalDeposit / dataCount).round();
          
          var priceData = PriceData(yearMonth, averageDeposit);
          priceDataList.add(priceData);
        }
}
    }
    

    //print(priceDataList.toString());

    //update();
  }
    void init(){
    priceDataList = RxList<PriceData>([]);
  }

}
