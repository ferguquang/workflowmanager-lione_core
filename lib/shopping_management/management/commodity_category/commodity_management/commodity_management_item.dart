import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class CommodityManagementItem extends StatelessWidget {
  void Function(Commodities) onEdit;
  void Function(Commodities) onDelete;
  void Function(Commodities) onClickItem;
  Commodities model;

  CommodityManagementItem({this.onEdit, this.onDelete, this.model, this.onClickItem});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: InkWell(
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
              //   image: "assets/images/icon_commodity_index.png",
              //   height: 32, width: 32,
              // ),
              Image.asset(
                "assets/images/icon_commodity_index.png",
                width: 40,
                height: 40,
              ),
              SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${model.name}",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    Text("Mã hàng hóa: ${model.code}"),
                    Text(
                        "Danh mục hàng hóa: ${model.category ?? "Chưa xác định"}")
                  ],
                ),
              ),
              model.isView ? Icon(Icons.navigate_next) : SizedBox()
            ],
          ),
        ),
      ),
      secondaryActions: [
        Visibility(
          visible: model.isUpdate,
          child: IconSlideAction(
            color: Colors.grey[100],
            iconWidget: Icon(Icons.edit, color: Colors.blue,),
            onTap: () {
              onEdit(model);
            },
          ),
        ),
        Visibility(
          visible: model.isDelete,
          child: IconSlideAction(
            color: Colors.grey[100],
            iconWidget: Icon(Icons.delete, color: Colors.red,),
            onTap: () {
              onDelete(model);
            },
          ),
        )
      ],
    );
  }
}
