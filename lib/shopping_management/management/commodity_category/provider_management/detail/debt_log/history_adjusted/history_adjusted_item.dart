import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';
import 'package:workflow_manager/base/extension/string.dart';

class HistoryAdjustedItem extends StatelessWidget {
  ProviderDebtLogs model;
  int position;

  HistoryAdjustedItem(this.model, this.position);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: 32,
              width: 32,
              alignment: Alignment.center,
              child: Text("${position + 1}"),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(100)
            ),
          ),
          SizedBox(width: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tổng nợ: ${model.debtAmount}"),
              Text("Số tiền thanh toán: ${model.paidAmount}"),
              Text("Tổng nợ còn lại: ${model.remainAmount}"),
              Text("Thời gian: ${model.created}"),
            ],
          )
        ],
      ),
    );
  }

}
