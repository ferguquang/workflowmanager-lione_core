import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/requisition_response.dart';

class RequisitionShoppingItem extends StatelessWidget {
  void Function(Requisitions) onClickItem;
  Requisitions model;

  RequisitionShoppingItem({this.onClickItem, this.model});

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
            //   image: "assets/images/icon_shopping_request_qlms.png",
            //   height: 32,
            //   width: 32,
            // ),
            Image.asset(
              "assets/images/icon_shopping_request_qlms.png",
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
                    "${model.requisitionNumber}",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Text("Hình thức mua sắm: ${model.shoppingType ?? ""}"),
                  Row(
                    children: [
                      Text("Trạng thái: "),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text("${model.status.name}",
                              style: TextStyle(color: Colors.white)),
                        ),
                        decoration: BoxDecoration(
                            color: getColor(model.status.bgColor),
                            borderRadius: BorderRadius.circular(10)),
                      )
                    ],
                  ),
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
