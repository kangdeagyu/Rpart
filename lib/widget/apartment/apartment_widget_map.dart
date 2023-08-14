
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermainproject/model/apartmentdata_firebase/apartment_fb.dart';
import 'package:fluttermainproject/model/obs/apartmentcontroller.dart';
import 'package:fluttermainproject/viewmodel/apartment_lease_vm.dart';
import 'package:fluttermainproject/viewmodel/mapgps_vm.dart';
import 'package:fluttermainproject/widget/apartment/apartment_chart_appbar_widget.dart';
import 'package:fluttermainproject/widget/apartment/apartment_search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ApartmentWidgetMap extends StatefulWidget {
  
  const ApartmentWidgetMap({super.key});

  @override
  State<ApartmentWidgetMap> createState() => _ApartmentWidgetMapState();
}

class _ApartmentWidgetMapState extends State<ApartmentWidgetMap> {
  // 맵 생성 callback
  KakaoMapController? mapController;
  // 마커 초기화
  final List<Marker> markers = []; 
  // 예측값
  List lease = [];
  // markersid
  int num = 0;

  ApartmentLease _apartmentLease = ApartmentLease();
  
  MapGPS gps = Get.put(MapGPS());

  final apartmentController = Get.put(ApartmentControllerObs());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(
      children: [
        SizedBox(
          // 화면 크기에 맞게 조절
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
              
              markers.clear();
              //lease.clear();
              num = 0;
              Set<String> uniqueRoadNames = Set();

              // 예측값 불러오기
              Future<List> fetchLeasePrediction(ApartmentFB apartmentData) async {
                double doubleRate = apartmentData.rate.toDouble();
                double doubleExtent = apartmentData.extent.toDouble();
                String prediction = await _apartmentLease.predictLease(
                  double.parse(apartmentData.stationCount.toString()),
                  -double.parse(apartmentData.subway),
                  doubleExtent,
                  double.parse(apartmentData.floor.toString()),
                  double.parse(apartmentData.year.toString()),
                  double.parse(apartmentData.contract),
                  doubleRate,
                  double.parse(apartmentData.x),
                  double.parse(apartmentData.y),
                );
                lease.add(prediction);
                return lease;
              }

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
                    id: doc.id
                  );
              
              // 중복되지 않은 도로명만 처리
              if (!uniqueRoadNames.contains(apartmentData.rodeName)) {
                uniqueRoadNames.add(apartmentData.rodeName);
                // 분석 데이터 가져오기
                fetchLeasePrediction(apartmentData);
                print(1);
                markers.add(
                  Marker(
                    latLng: LatLng(double.parse(apartmentData.y), double.parse(apartmentData.x)),
                    width: 20,
                    height: 50,
                    infoWindowContent: apartmentData.apartmentName,
                    infoWindowRemovable: false,
                    infoWindowFirstShow: false,
                    markerId: num.toString(),
                  ),
                );
                num++;
              }
              
             }

              return KakaoMap(
                mapTypeControl: true,
                mapTypeControlPosition: ControlPosition.bottomRight,
                zoomControl: true,
                zoomControlPosition: ControlPosition.bottomLeft,
                onMapTap: (latLng) => FocusScope.of(context).unfocus(),
                customOverlays: markers.map((marker) {
                  return CustomOverlay(
                    customOverlayId: marker.markerId, 
                    latLng: LatLng(marker.latLng.latitude, marker.latLng.longitude), 
                    content: '<div class="message-box" style="background-color: white; border: 1px solid #ccc; padding: 10px; border-radius: 5px; position: relative;">' +
                      '<div class="box-title">${marker.infoWindowContent}</div>' +
                      '<div class="box-content">${lease.isNotEmpty ? lease[int.parse(marker.markerId)] != "R Error" ? lease[int.parse(marker.markerId)] : '' : null}</div>' +
                      '<div class="arrow-down"></div>' +
                    '</div>' +
                    '<style>' +
                        '.arrow-down { ' +
                        'position: absolute;' +
                        'width: 0;' +
                        'height: 0;' +
                        'left: 50%;' +
                        'bottom: -10px;' +
                        'transform: translateX(-50%);' +
                        'border-left: 10px solid transparent;' +
                        'border-right: 10px solid transparent;' +
                        'border-top: 10px solid #ccc;' + /* 화살표 색상 조정 가능 */
                      '}' +
                    '</style>',
                      );
                  }).toList(),
                
                // 마커를 클릭했을 때 호출
                onMarkerTap: (markerId, latLng, zoomLevel) {
                  // 선택된 마커의 infoWindowContent 값을 가져옴
                  String apartmentName = markers
                      .firstWhere((marker) => marker.markerId == markerId)
                      .infoWindowContent;

                  // Getx로 데이터를 보냅니다.
                  apartmentController.setApartmentName(apartmentName); 

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return ApartmentChartWidget();
                    },
                  );
                },
                onMapCreated: ((controller) {
                  mapController = controller;
                  
                  // 지도에 찍히는 마커 데이터
                  setState(() {
                    
                  });
                }),
                markers: markers,
                // 지도의 중심좌표
                center: LatLng(37.5007, 127.0368),
              );
            }),
          ),
        // GPS
          Positioned(
            bottom: MediaQuery.of(context).size.height / 4,
            child: IconButton(
              color: Colors.white,
              style: IconButton.styleFrom(backgroundColor: Colors.indigoAccent),
              onPressed: () async {
                // 사용자 위치를 얻어옴
                Position? position = await gps.getCurrentLocation();
                if (position != null) {
                  // 위치 정보를 이용하여 원하는 동작 수행
                  double latitude = position.latitude;
                  double longitude = position.longitude;
                  // 해당 위치로 맵 이동
                  // List<Marker> nawhere = [];
                  // nawhere.add(Marker(markerId: 'na', latLng: LatLng(latitude, longitude)));
                  // mapController?.addMarker(markers: nawhere);
                  mapController?.setCenter(LatLng(latitude, longitude));
                } else {
                  // 위치 권한이 거부된 경우
                }
              },
              icon: const Icon(Icons.gps_fixed),
            ),
          ),
          // 검색창, 최근검색어
          ApartmentSearch(mapController: mapController),
          
        ],
      ));
  }
}


