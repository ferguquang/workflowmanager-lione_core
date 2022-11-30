import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/list_table_item_model.dart';
import 'package:workflow_manager/procedures/models/response/logic_column_update.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget.dart';

class TableFieldViewDialog extends StatefulWidget {
  ListTableItemModel model;
  bool isReadonly;
  List<Field> backupFields = [];
  String title;

  TableFieldViewDialog(this.model, this.isReadonly, this.title) {
    backupFields = [];
    for (Field field in model.fieldList) {
      Field backup = Field();
      field.copyTo(backup);
      backupFields.add(backup);
    }
  }

  @override
  _TableFieldViewDialogState createState() => _TableFieldViewDialogState();
}

class _TableFieldViewDialogState extends State<TableFieldViewDialog> {
  GlobalKey<SingleFieldWidgetState> _key = GlobalKey();

  SingleFieldWidget getSingleFieldWidget() {
    return _key.currentWidget as SingleFieldWidget;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        for (int i = 0; i < widget.backupFields.length; i++) {
          widget.backupFields[i].copyTo(widget.model.fieldList[i]);
        }
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "Bảng dữ liệu"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SingleFieldWidget(
                    widget.model.getFieldList(),
                    isReadonly: widget.isReadonly,
                    key: _key,
                  ),
                ),
              ),
              Visibility(
                visible: !widget.isReadonly,
                child: SaveButton(
                  title: "Xong",
                  margin: EdgeInsets.all(16),
                  onTap: donePress,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void donePress() {
    if (getSingleFieldWidget().countValidating > 0) {
      showErrorToast("Đang kiểm tra các trường.");
      return;
    } else if (getSingleFieldWidget().errorMessage != null) {
      showErrorToast(getSingleFieldWidget().errorMessage);
      return;
    }
    _key.currentState.setValueForAllField();
    for (int i = 0; i < widget.model.getFieldList().length; i++) {
      bool isRequired = widget.model.getFieldList()[i].isRequired;
      bool isReadOnly = widget.model.getFieldList()[i].isReadonly;

      if (isRequired &&
          !isReadOnly &&
          !widget.model.getFieldList()[i].isHidden) {
        if (isNullOrEmpty(widget.model.getFieldList()[i].value)) {
          showErrorToast("Trường " +
              widget.model.getFieldList()[i].name +
              " không được để trống");
          return;
        }
      }

      // check min max value, char
      String value = widget.model.getFieldList()[i].value;
      if (widget.model.getFieldList()[i].type == "fctext" && isNotNullOrEmpty(value)) {
        int minChar = widget.model.getFieldList()[i].minChar;
        int maxChar = widget.model.getFieldList()[i].maxChar;

        if (isNotNullOrEmpty(maxChar) && value.length > maxChar) {
          ToastMessage.show("Trường ${widget.model.getFieldList()[i].name} không được vượt quá độ dài $maxChar", ToastStyle.error);
          return;
        }
        if (isNotNullOrEmpty(minChar) &&  value.length < minChar) {
          ToastMessage.show("Trường ${widget.model.getFieldList()[i].name} không được nhỏ hơn độ dài $minChar", ToastStyle.error);
          return;
        }
      }
      if (widget.model.getFieldList()[i].type == "fcnumber" && isNotNullOrEmpty(value)) {
        int minVal = widget.model.getFieldList()[i].minVal;
        int maxVal = widget.model.getFieldList()[i].maxVal;

        if (isNotNullOrEmpty(minVal) && int.parse(value) < minVal) {
          ToastMessage.show("Trường ${widget.model.getFieldList()[i].name} không được nhỏ hơn $minVal", ToastStyle.error);
          return;
        }
        if (isNotNullOrEmpty(maxVal) && int.parse(value) > maxVal) {
          ToastMessage.show("Trường ${widget.model.getFieldList()[i].name} không được lớn hơn $minVal", ToastStyle.error);
          return;
        }
      }
    }
    Navigator.pop(context, widget.model);
  }
}

abstract class CalculateWithApiListener {
  void onCalculateWithApi(LogicColumnUpdate calculateWithApiReturnStringValue);
}
