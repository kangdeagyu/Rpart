import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermainproject/model/apartmentdata_firebase/apartment_fb.dart';
import 'package:fluttermainproject/model/obs/apartmentcontroller.dart';
import 'package:fluttermainproject/view/prediction_lease_view.dart';
import 'package:fluttermainproject/viewmodel/prediction_lease_provider.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  PredictionLease _predictionLease = PredictionLease();
  Completer<GoogleMapController> _controller = Completer();
  final apartmentController = Get.put(ApartmentControllerObs());
  

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

  void _handleMapTap(LatLng latLng) {
    double latitude = latLng.latitude;
    double longitude = latLng.longitude;
    print('Tapped Location - Latitude: $latitude, Longitude: $longitude');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.08,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('apartment')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              _marker.clear();
              Set<String> uniqueRoadNames = Set();

              for (var doc in snapshot.data!.docs) {
                var apartmentData = ApartmentFB(
                    year: doc['건축년도'],
                    x: doc['경도'],
                    contract: doc['계약시점'],
                    rate: doc['계약시점기준금리'],
                    apartmentName: doc['단지명'],
                    rodeName: doc['도로명'],
                    streetAddress: doc['번지'],
                    deposit: doc['보증금'],
                    y: doc['위도'],
                    extent: doc['임대면적'],
                    station: doc['정류장이름'],
                    stationCount: doc['주변정류장개수'],
                    subway: doc['역거리'],
                    subwayName: doc['역이름'],
                    floor: doc['층'],
                    line: doc['호선'],
                    id: doc.id);

                // 중복되지 않은 도로명만 처리
                if (!uniqueRoadNames.contains(apartmentData.rodeName)) {
                  uniqueRoadNames.add(apartmentData.rodeName);

                  _marker.add(
                    Marker(
                      markerId: MarkerId(apartmentData.id),
                      position: LatLng(double.parse(apartmentData.y),
                          double.parse(apartmentData.x)),
                      // width: 20,
                      // height: 50,
                      infoWindow: InfoWindow(
                        title: apartmentData.apartmentName,
                        onTap: () {
                          goToPredictPage(apartmentData.id);
                        },
                      ),
                    ),
                  );
                }
              }
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onCameraMove: (_) {},
                markers: Set<Marker>.of(_marker),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: _handleMapTap,
              );
            },
          ),
        )
      ],
    );
  }

  Future<void> _goToMyLocacition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myLocation));
  }

  goToPredictPage(String index) {
    _predictionLease.init();
    Get.to(PredictionLeaseView(), arguments: index);
  }
} // End
