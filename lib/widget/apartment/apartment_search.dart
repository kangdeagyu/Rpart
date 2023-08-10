
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/search_sqlitedb.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ApartmentSearch extends StatelessWidget {
  final KakaoMapController? mapController;

  ApartmentSearch({super.key, required this.mapController});

  TextEditingController searchController = TextEditingController();

  List<String> searchList = [];
  List<String> xList = [];
  List<String> yList = [];
  DatabaseHandler handler = Get.put(DatabaseHandler());

  @override
  Widget build(BuildContext context) {
    return Positioned(
        // AppBar를 겹치도록 위치 조정
        top: MediaQuery.of(context).size.height / 14,
        left: MediaQuery.of(context).size.width / 15,
        right: MediaQuery.of(context).size.width / 15,
        child: Column(children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 12.0), // 텍스트필드 내부/여백을 변경
              // 검색버튼 눌렀을경우
              suffixIcon: IconButton(
                onPressed: () async {
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

                    // 사용자 검색을 통해 위치 변경
                    QuerySnapshot snapshot = await FirebaseFirestore.instance
                      .collection('apartment')
                      .where('단지명', isGreaterThanOrEqualTo: searchController.text.trim())
                      .get();

                    Set<String> uniqueRoadNames = Set();
                    searchList.clear();
                    xList.clear();
                    yList.clear();
                    int num = 0;
                    for(var doc in snapshot.docs){
                      if (!uniqueRoadNames.contains(doc['도로명']) && doc['단지명'].contains(searchController.text.trim())) {
                        uniqueRoadNames.add(doc['도로명']);
                        searchList.add(doc['단지명']);
                        xList.add(doc['경도']);
                        yList.add(doc['위도']);
                      }
                      num += 1;
                    }
                    
                    // ignore: use_build_context_synchronously
                    showModalBottomSheet(
  context: context,
  builder: (context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "검색 결과",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    mapController?.setCenter(
                      LatLng(double.parse(yList[index]), double.parse(xList[index])),
                    );
                    Navigator.pop(context); // 모달 닫기
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(searchList[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  },
);

                    
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
          GetBuilder<DatabaseHandler>(
            builder: (controller) {
              return FutureBuilder(
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
              );
            },
          ),
        ],
      ),
    );

  }
}

