import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermainproject/model/apartmentdata_firebase/apartment_fb.dart';
import 'package:fluttermainproject/view/google_map_location.dart';
import 'package:fluttermainproject/viewmodel/prediction_lease_provider.dart';
import 'package:fluttermainproject/viewmodel/prediction_sale_provider.dart';
import 'package:fluttermainproject/widget/apartment/prediction_lease_widget.dart';
import 'package:fluttermainproject/widget/apartment/prediction_sale_widget.dart';
import 'package:fluttermainproject/widget/table_calender_widget.dart';
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
  PredictionSale _sale = PredictionSale();
  double distanceValue = 0.0;
  double longitude = 0.0;
  double latitude = 0.0;
  int busCount = 0;
  String subwayName = "";
  var index = Get.arguments ?? "";
  String line = '';
  bool isSale = false;

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
    line = "";
    subwayName = "";
    isSale = false;
    if (index != null && index != "") {
      fetchApartmentData();
    }
    _lease.init();
    _sale.init();
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
        busCount = apartmentData.stationCount;
        busStationsController.text = busCount.toString();
        distanceValue = double.parse(apartmentData.subway).abs(); // 음수 값을 양수로 변환
        String formattedDistance = '${distanceValue.toStringAsFixed(2)}m'; // 소수점 둘째 자리까지 표시하도록 설정
        distanceController.text = formattedDistance;
        // distanceController.text = apartmentData.subway.toString();
        leaseableAreaController.text = apartmentData.extent.toString();
        floorController.text = apartmentData.floor.toString();
        yocController.text = apartmentData.year.toString();
        contractDateController.text = apartmentData.contract.toString();
        baseRateController.text = apartmentData.rate.toString();
        longitude = double.parse(apartmentData.x);
        latitude = double.parse(apartmentData.y);
        subwayName = apartmentData.subwayName;
        line = apartmentData.line;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PredictionLease _predictionLease =
        Provider.of<PredictionLease>(context);
    PredictionSale _predictionSale = Provider.of<PredictionSale>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Text(
            isSale ? "매매가" : "전세가"
          ),
          Switch(
            value: isSale,
            onChanged: (value) {
              isSale = value;
              setState(() {
                //
              });
            },
          )
        ],
      ),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Get.to(GoogleMapLocation(),
                                            arguments: [longitude, latitude])
                                        ?.then((value) {
                                      if (value != null &&
                                          value is List &&
                                          value.length >= 2) {
                                        longitude = value[0];
                                        latitude = value[1];
                                        busCount = value[2];
                                        busStationsController.text = busCount.toString();
                                        String strDistance = value[3].toString();
                                        distanceValue = double.parse(strDistance).abs(); // 음수 값을 양수로 변환
                                        String formattedDistance = '${distanceValue.toStringAsFixed(2)}m'; // 소수점 둘째 자리까지 표시하도록 설정
                                        distanceController.text = formattedDistance;
                                        subwayName = value[4];
                                        line = value[5];
                                        print(value[0]);
                                        print(value[1]);
                                        print("value3 = ${value[3]}");
                                      } else {
                                        // value가 올바르지 않은 경우 처리
                                      }
                                    });
                                  },
                                  child: const Text("위치 선택"),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: distanceController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "위치를 기반으로 계산된 가장 가까운 역과의 거리입니다.",
                              suffix: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    line == "1호선"
                                    ? "images/line1.png"
                                    : line == "2호선"
                                    ? "images/line2.png"
                                    : line == "3호선"
                                    ? "images/line3.png"
                                    : line == "4호선"
                                    ? "images/line4.png"
                                    : line == "4호선"
                                    ? "images/line4.png"
                                    : line == "5호선"
                                    ? "images/line5.png"
                                    : line == "6호선"
                                    ? "images/line6.png"
                                    : line == "7호선"
                                    ? "images/line7.png"
                                    : line == "8호선"
                                    ? "images/line8.png"
                                    : line == "9호선"
                                    ? "images/line9.png"
                                    : line == "분당선"
                                    ? "images/line_sin.png"
                                    : "images/line2.png"
                                    ,
                                    width: 15,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(subwayName ?? ""),
                                ],
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isSale ? 
                          TextField(
                            controller: leaseableAreaController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "전용면적(㎡)을 입력해주세요.",
                              suffix: Text("㎡"),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          )
                          : TextField(
                            controller: leaseableAreaController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "임대면적(㎡)을 입력해주세요.",
                              suffix: Text("㎡"),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: contractDateController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "계약일자를 선택해주세요.",
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  readOnly: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(CalenderDatePickerWidget(), arguments: contractDateController.text)?.then((value) {
                                      if (value != null) {
                                        String strValue = value.toString().substring(0,10);
                                        String formattedValue = strValue.replaceAll('-', ''); // 하이픈 제거
                                        contractDateController.text = formattedValue;
                                        double baseRate = 0.0; // 기본 금리 변수 초기화
                                        int contractDate = int.parse(formattedValue);
                                        if (contractDate >= 20230113) {
                                          baseRate = 3.5;
                                        } else if (contractDate >= 20221124) {
                                          baseRate = 3.25;
                                        } else if (contractDate >= 20221012) {
                                          baseRate = 3.0;
                                        } else if (contractDate >= 20220825) {
                                          baseRate = 2.5;
                                        } else if (contractDate >= 20220713) {
                                          baseRate = 2.25;
                                        } else if (contractDate >= 20220526) {
                                          baseRate = 1.75;
                                        } else if (contractDate >= 20220414) {
                                          baseRate = 1.5;
                                        } else if (contractDate >= 20220214) {
                                          baseRate = 1.25;
                                        } else if (contractDate >= 20220114) {
                                          baseRate = 1.25;
                                        } else if (contractDate >= 20211012) {
                                          baseRate = 1.0;
                                        } else if (contractDate >= 20210825) {
                                          baseRate = 0.75;
                                        } else if (contractDate >= 20200528) {
                                          baseRate = 0.5;
                                        } else if (contractDate >= 20200317) {
                                          baseRate = 0.75;
                                        } else if (contractDate >= 20191016) {
                                          baseRate = 1.25;
                                        } else if (contractDate >= 20190718) {
                                          baseRate = 1.5;
                                        } else if (contractDate >= 20181130) {
                                          baseRate = 1.75;
                                        } else if (contractDate >= 20171130) {
                                          baseRate = 1.5;
                                        } else if (contractDate >= 20160630) {
                                          baseRate = 1.25;
                                        } else if (contractDate >= 20150630) {
                                          baseRate = 1.5;
                                        } else if (contractDate >= 20150331) {
                                          baseRate = 1.75;
                                        } else if (contractDate >= 20141031) {
                                          baseRate = 2.0;
                                        } else if (contractDate >= 20140831) {
                                          baseRate = 2.25;
                                        } else if (contractDate >= 20130531) {
                                          baseRate = 2.5;
                                        } else if (contractDate >= 20121031) {
                                          baseRate = 2.75;
                                        } else{
                                          baseRate = 1.50;
                                        }
                                        baseRateController.text = baseRate.toString(); // 기본 금리 값을 텍스트 필드에 설정
                                        // setState(() {
                                        //   //
                                        // });
                                      }
                                    });
                                  },
                                  child: const Text("날짜선택"),
                                ),
                              ),
                            ],
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
                            readOnly: true,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if(busStationsController.text.trim().isEmpty
                            || distanceController.text.trim().isEmpty
                            || leaseableAreaController.text.trim().isEmpty
                            || floorController.text.trim().isEmpty
                            || yocController.text.trim().isEmpty
                            || contractDateController.text.trim().isEmpty
                            || baseRateController.text.trim().isEmpty
                            ) {
                              Get.snackbar(
                                'Error', // Title
                                '모든 데이터를 입력해주세요.',  // Content
                                snackPosition: SnackPosition.TOP, // Position
                                duration: const Duration(seconds: 2), // Duration
                                // backgroundColor: Colors.yellowAccent,
                                icon: const Icon(
                                  Icons.warning,
                                  color: Colors.red,
                                )
                              );
                            } else {
                              isSale ?
                              _predictionSale.predictSale(
                                double.parse(busStationsController.text),
                                -distanceValue,
                                double.parse(leaseableAreaController.text),
                                double.parse(floorController.text),
                                double.parse(yocController.text),
                                double.parse(contractDateController.text),
                                double.parse(baseRateController.text),
                                latitude,
                                longitude,
                              )
                              : _predictionLease.predictLease(
                                double.parse(busStationsController.text),
                                -distanceValue,
                                double.parse(leaseableAreaController.text),
                                double.parse(floorController.text),
                                double.parse(yocController.text),
                                double.parse(contractDateController.text),
                                double.parse(baseRateController.text),
                                latitude,
                                longitude,
                              );
                            }
                          },
                          child: const Text(
                            "분석",
                          ),
                        ),
                        isSale ? PredictionSaleWidget() : PredictionLeaseWidget(),
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
