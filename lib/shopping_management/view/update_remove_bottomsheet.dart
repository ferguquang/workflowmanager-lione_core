import 'package:flutter/material.dart';

class UpdateRemoveBottomSheet extends StatelessWidget {
  bool isUpdate, isDelete;

  void Function() onUpdate;
  void Function() onDelete;

  UpdateRemoveBottomSheet(
      {this.onUpdate,
      this.onDelete,
      this.isUpdate = true,
      this.isDelete = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: isUpdate,
          child: InkWell(
            onTap: () {
              onUpdate();
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text("Sửa")),
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
        Visibility(
          visible: isDelete,
          child: InkWell(
            onTap: () {
              onDelete();
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text("Xóa")),
            ),
          ),
        )
      ],
    );
  }
}
