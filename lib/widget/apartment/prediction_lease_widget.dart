import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/prediction_lease_provider.dart';
import 'package:provider/provider.dart';

class PredictionLeaseWidget extends StatelessWidget {
  const PredictionLeaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<PredictionLease>(
        builder: (context, value, child) {
          return Column(
            children: [
              Text(
                value.rdsResult == ""
                ? ""
                : "머신 러닝을 통해 예측된 카테고리 = ${value.rdsResult} \n"
                  "분석을 통해 예측된 값 = ${value.predictResult}"
              ),
            ],
          );
        },),
    );
  }
}