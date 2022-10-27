import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/plan_shopping_response.dart';

class PlanDetailItem extends StatelessWidget {
  void Function(PlanningDetails) onClickItem;
  int idShoppingType, idSuggestionType;
  PlanningDetails model;

  PlanDetailItem(
      {this.onClickItem,
      this.model,
      this.idShoppingType,
      this.idSuggestionType});

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
            Image.asset(
              "assets/images/icon_shopping_plan_qlms.webp",
              width: 40,
              height: 40,
            ),
            // ImageAssetCircleWidget(
            //   color: getColor('#D9EEE8'),
            //   image: "assets/images/icon_shopping_plan_qlms.webp",
            //   height: 32,
            //   width: 32,
            // ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: _contentWidget(),
            ),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
  }

  Widget _contentWidget() {
    if (idShoppingType == 1) {
      // mua sắm nội bộ
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${model.deliveryCategory}",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Text("Số tiền dự kiến: ${model.amount ?? ""}"),
          // idSuggestionType = 2 là thuê, = 1 là mua
          idSuggestionType == 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Thời gian thuê: ${model.nbRent ?? ""}"),
                    Text("Đơn vị tính: ${model.rentType ?? ""}")
                  ],
                )
              : SizedBox()
        ],
      );
    } else if (idShoppingType == 2) {
      // mua sắm dự án
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${model.deliveryCategory}",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Text("Số tiền dự kiến: ${model.amount ?? ""}"),
          Text("Thời gian thuê: ${model.nbRent ?? ""}"),
          Text("Đơn vị tính: ${model.rentType ?? ""}")
        ],
      );
    } else {
      // mua sắm phân phối
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${model.deliveryCategory}",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Text("Số lượng: ${model.qTY ?? ""}"),
          Text("Đơn vị: ${model.unit ?? ""}"),
          Text("Tổng tiền: ${model.amount ?? ""}")
        ],
      );
    }
  }
}
