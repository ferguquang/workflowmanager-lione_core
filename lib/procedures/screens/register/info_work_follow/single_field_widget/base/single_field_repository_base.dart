import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/attribute.dart';
import 'package:workflow_manager/procedures/models/response/column_logic.dart';
import 'package:workflow_manager/procedures/models/response/data_check_validate_response.dart';
import 'package:workflow_manager/procedures/models/response/data_warning.dart';
import 'package:workflow_manager/procedures/models/response/drop_down_datum.dart';
import 'package:workflow_manager/procedures/models/response/logic_column_update.dart';
import 'package:workflow_manager/procedures/models/response/props.dart';
import 'package:workflow_manager/procedures/models/response/send_table_col_listener.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_view_dialog.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget.dart';
import 'package:workflow_manager/procedures/models/response/data_seletec_dynamiclly_response.dart';
import 'package:workflow_manager/procedures/models/response/data_warning_response.dart';

class SingleFieldRepositoryBase extends ChangeNotifier {
  Field model;
  bool isReadonly;
  String value;
  BuildContext context;
  bool isVisible = true;
  Color lableColor = Colors.black;
  Color contentColor = Colors.black;
  bool isRequire = false;
  String textToDisplay = "";

  List<Field> get fields => singleFieldWidget.fields;

  SingleFieldWidget get singleFieldWidget {
    return context.findAncestorWidgetOfExactType<SingleFieldWidget>();
  }

  List<SendTableColListener> get sendTableColListener {
    return singleFieldWidget?.sendTableColListener;
  }

  SingleFieldRepositoryBase(this.model, this.isReadonly, this.context) {//isViewInOneRow là trường hợp chỉ view
    setReadonly(isReadonly);
    initWidget();
    Color color = singleFieldWidget.isShowInRowInList == true
        ? getColor("#858585")
        : null;
    if (color != null) {
      lableColor = color;
      contentColor = color;
    }
  }

  void handleCheckValidate(
      LogicColumnUpdate checkValidate, int position) async {
    if (isNullOrEmpty(checkValidate.link)) return;
    singleFieldWidget.countValidating++;
    Map<String, String> params = new Map();
    List<String> paramsString = checkValidate.params;
    if (isNotNullOrEmpty(paramsString))
      for (int i = 0; i < paramsString.length; i++) {
        String key = paramsString[i];
        for (int a = 0; a < fields.length; a++) {
          String code = fields[a].code;
          if (code == key) {
            String value = fields[a].value;
            params[key] = value;
          }
        }
      }
    var json =
        await ApiCaller.instance.postFormData(checkValidate.link, params,isLoading: false);
    DataCheckValidateResponse response =
        DataCheckValidateResponse.fromJson(json);
    if (response.status == 1) {
      int errorIndex = -1;
      DataCheckValidate dataCheckValidate = response.data;
      String value = dataCheckValidate.value;
      if (isNotNullOrEmpty(dataCheckValidate.value)) {
        if (isNotNullOrEmpty(checkValidate.targets)) {
          for (int i = 0; i < checkValidate.targets.length; i++) {
            String codeBiAnhHuong = checkValidate.targets[i];
            for (int a = 0; a < fields.length; a++) {
              String code = fields[a].code;
              if (code == codeBiAnhHuong) {
                fields[a].textCheckValidate = value;
                fields[a].isCheckValidate = true;
                fields[a].isPass = false;
                errorIndex = a;
                singleFieldWidget.errorMessage = value;
                showErrorToast(value);
                notifyChangedAll([a]);
              }
            }
          }
        }
      }
      if (errorIndex == -1) {
        singleFieldWidget.errorMessage = null;
        fields[position].textCheckValidate = "";
        fields[position].isCheckValidate = true;
        fields[position].isPass = true;
        notifyChangedAll([position]);
      }
    }
    singleFieldWidget.countValidating--;
  }

  calculateWithApiListener(
      LogicColumnUpdate calculateWithApi, bool isSingleField,
      {bool dontCallNotifyAll = false}) async {
    Map<String, dynamic> params = Map();
    List<String> paramsString = calculateWithApi.params;
    List<Field> fields = singleFieldWidget.fields;
    for (int i = 0; i < paramsString.length; i++) {
      String key = paramsString[i];
      for (int a = 0; a < fields.length; a++) {
        String code = fields[a].code;
        if (code == key) {
          String value = fields[a].value;
          params[key] = value;
        }
      }
    }
    if (isNotNullOrEmpty(calculateWithApi.link)) {
      final response =
          await ApiCaller.instance.postFormData(calculateWithApi.link, params,isLoading: false);
      DataWarningResponse dataWarningResponse =
          DataWarningResponse.fromJson(response);
      if (dataWarningResponse.status == 1) {
        DataWarning dataWarning = dataWarningResponse.data;
        String value = dataWarning.value;
        if (isNullOrEmpty(value)) {
          if (isNotNullOrEmpty(dataWarning.total)) {
            value = dataWarning.total;
          }
        }
        List<int> indexs = [];
        if (isNotNullOrEmpty(calculateWithApi.targets)) {
          for (int i = 0; i < calculateWithApi.targets.length; i++) {
            String codeBiAnhHuong = calculateWithApi.targets[i];
            for (int a = 0; a < fields.length; a++) {
              String code = fields[a].code;
              if (code == codeBiAnhHuong) {
                fields[a].value = value;
                fields[a].warning = value;
                fields[a].isWarning = true;
                fields[a].colorClass = dataWarning.colorClass;
                indexs.add(a);
              }
            }
          }
        }
        notifyChangedAll(indexs);
      } else {
        if (isNotNullOrEmpty(dataWarningResponse.messages))
          showErrorToast(dataWarningResponse.messages);
      }
    }
  }

  handleUpdateValue(
      int i,
      List<ColumnLogic> updateSelectedValues,
      Field fieldItem,
      List<DropdownDatum> dropdownDatumList,
      int positionDropDownSelected,
      {bool dontCallNotifyAll = false}) {
    List<int> updateIds = [];
    for (int a = 0; a < updateSelectedValues.length; a++) {
      ColumnLogic updateSelectItem = updateSelectedValues[a];
      String target = updateSelectItem.targets[0].toLowerCase(); // bỏ ko
      String code = fieldItem.code;
      String origin = updateSelectItem.origin;
      if (code == origin) // check code của cột bị ảnh hưởng
      {
        List<Attribute> attributes = dropdownDatumList[positionDropDownSelected].attributes;
        for (int c = 0; c < attributes.length; c++) {
          String keyAttributes = attributes[c].key.toLowerCase();
          if (target == keyAttributes) {
            String textSelected = attributes[c].value;
            if (fieldItem.isDropdown) {
              for (int d = 0; d < fieldItem.dropdownData.length; d++) {
                String value = fieldItem.dropdownData[d].value;
                if (textSelected == value) {
                  String text = fieldItem.dropdownData[d].text;
                  fields[i].displayText = text;
                  fields[i].value = value;
                  updateIds.add(i);
                }
              }
            } else {
              fields[i].value = textSelected;
              updateIds.add(i);
            }

            // cập nhật text
            String codeBiAnhHuong = fields[i].code;
            if (origin == codeBiAnhHuong) {
              for (int d = 0; d < fields.length; d++) {
                List<DropdownDatum> listDropDownBiAnhHuong =
                    fields[d].dropdownData;
                for (int e = 0; e < listDropDownBiAnhHuong.length; e++) {
                  String textDropDownBiAnhHuong =
                      listDropDownBiAnhHuong[e].text;
                  if (textSelected == textDropDownBiAnhHuong) {
                    String valueBiAnhHuong = listDropDownBiAnhHuong[e].value;
                    fields[d].value = valueBiAnhHuong;
                    updateIds.add(d);
                  }
                }
              }
            }
          }
        }
      }
    }
    notifyChangedAll(updateIds);
  }

  void calculateUpdateInfoInSingleField(LogicColumnUpdate updateInfo,
      {bool dontCallNotifyAll = false}) async {
    Map<String, String> params = new Map();
    List<String> paramsString = updateInfo.params;
    for (int i = 0; i < paramsString.length; i++) {
      String key = paramsString[i];
      for (int a = 0; a < fields.length; a++) {
        String code = fields[a].code;
        if (code == key) {
          String value = fields[a].value;
          params[key] = value;
        }
      }
    }
    String link = updateInfo.link;
    List<int> indexs = [];
    if (isNotNullOrEmpty(link)) {
      var response = await ApiCaller.instance.postFormData(link, params);
      DataSelectDynamicllyResponse dataSelectDynamicllyResponse =
          DataSelectDynamicllyResponse.fromJson(response);
      if (dataSelectDynamicllyResponse.isSuccess()) {
        String valueResponse = dataSelectDynamicllyResponse.data.value;
        List<String> stringValue = (jsonDecode(valueResponse) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        List<String> targets = updateInfo.targets;
        for (int i = 0; i < targets.length; i++) {
          String code = targets[i]; // cột bị ảnh hưởng
          for (int a = 0; a < fields.length; a++) {
            // check cột bị ảnh hưởng để gán Value vào:
            if (code == fields[a].code) {
              fields[a].value = stringValue[i];
              indexs.add(a);
            }
          }
        }
      }
    }
    notifyChangedAll(indexs);
  }

  setReadonly(bool isReadonly) {
    this.isReadonly = isReadonly || model.isReadonly;
    this.isRequire = model.isRequired && !this.isReadonly;

    if (this.isReadonly) {
      lableColor = getColor("8b8f92");
      contentColor = getColor("#626262");
    } else {
      lableColor = Colors.black;
      contentColor = lableColor;
    }
    notifyListeners();
  }

  String setValue(String text) {
    value = text;
    if (model.isWarning == true) {
      if (isNotNullOrEmpty(model.warning)) {
        value = model.warning;
        isReadonly = true;
        if (isNotNullOrEmpty(model.colorClass)) {
          contentColor = Colors.red;
        }
      } else {
        value = "";
      }
    }
    // notifyListeners();
    return value;
  }

  void initWidget() {
    isVisible = !(model.isHiddenOnView || model.isHidden);
    notifyListeners();
  }

  onTab() async {}

  void notifyChangedAll(List<int> indexs) {
    if (isNotNullOrEmpty(indexs)) singleFieldWidget.reload(indexs);
  }

  void reloadData() {
    setReadonly(isReadonly);
    initWidget();
    setValue(model.value);
  }
}
