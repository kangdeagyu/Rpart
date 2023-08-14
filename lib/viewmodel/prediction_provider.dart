import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Prediction extends ChangeNotifier {
  String _rdsResult = "";
  String _predictResult = "";

  String get rdsResult => _rdsResult;
  String get predictResult => _predictResult;

  // ---- Functions ----
  predictLease(double busStations, double distance, double leaseableArea, double floor, double yoc, double contractDate, double baseRate, double x, double y) async {
    var rdsUrl;
    var predictUrl;
    if(leaseableArea < 33.06) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=under10&isSale=0'
      );
      predictUrl = Uri.parse(
        'http://localhost:8080/predictLease?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&model=under10'
      );
    } else if(leaseableArea < 66.12) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=around10&isSale=0'
      );
      predictUrl = Uri.parse(
        'http://localhost:8080/predictLease?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&model=around10'
      );
    } else if(leaseableArea < 99.17) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=around20&isSale=0'
      );
      predictUrl = Uri.parse(
        'http://localhost:8080/predictLease?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&model=around20'
      );
    } else if(leaseableArea < 132.23) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=around30&isSale=0'
      );
      predictUrl = Uri.parse(
        'http://localhost:8080/predictLease?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&model=around30'
      );
    } else  {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=around40&isSale=0'
      );
      predictUrl = Uri.parse(
        'http://localhost:8080/predictLease?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&model=around40'
      );
    }
    var rdsResponse = await http.get(rdsUrl);
    print(rdsUrl);
    var rdsConvertedJSON = json.decode(utf8.decode(rdsResponse.bodyBytes));
    _rdsResult = rdsConvertedJSON['result'];

    var predictResponse = await http.get(predictUrl);
    print(predictUrl);
    var predictConvertedJSON = json.decode(utf8.decode(predictResponse.bodyBytes));
    _predictResult = predictConvertedJSON['result'];

    notifyListeners();
  }

  predictSale(double busStations, double distance, double saleArea, double floor, double yoc, double contractDate, double baseRate, double x, double y) async {
    var rdsUrl;
    
    if(saleArea < 33.06) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_under10&isSale=1'
      );
    } else if(saleArea < 66.12) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_10&isSale=1'
      );
    } else if(saleArea < 99.17) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_20&isSale=1'
      );
    } else if(saleArea < 132.23) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_30&isSale=1'
      );
    } else if(saleArea < 165.29) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_10_40_except30&isSale=1'
      );
    } else {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&saleArea=$saleArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&size=sale_over50&isSale=1'
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
    _predictResult = "";
    notifyListeners();
  }

}