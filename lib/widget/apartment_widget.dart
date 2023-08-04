import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ApartmentWidget extends StatefulWidget {
  const ApartmentWidget({super.key});

  @override
  State<ApartmentWidget> createState() => _ApartmentWidgetState();
}

class _ApartmentWidgetState extends State<ApartmentWidget> {
  Set<Marker> markers = {}; // 마커 변수
  // 맵 생성 callback
  late KakaoMapController mapController;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        // Stack으로 앱 바와 본문 이미지 겹치도록 설정
        children: [
          SizedBox(
            // 화면 크기에 맞게 조절
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: KakaoMap(
              mapTypeControl: true,
              onMapTap: (latLng) => FocusScope.of(context).unfocus(),
              // 마커를 클릭했을 때 호출
              onMarkerTap: (markerId, latLng, zoomLevel) {
                  // print('Marker ID: $markerId');
                  // print('Latitude: ${latLng.latitude}');  // y
                  // print('Longitude: ${latLng.longitude}');// x
                  // print('Zoom Level: $zoomLevel');
                Get.defaultDialog(
                  title: latLng.latitude.toString(),       //  y
                  middleText: latLng.longitude.toString(),  //  x
                  backgroundColor: const Color.fromARGB(255, 252, 252, 246),
                  barrierDismissible: false,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      }, 
                      child: const Text('Exit'))
                  ]
                );
              },
              onMapCreated: ((controller) {
                mapController = controller;
                // 지도에 찍히는 마커 데이터
                markers.add(Marker(
                  markerId: UniqueKey().toString(),
                  // 여기다 마커 데이터(y,x)
                  latLng: LatLng(37.493997700000, 127.031227700000),
                ));
            
                setState(() {});
              }),
              markers: markers.toList(),
              // 지도의 중심좌표
              center: LatLng(37.516211, 127.018593),
              
            ),
          ),
          // 검색
          Positioned(
            // AppBar를 겹치도록 위치 조정
            top: MediaQuery.of(context).size.height/14,
            left: MediaQuery.of(context).size.width/15,
            right: MediaQuery.of(context).size.width/15,
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 5.0),  // 텍스트필드 내부/여백을 변경
                // 버튼으로 변경해줘야됨
                suffixIcon: Icon(
                  Icons.search 
                ),
                filled: true,
                fillColor: Colors.white,
              ), 
            ),
          ),
        ],
      ),
    );
  }
}

