import 'package:flutter/material.dart';
import 'package:fluttermainproject/model/search/search_sqlitedb.dart';
import 'package:geolocator/geolocator.dart';
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
  DatabaseHandler handler = DatabaseHandler();
  
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
            height: MediaQuery.of(context).size.height / 1.08,
            width: MediaQuery.of(context).size.width,
            child: KakaoMap(
              mapTypeControl: true,
              mapTypeControlPosition: ControlPosition.bottomRight,
              onMapTap: (latLng) => FocusScope.of(context).unfocus(),
              
              // 마커를 클릭했을 때 호출
              onMarkerTap: (markerId, latLng, zoomLevel) {
                Get.defaultDialog(
                    title: latLng.latitude.toString(), //  y
                    middleText: latLng.longitude.toString(), //  x
                    backgroundColor: const Color.fromARGB(255, 252, 252, 246),
                    barrierDismissible: false,
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Exit'))
                    ]);
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
          // GPS
          Positioned(
            bottom: MediaQuery.of(context).size.height / 60,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white
              ),
              onPressed: () async{
                // 사용자 위치를 얻어옴
                Position? position = await getCurrentLocation();

                if (position != null) {
                  // 위치 정보를 이용하여 원하는 동작 수행
                  double latitude = position.latitude;
                  double longitude = position.longitude;
                  print("Latitude: $latitude, Longitude: $longitude");

                  // 해당 위치로 맵 이동
                  mapController.setCenter(LatLng(latitude, longitude));

                  // 여기서 필요한 로직을 추가하거나, 마커를 업데이트하거나 등의 작업을 수행할 수 있습니다.
                } else {
                  // 위치 권한이 거부된 경우
                  print("사용자가 위치 권한을 거부하였습니다.");
                }
              }, 
              icon: const Icon(
                Icons.gps_fixed
              ),
            ),
          ),
          // 검색
          Positioned(
            // AppBar를 겹치도록 위치 조정
            top: MediaQuery.of(context).size.height / 14,
            left: MediaQuery.of(context).size.width / 15,
            right: MediaQuery.of(context).size.width / 15,
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 12.0), // 텍스트필드 내부/여백을 변경
                    // 검색버튼 눌렀을경우
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (searchController.text.trim().isEmpty) {
                          Get.snackbar(
                            '검색오류',
                            '검색어를 입력해주세요',
                            snackPosition: SnackPosition.BOTTOM, // 스낵바 위치
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          );
                        } else {
                          // 최근 검색어 저장
                          handler.insertSearch(searchController.text.trim());
                          // 사용자 검색을 통해 위치 변경 해야됨 ******************************
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.search),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(
                        '최근 검색어',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                // 최근 검색어
                FutureBuilder(
                  future: handler.querySearch(),
                  builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 20,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => const SizedBox(width: 0), // 구분자 설정
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0 , 5, 20),
                              child: TextButton(
                                onPressed: () {
                                  searchController.text = snapshot.data![index].content;
                                  setState(() {});
                                },
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(Size.zero),
                                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  alignment: Alignment.center,
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        snapshot.data![index].content.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                        child: IconButton(
                                          onPressed: () {
                                            handler.deleteSearch(snapshot.data![index].seq!);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            size: 12,
                                          ),
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Text("");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 사용자 위치를 비동기적으로 얻어오는 함수
Future<Position?> getCurrentLocation() async {
  try {
    // 위치 권한을 확인하고, 권한이 있는 경우 사용자의 현재 위치를 얻어옴
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    // 사용자의 현재 위치를 얻어와서 반환
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  } catch (e) {
    return null;
  }
}

