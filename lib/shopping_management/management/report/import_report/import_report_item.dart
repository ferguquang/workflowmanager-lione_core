import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/import_report_response.dart';

class ImportReportItem extends StatelessWidget {
  void Function(ImportReport) onClickItem;
  ImportReport model;

  ImportReportItem({this.onClickItem, this.model});

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
            // ImageAssetCircleWidget(
            //   color: getColor('#D9EEE8'),
            //   image: "assets/images/icon_statistic.png",
            //   height: 32,
            //   width: 32,
            // ),
            Image.asset(
              "assets/images/icon_statistic.png",
              height: 32,
              width: 32,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.nameCommodity}",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Text("Nhà cung cấp: ${model.nameProvider ?? ""}"),
                  Text("Số lượng: ${model.qTY ?? ""}")
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
