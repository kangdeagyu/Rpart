import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapLocation extends StatefulWidget {
  const GoogleMapLocation({super.key});

  @override
  State<GoogleMapLocation> createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  Completer<GoogleMapController> _controller = Completer();

  _handleMapTap(LatLng latLng) async {
    double _latitude = latLng.latitude;
    double _longitude = latLng.longitude;
    // print('Tapped Location - Latitude: $_latitude, Longitude: $_longitude');
    // 정류장 개수 가져오기
    var busCountUrl = Uri.parse("http://localhost:8080/busCount?xVal=$_longitude&yVal=$_latitude");
    var busRes = await http.get(busCountUrl);
    var busJson = json.decode(utf8.decode(busRes.bodyBytes));
    int busCount = busJson['result'].toInt(); // 부동 소수점 숫자를 int로 변환
    // print("busCount = " + busCount.toString());
    
    // 역과의 거리 가져오기
    var distanceUrl = Uri.parse("http://localhost:8080/ShortestStation?xVal=$_longitude&yVal=$_latitude");
    var distanceRes = await http.get(distanceUrl);
    var distanceJson = json.decode(utf8.decode(distanceRes.bodyBytes));
    var distance = distanceJson['distance'];
    String station = distanceJson['station'];
    String line = distanceJson['line'];
    // print("distance = $distance");
    // print("station = " + station);
    // print("line = " + line);

    Get.back(result: [_latitude, _longitude, busCount, distance, station, line]);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.50080871582031, 127.0368881225586),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    var value = Get.arguments;

    CameraPosition _myLocation = CameraPosition(
        target: LatLng(value[0], value[1]), zoom: 19.151926040649414);

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onCameraMove: (_) {},
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      onTap: _handleMapTap,
    );
  }
}
