import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/prediction_lease_provider.dart';
import 'package:fluttermainproject/widget/apartment/prediction_lease_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PredictionLeaseView extends StatelessWidget {
  const PredictionLeaseView({super.key});

  

  @override
  Widget build(BuildContext context) {

    PredictionLease _predictionLease = Provider.of<PredictionLease>(context, listen: false);
    TextEditingController busStationsController = TextEditingController();
    TextEditingController distanceController = TextEditingController();
    TextEditingController leaseableAreaController = TextEditingController();
    TextEditingController floorController = TextEditingController();
    TextEditingController yocController = TextEditingController();
    TextEditingController contractDateController = TextEditingController();
    TextEditingController baseRateController = TextEditingController();
    

    return Scaffold(
      appBar: AppBar(
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: busStationsController,
                    decoration: const InputDecoration(
                      labelText: "주변 버스정류장 개수를 입력하세요.",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: distanceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "주변 지하철과의 거리를 입력하세요.",
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _predictionLease.predictLease(double.parse(busStationsController.text), double.parse(distanceController.text),double.parse(leaseableAreaController.text), double.parse(floorController.text), double.parse(yocController.text), double.parse(contractDateController.text), double.parse(baseRateController.text));
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
  }


} // End