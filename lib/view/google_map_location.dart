import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapLocation extends StatefulWidget {
  const GoogleMapLocation({super.key});

  @override
  State<GoogleMapLocation> createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  Completer<GoogleMapController> _controller = Completer();

  void _handleMapTap(LatLng latLng) {
    double _latitude = latLng.latitude;
    double _longitude = latLng.longitude;
    print('Tapped Location - Latitude: $_latitude, Longitude: $_longitude');
    Get.back(result: [_latitude, _longitude]);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.50080871582031, 127.0368881225586),
    zoom: 14.4746,
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
