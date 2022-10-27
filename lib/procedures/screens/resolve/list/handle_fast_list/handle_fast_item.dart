import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/record_is_resolve_list_response.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/selected_handle_dialog.dart';

class HandleFastItem extends StatelessWidget {
  ServiceRecordsResolve model;

  void Function(ServiceRecordsResolve) onUpdate;

  HandleFastItem({this.model, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    if (model.actions.length == 1) {
      model.actions[0].isSelected = true;
      model.idStep = model.actions[0].iDStep;
      model.idSchemaCondition = model.actions[0].iDSchemaCondition;
      model.actionSelected = model.actions[0];
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4,),
          _buildRow("Bước hiện tại", model.currentStepName),
          SizedBox(height: 4,),
          _buildRow("Tình trạng hồ sơ", model.status),
          SizedBox(height: 4,),
          InkWell(
            child: _buildRow("Xử lý", model.actionSelected == null ? "" : model.actionSelected.stateString, nextScreen: true),
            onTap: () {
              CustomDialogWidget(
                  context,
                  SelectedHandleDialog(
                    actions: model.actions,
                    onSelected: (ActionsResolve selected) {
                      model.actionSelected = selected;
                      model.idStep = selected.iDStep;
                      model.idSchemaCondition = selected.iDSchemaCondition;
                      onUpdate(model);
                    },
                  ),
                isClickOutWidget: true
              ).show();
            },
          ),
          SizedBox(height: 4,),
          InkWell(
            onTap: () {
              pushPage(context, InputTextWidget(
                title: "Nội dung xử lý",
                content: model.describe ?? "",
                onSendText: (String describe) {
                  model.describe = describe;
                  onUpdate(model);
                },
              ));
            },
            child: _buildRow("Nội dung xử lý", model.describe ?? "", nextScreen: true)
          )
        ],
      ),
    );
  }

  Widget _buildRow(title, value, {nextScreen}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(title)),
        Expanded(child: Text(value, textAlign: TextAlign.end,)),
        Visibility(
          visible: nextScreen == true,
          child: Icon(Icons.navigate_next, size: 20, color: Colors.grey,),
        )
      ],
    );
  }
}
