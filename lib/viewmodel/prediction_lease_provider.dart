import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PredictionLease extends ChangeNotifier {
  String _result = "";

  String get result => _result;

  // ---- Functions ----
  predictLease(double busStations, double distance, double leaseableArea, double floor, double yoc, double contractDate, double baseRate, double x, double y) async {
    var url;
    if(leaseableArea < 33.06) {
      url = Uri.parse(
        'http://localhost:8080/Rserve/Under10Lease.jsp?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y'
      );
    } else if(leaseableArea < 66.12) {
      url = Uri.parse(
        'http://localhost:8080/Rserve/Around10Lease.jsp?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y'
      );
    } else if(leaseableArea < 99.17) {
      url = Uri.parse(
        'http://localhost:8080/Rserve/Around20Lease.jsp?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y'
      );
    } else if(leaseableArea < 132.23) {
      url = Uri.parse(
        'http://localhost:8080/Rserve/Around30Lease.jsp?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y'
      );
    } else  {
      url = Uri.parse(
        'http://localhost:8080/Rserve/Around40Lease.jsp?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y'
      );
    }
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    _result = dataConvertedJSON['result'];
    notifyListeners();
  }

  init() {
    print("초기화 실행");
    _result = "";
    notifyListeners();
  }

}