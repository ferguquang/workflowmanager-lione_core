import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class DebtLogItem extends StatelessWidget {
  ProviderDebts model;
  void Function(ProviderDebts) onClickItem;

  DebtLogItem({this.model, this.onClickItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClickItem(model);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            ImageAssetCircleWidget(
              color: getColor('#D9EEE8'),
              image: "assets/images/report.png",
            ),
            SizedBox(width: 16,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${model.name}", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                  Text("Mã PO: ${model.pONumber}"),
                  Text("Thời gian: ${model.updated ?? "Chưa xác định"}")
                ],
              ),
            ),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );;
  }
}
