import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/mapgps_vm.dart';
import 'package:fluttermainproject/viewmodel/mapview_vm.dart';
import 'package:fluttermainproject/widget/apartment/apartment_chart_widget.dart';
import 'package:fluttermainproject/widget/apartment/apartment_search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ApartmentWidgetMap extends StatelessWidget {
  // 맵 생성 callback
  MapGPS gps = Get.put(MapGPS());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<MapMarkerView>(
          init: MapMarkerView(),
          builder: (mapController) {
            // Stack으로 앱 바와 본문 이미지 겹치도록 설정
            return Stack(
              children: [
                SizedBox(
                  // 화면 크기에 맞게 조절
                  height: MediaQuery.of(context).size.height / 1.08,
                  width: MediaQuery.of(context).size.width,
                  child: KakaoMap(
                    mapTypeControl: true,
                    mapTypeControlPosition: ControlPosition.bottomRight,
                    onMapTap: (latLng) => FocusScope.of(context).unfocus(),

                    // 마커를 클릭했을 때 호출
                    onMarkerTap: (markerId, latLng, zoomLevel) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return const ApartmentChart();
                        },
                      );
                    },
                    onMapCreated: ((controller) {
                      mapController.mapController = controller;
                      // 지도에 찍히는 마커 데이터
                      mapController.initializeMarkers();
                    }),
                    markers: mapController.markers.toList(),
                    // 지도의 중심좌표
                    center: LatLng(37.493997700000,127031227700000),
                  ),
                ),
                // GPS
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 60,
                  child: IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () async {
                      // 사용자 위치를 얻어옴
                      Position? position = await gps.getCurrentLocation();

                      if (position != null) {
                        // 위치 정보를 이용하여 원하는 동작 수행
                        double latitude = position.latitude;
                        double longitude = position.longitude;

                        // 해당 위치로 맵 이동
                        mapController.setCenter(LatLng(latitude,longitude));
                        // 여기서 필요한 로직을 추가하거나, 마커를 업데이트하거나 등의 작업을 수행할 수 있습니다.
                      } else {
                        // 위치 권한이 거부된 경우
                      }
                    },
                    icon: const Icon(Icons.gps_fixed),
                  ),
                ),
                // 검색창, 최근검색어
                ApartmentSearch(),
              ],
            );
          }),
    );
  }
}
