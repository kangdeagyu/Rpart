import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermainproject/model/apartmentdata_firebase/apartment_fb.dart';
import 'package:fluttermainproject/view/google_map_location.dart';
import 'package:fluttermainproject/viewmodel/prediction_lease_provider.dart';
import 'package:fluttermainproject/widget/apartment/prediction_lease_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PredictionLeaseView extends StatefulWidget {
  const PredictionLeaseView({super.key});

  @override
  _PredictionLeaseViewState createState() => _PredictionLeaseViewState();
}

class _PredictionLeaseViewState extends State<PredictionLeaseView> {
  TextEditingController busStationsController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController leaseableAreaController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController yocController = TextEditingController();
  TextEditingController contractDateController = TextEditingController();
  TextEditingController baseRateController = TextEditingController();
  PredictionLease _lease = PredictionLease();
  double longitude = 0.0;
  double latitude = 0.0;
  var index = Get.arguments ?? "";

  @override
  void initState() {
    super.initState();
    busStationsController.text = "";
    distanceController.text = "";
    leaseableAreaController.text = "";
    floorController.text = "";
    yocController.text = "";
    contractDateController.text = "";
    baseRateController.text = "";
    if (index != null && index != "") {
      fetchApartmentData();
    }
    _lease.init();
  }

  void fetchApartmentData() {
    FirebaseFirestore.instance
        .collection('apartment')
        .doc(index.toString())
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var doc = snapshot.data() as Map<String, dynamic>;
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
          id: snapshot.id,
        );
        busStationsController.text = apartmentData.stationCount.toString();
        distanceController.text = apartmentData.subway.toString();
        leaseableAreaController.text = apartmentData.extent.toString();
        floorController.text = apartmentData.floor.toString();
        yocController.text = apartmentData.year.toString();
        contractDateController.text = apartmentData.contract.toString();
        baseRateController.text = apartmentData.rate.toString();
        longitude = double.parse(apartmentData.x);
        latitude = double.parse(apartmentData.y);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PredictionLease _predictionLease =
        Provider.of<PredictionLease>(context);

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('apartment')
            .doc(index.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.exists) {
            var doc = snapshot.data!.data() as Map<String, dynamic>;
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
              id: snapshot.data!.id,
            );

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: busStationsController,
                                  decoration: const InputDecoration(
                                    labelText: "위치를 기반으로 계산된 주변 정거장 개수입니다.",
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(GoogleMapLocation(),
                                          arguments: [longitude, latitude])
                                      ?.then((value) {
                                    if (value != null &&
                                        value is List &&
                                        value.length >= 2) {
                                      longitude = value[0];
                                      latitude = value[1];
                                      print(value[0]);
                                      print(value[1]);
                                    } else {
                                      // value가 올바르지 않은 경우 처리
                                    }
                                  });
                                },
                                child: const Text("위치 선택"),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: distanceController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "위치를 기반으로 계산된 가장 가까운 역과의 거리입니다.",
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: leaseableAreaController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "임대면적을 입력해주세요.",
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: floorController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "입주하실 층을 입력해주세요.",
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: yocController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "해당 건물의 건축년도를 입력해주세요.",
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: contractDateController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "계약일자를 선택해주세요.",
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: baseRateController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "기준금리는 계약일을 선택하면 자동으로 계산됩니다.",
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _predictionLease.predictLease(
                              double.parse(busStationsController.text),
                              double.parse(distanceController.text),
                              double.parse(leaseableAreaController.text),
                              double.parse(floorController.text),
                              double.parse(yocController.text),
                              double.parse(contractDateController.text),
                              double.parse(baseRateController.text),
                              longitude,
                              latitude,
                            );
                          },
                          child: const Text(
                            "분석",
                          ),
                        ),
                        PredictionLeaseWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text("Document doesn't exist"),
            );
          }
        },
      ),
    );
  }
}
