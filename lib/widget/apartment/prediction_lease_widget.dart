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
                value.result == ""
                ? ""
                : "입력한 데이터를 기반으로 예측된 값은"
                  "${value.result}입니다.",
              ),
            ],
          );
        },),
    );
  }
}