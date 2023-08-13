import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChartGetX extends GetxController {
  Rx<dynamic> result = Rx<dynamic>(null); // Rx 변수로 선언

  Future<void> getChartJSON(String address, String floor) async {
    var url = Uri.parse('https://localhost:8080/getPrice?address=$address&floor=$floor');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

    result.value = dataConvertedJSON['results']; // Rx 변수의 값을 업데이트
  }
}
