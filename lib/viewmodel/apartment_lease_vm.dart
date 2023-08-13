import 'dart:convert';

import 'package:http/http.dart' as http;

class ApartmentLease{
  String rdsResult = "";

  // ---- Functions ----
  Future<String> predictLease(double busStations, double distance, double leaseableArea, double floor, double yoc, double contractDate, double baseRate, double x, double y) async {
    var rdsUrl;
    if(leaseableArea < 33.06) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=under10'
      );
    } else if(leaseableArea < 66.12) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=around10'
      );
    } else if(leaseableArea < 99.17) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=around20'
      );
    } else if(leaseableArea < 132.23) {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=around30'
      );
    } else  {
      rdsUrl = Uri.parse(
        'http://localhost:8080/rdsRServe?busStations=$busStations&distance=$distance&leaseableArea=$leaseableArea&floor=$floor&yoc=$yoc&contractDate=$contractDate&baseRate=$baseRate&x=$x&y=$y&size=around40'
      );
    }
    var rdsResponse = await http.get(rdsUrl);
    //print(rdsUrl);
    var rdsConvertedJSON = json.decode(utf8.decode(rdsResponse.bodyBytes));
    rdsResult = rdsConvertedJSON['result'];

   return rdsResult;
  }

}