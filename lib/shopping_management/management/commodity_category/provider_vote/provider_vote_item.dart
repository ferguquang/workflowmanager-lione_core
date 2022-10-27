import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/provider_vote_response.dart';

class ProviderVoteItem extends StatelessWidget {
  void Function(ProviderVotes) onEdit;
  void Function(ProviderVotes) onDelete;
  void Function(ProviderVotes) onClickItem;
  ProviderVotes model;

  ProviderVoteItem({this.onEdit, this.onDelete, this.onClickItem, this.model});

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
              Image.asset(
                "assets/images/icon_statistic.png",
                width: 40,
                height: 40,
              ),
              // ImageAssetCircleWidget(
              //   color: getColor('#D9EEE8'),
              //   image: "assets/images/icon_statistic.png",
              //   height: 32,
              //   width: 32,
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
                    Text("Mã nhà cung cấp: ${model.code ?? ""}"),
                    Text("Thời gian đánh giá: ${model.created ?? ""}")
                  ],
                ),
              ),
              Icon(Icons.navigate_next)
            ],
          ),
        ),
      ),
      secondaryActions: [
        Visibility(
          visible: model.isUpdate,
          child: IconSlideAction(
            color: Colors.grey[100],
            iconWidget: Icon(
              Icons.edit,
              color: Colors.blue,
            ),
            onTap: () {
              onEdit(model);
            },
          ),
        ),
        Visibility(
          visible: model.isDelete,
          child: IconSlideAction(
            color: Colors.grey[100],
            iconWidget: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () {
              onDelete(model);
            },
          ),
        )
      ],
    );
  }
}
