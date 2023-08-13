import 'package:flutter/material.dart';
import 'package:fluttermainproject/viewmodel/prediction_sale_provider.dart';
import 'package:provider/provider.dart';

class PredictionSaleWidget extends StatelessWidget {
  const PredictionSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<PredictionSale>(
        builder: (context, value, child) {
          return Column(
            children: [
              Text(
                value.rdsResult == ""
                ? ""
                : "예상되는 거래금액은 ${value.rdsResult} 입니다."
              ),
            ],
          );
        },),
    );
  }
}