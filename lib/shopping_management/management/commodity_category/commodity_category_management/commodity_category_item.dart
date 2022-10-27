import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/commodity_category_response.dart';

class CommodityCategoryItem extends StatelessWidget {
  void Function(Categories) onEdit;
  void Function(Categories) onDelete;
  Categories model;

  CommodityCategoryItem({this.model, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Image.asset(
              "assets/images/icon_item_commodity_category.png",
              width: 40,
              height: 40,
            ),
            // ImageAssetCircleWidget(
            //   color: getColor('#D9EEE8'),
            //   image: "assets/images/icon_item_commodity_category.png",
            //   height: 24, width: 24,
            // ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.name}",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Text("Mã danh mục: ${model.code}")
                ],
              ),
            ),
            // Icon(Icons.navigate_next)
          ],
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
