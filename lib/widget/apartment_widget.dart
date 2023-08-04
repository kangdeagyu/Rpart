import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            // 화면 크기에 맞게 조절
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: KakaoMap(
              onMapCreated: ((controller){
                mapController = controller; 
      
                // 지도에 찍히는 마커 데이터
                markers.add(Marker(
                  markerId: UniqueKey().toString(),
                  // 여기다 마커 데이터 넣어줘
                  latLng: LatLng(37.493997700000, 127.031227700000),
                ));
          
                setState(() {});
              }),
              markers: markers.toList(),
              // 지도의 중심좌표
              center: LatLng(37.516211, 127.018593),
            ),
          ),
      ],
    );
  }
}