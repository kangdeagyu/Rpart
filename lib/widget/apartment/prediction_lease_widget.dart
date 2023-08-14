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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              value.rdsResult.isNotEmpty
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "입력된 데이터를 기반으로 예측된 전세가격은",
                  ),
                  Text(
                    "${value.rdsResult}입니다.\n",
                  ),
                ],
              )
              : Text(
                "",
              )
            ],
          );
        },),
    );
  }
}