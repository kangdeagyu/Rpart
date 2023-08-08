import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.50080871582031, 127.0368881225586),
    zoom: 14.4746,
  );

  static final CameraPosition _myLocation = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(37.50080871582031, 127.0368881225586),
      // tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Marker> _marker = [];
  List<Marker> _list = [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.50080871582031, 127.0368881225586),
      infoWindow: InfoWindow(
        title: "Test",
      ),
      onTap: () {
        print('Marker Clicked!');
      },
    ),
  ];

  void _handleMapTap(LatLng latLng) {
    double latitude = latLng.latitude;
    double longitude = latLng.longitude;
    print('Tapped Location - Latitude: $latitude, Longitude: $longitude');
  }

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onCameraMove: (_) {},
        markers: Set<Marker>.of(_marker),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationButtonEnabled: false,
        onTap: _handleMapTap,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMyLocacition,
        label: SizedBox.shrink(), // 라벨 텍스트 공백 처리
        icon: Icon(Icons.gps_fixed),
        backgroundColor: Colors.white, // 배경 색상 설정
      ),
    );
  }

  Future<void> _goToMyLocacition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myLocation));
  }
} // End
