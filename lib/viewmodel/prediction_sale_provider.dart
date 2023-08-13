import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictionSale extends ChangeNotifier {
  String _rdsResult = "";

  String get rdsResult => _rdsResult;

  // ---- Functions ----
  predictSale(double busStations, double distance, double saleArea, double floor, double yoc, double contractDate, double baseRate, double x, double y) async {
    var rdsUrl;
    var predictUrl;
    if(saleArea < 33.06) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_under10'
      );
    } else if(saleArea < 66.12) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_10'
      );
    } else if(saleArea < 99.17) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_20'
      );
    } else if(saleArea < 132.23) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_30'
      );
    } else if(saleArea < 165.29) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_10_40_except30'
      );
    } else {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_over50'
      );
    }
    var rdsResponse = await http.get(rdsUrl);
    print(rdsUrl);
    var rdsConvertedJSON = json.decode(utf8.decode(rdsResponse.bodyBytes));
    _rdsResult = rdsConvertedJSON['result'];

    notifyListeners();
  }

  init() {
    print("초기화 실행");
    _rdsResult = "";
    notifyListeners();
  }

}