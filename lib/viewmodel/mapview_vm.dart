import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapMarkerView extends GetxController{
  KakaoMapController? mapController; // Map 컨트롤러

  Set<Marker> markers = {}; // 마커 초기화

  void initializeMarkers() {
    // Map 컨트롤러가 준비되면 호출되는 함수로, 마커를 초기화하고 추가할 수 있음
    markers.add(
      Marker(
        markerId: UniqueKey().toString(),
        latLng: LatLng(37.497961, 127.027635),
        infoWindowContent: '안녕',
      ),
    );

    update();
  }

    // 사용자 위치 세팅
  void setCenter(LatLng latLng) {
    if (mapController != null) {
      mapController!.setCenter(latLng);
    }
  }

}