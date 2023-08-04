import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ApartmentView extends StatelessWidget {
  const ApartmentView({super.key});

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {}; // 마커 변수
    // 맵 생성 callback
    KakaoMapController mapController;

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: KakaoMap(
          onMapCreated: ((controller) async {
            mapController = controller;
      
            markers.add(Marker(
              markerId: UniqueKey().toString(),
              latLng: await mapController.getCenter(),
            ));
      
            //setState(() {});
          }),
          markers: markers.toList(),
          center: LatLng(37.3608681, 126.9306506),
        ),
      ),
    );
  }
}
