import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PredictionLease extends ChangeNotifier {
  String _result = "";

  String get result => _result;

  // ---- Functions ----
  predictLease(double busStations, double distance, double leaseableArea, double floor, double yoc, double contractDate, double baseRate) async {
    var url;
    if(leaseableArea < 33.06) {
      url = Uri.parse(
        'http://localhost:8080/Rserve/Under10PyeongLease.jsp?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate'
      );
    } else if(leaseableArea < 165.29) {
      url = Uri.parse(
        'http://localhost:8080/Rserve/Under10PyeongLease.jsp?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate'
      );
    } else {
      url = Uri.parse(
        'http://localhost:8080/Rserve/Under10PyeongLease.jsp?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate'
      );
    }
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    _result = dataConvertedJSON['result'];
    notifyListeners();
  }

}