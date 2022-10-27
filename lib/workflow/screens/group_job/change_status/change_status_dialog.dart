import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/response/list_group_task_response.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';

class ChangeStatusDialog extends StatelessWidget {
  String idSelecteds;
  List<StatusGroup> statusGroups;
  void Function(int, String) onAccept;

  TextEditingController editingController = TextEditingController();

  ChangeStatusDialog({this.idSelecteds, this.statusGroups, this.onAccept});

  int idStatus;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(child: Text('Chuyển trạng thái', style: TextStyle(fontSize: 14),)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                BottomSheetDialog(
                  context: context,
                  onTapListener: (item) {
                    StatusGroup status = item;
                    editingController.text = status.value;
                    idStatus = status.key;
                  }
                ).showBottomSheetDialog(statusGroups);
              },
              child: Row(
                children: [
                  Expanded(child: Text('Trạng thái', style: TextStyle(fontSize: 14))),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: editingController,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                      )
                    ),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Hủy', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      onAccept(idStatus, idSelecteds);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
