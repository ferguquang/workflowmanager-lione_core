import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/plan_shopping_response.dart';

class PlanShoppingItem extends StatelessWidget {
  void Function(Plannings) onClickItem;
  Plannings model;

  PlanShoppingItem({this.onClickItem, this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (model.isView) {
          onClickItem(model);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // ImageAssetCircleWidget(
            //   color: getColor('#D9EEE8'),
            //   image: "assets/images/icon_shopping_plan_qlms.png",
            //   height: 32,
            //   width: 32,
            // ),
            Image.asset(
              "assets/images/icon_shopping_plan_qlms.png",
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.shoppingType}",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Text("Báo cáo: ${model.report ?? ""}"),
                  Text("Tổng giá trị (VNĐ): ${model.totalAmount ?? ""}")
                ],
              ),
            ),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
  }
}
