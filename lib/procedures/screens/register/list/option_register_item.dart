import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/data_register_save_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/info_work_follow_screen.dart';
import 'package:workflow_manager/procedures/screens/register/list/event_reload_list_register.dart';
import 'package:workflow_manager/procedures/screens/register/list/list_register_repository.dart';
import 'package:workflow_manager/procedures/screens/register/list/list_register_screen.dart';

class OptionRegisterItem extends StatelessWidget {
  ServiceRecords model;
  void Function(ServiceRecords) onDeleteItem;

  OptionRegisterItem({this.model, this.onDeleteItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${model.title}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Padding(padding: EdgeInsets.only(top: 16)),
          Visibility(
            visible: model.editable,
            child: InkWell(
              onTap: () async {
                var data = await pushPage(context, InfoWorkFollowScreen(model.iD, false, true, false));
                eventBus.fire(EventReloadListRegister());
                if (data != null) {
                  DataRegisterSaveResponse response = data;
                }
              },
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.grey),
                  Text("   Chỉnh sửa")
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          Visibility(
            visible: model.removable,
            child: InkWell(
              onTap: () {
                ConfirmDialogFunction(
                    context: context,
                    content: "Bạn có muốn xóa không?",
                    onAccept: () {
                      // var repository = Provider.of<ListRegisterRepository>(context);
                      // repository.removeItem(model);
                      onDeleteItem(model);
                      // eventBus.fire(model);
                      Navigator.pop(context);
                    }).showConfirmDialog();
              },
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.grey),
                  Text("   Xóa")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
