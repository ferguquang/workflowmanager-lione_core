import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/api_source.dart';
import 'package:workflow_manager/procedures/models/response/column_logic.dart';
import 'package:workflow_manager/procedures/models/response/content_map_response.dart';
import 'package:workflow_manager/procedures/models/response/data_list_dynamiclly.dart';
import 'package:workflow_manager/procedures/models/response/drop_down_datum.dart';
import 'package:workflow_manager/procedures/models/response/gen_table_row.dart';
import 'package:workflow_manager/procedures/models/response/logic_column_update.dart';
import 'package:workflow_manager/procedures/models/response/pair.dart';
import 'package:workflow_manager/procedures/models/response/props.dart';
import 'package:workflow_manager/procedures/models/response/send_table_col_listener.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/base/single_field_repository_base.dart';

class SingleFieldDropdownRepository extends SingleFieldRepositoryBase {
  bool _isFirstInit = true;
  static const separator = ",";
  List<DropdownDatum> selected = [];
  bool isViewInOneRow;

  SingleFieldDropdownRepository(
      Field model, bool isReadonly, BuildContext context, this.isViewInOneRow)
      : super(model, isReadonly, context) {}

  @override
  void initWidget() {
    isVisible = isViewInOneRow ? !model.isHiddenOnView : !model.isHidden;
  }

  @override
  String setValue(String valueText) {
    value = valueText;
    model.value = value;
    // textToDisplay="";
    if (_isFirstInit && isNullOrEmpty(textToDisplay) && model.hasDefault)
      value = model.defaultValue;
    _isFirstInit = false;
    if (isNullOrEmpty(value))
      textToDisplay = "Chưa xác định";
    else {
      if (model.isMultiple) {
        List<String> listIDString = value.split(separator);
        textToDisplay = model.dropdownData
            .where((element) => listIDString.contains(element.value))
            .map((e) => e.text)
            .join(", ");
      } else {
        if (isNotNullOrEmpty(model.dropdownData)) {
          var list = model.dropdownData
              .where((element) => value == element.value)
              .map((e) => e.text)
              .toList();
          if (list.length > 0)
            textToDisplay = list[0];
          else
            textToDisplay = "";
        }
      }
    }
    if (isNullOrEmpty(textToDisplay))
      textToDisplay = isNullOrEmpty(model.displayText)
          ? "Chưa xác định"
          : model.displayText;
    model.displayText = textToDisplay;
    if (model.props != null &&
        model.props.updateApiLinkDropDowns != null &&
        model.props.updateApiLinkDropDowns.length > 0 &&
        model.value != null) {
      List<LogicColumnUpdate> updateApiLinkDropDowns =
          model.props.updateApiLinkDropDowns;
      if (updateApiLinkDropDowns != null && updateApiLinkDropDowns.length > 0) {
        // chỉ có 1 item:
        for (int a = 0; a < updateApiLinkDropDowns.length; a++) {
          LogicColumnUpdate updateAPILinkDropdown = updateApiLinkDropDowns[a];
          if (model.value == updateAPILinkDropdown.refValue) {
            List<String> targets = updateAPILinkDropdown
                .targets; // lấy danh sách cột bị ảnh hưởng (chỉ có 1):
            List<String> params = updateAPILinkDropdown.params;
            if (targets.length > 0) {
              String link = updateAPILinkDropdown.link;
              if (sendTableColListener != null) {
                sendTableColListener?.forEach((element) {
                  element?.sendUpdateApiLinkDropDown(targets, link, params);
                });
              }
            }

            break;
          }
        }
      }
    }
    if (isNotNullOrEmpty(model.props?.genTableRows)) {
      for (GenTableRow row in model.props?.genTableRows) {
        _genTableRow(row);
      }
    }
    notifyListeners();
    return textToDisplay;
  }
  _genTableRow(GenTableRow row){
    ApiCaller.instance
        .postFormData(row.link, {"IDSelected": value}).then((json) {
      ContentMapResponse response = ContentMapResponse.fromJson(json);
      if (response.isSuccess()) {
        if (sendTableColListener != null) {
          for(int i=0;i< row.targets.length;i++){
            int id = int.parse(row.targets[i].replaceAll(RegExp(r"[^\d]+"), ""));
            sendTableColListener?.forEach((element) {
              element?.genTableRow(id, ((response.data[row.valueFroms[i]])as List)?.cast<Map<String,dynamic>>());
            });
          }

        }
      }
    });
  }
  @override
  onTab() async {
    if (isReadonly) return;
    FocusScope.of(context).unfocus();
    List<String> selectedIds = (model.value ?? "").split(separator);
    List<DropdownDatum> dropdownList = [];
    List<DropdownDatum> selectedObjects = [];

    if (model.apiSource != null && model.value != null) {
      ApiSource apiSource = model.apiSource;
      if (apiSource.apiParams.isNotEmpty) {
        Map<String, dynamic> params = {};
        for (int i = 0; i < apiSource.apiParams.length; i++) {
          ApiParams apiParams = apiSource.apiParams[i];
          // apiParams.
          String code = apiParams.code;
          String paramsName = apiParams.paramName;
          if (isNotNullOrEmpty(code)) {
            Field codeField = fields.firstWhere((element) => element.code == code);
            params[code] = codeField.value;
            print("");
          }
        }
        params["IsConvertDropdownData"] = 1;
        var json = await ApiCaller.instance.postFormData(apiSource.apiLink, params);
        DataListApiSourceResponse dataListApiSourceResponse = DataListApiSourceResponse.fromJson(json);
        dropdownList = dataListApiSourceResponse.data.categories;
        print("DataListApiSourceResponse: ${dropdownList.length}");
        model.dropdownData = dropdownList;
        selectedObjects = dropdownList.where((element) {
          return selectedIds.contains(element.value);
        }).toList();

        if (isNullOrEmpty(dropdownList)) {
          showErrorToast("Danh sách trống.");
          return;
        }
      }
    } else {
      selectedObjects = model.dropdownData
          .where((element) => selectedIds.contains(element.value))
          .toList();
       dropdownList = model.dropdownData;
      if (isNullOrEmpty(model.dropdownData)) {
        showErrorToast("Danh sách trống.");
        return;
      }
    }


    ChoiceDialog choiceDialog = ChoiceDialog<DropdownDatum>(
        context, dropdownList,
        getTitle: (data) => data.text,
        isSingleChoice: !model.isMultiple,
        selectedObject: selectedObjects,
        title: model.name,
        hintSearchText: "Tìm kiếm",
        onAccept: (selected) {
          this.selected = selected;
          if (isNullOrEmpty(selected)) return;
          List<String> ids = [];
          List<String> names = [];
          selected.forEach((element) {
            ids.add(element.value);
            names.add(element.text);
          });
          dropdownList.forEach((element) {
            element.selected = selected.contains(element);
          });
          String textString = names.join(separator);
          String idSelected = ids.join(separator);
          model.value = idSelected;
          print(textString + "   " + idSelected);
          setValue(idSelected);
          if (model.isMultiple) {
            List<LogicColumnUpdate> updateInfos = model.props.updateInfos;
            // update cho các cột khác
            if (isNotNullOrEmpty(updateInfos)) {
              // vì chỉ có 1 cho nên sẽ lấy phần tử thứ 0:
              LogicColumnUpdate updateInfo = updateInfos[0];
              if (updateInfo.refValue == "sdn" ||
                  isNullOrEmpty(updateInfo.refValue)) {
                calculateUpdateInfoInSingleField(updateInfo);
              }
            }
          } else {
            Props props = model.props;
            if (props != null &&
                props.updateApiLinkDropDowns != null &&
                sendTableColListener != null) {
              String value = selected.length == 0 ? "" : selected.first.value;
              List<LogicColumnUpdate> updateApiLinkDropDowns =
                  props.updateApiLinkDropDowns;
              if (value != null && updateApiLinkDropDowns != null) {
                for (LogicColumnUpdate columnUpdate in updateApiLinkDropDowns) {
                  if (value == columnUpdate.refValue) {
                    sendTableColListener?.forEach((element) {
                      element?.onClearDataInTableField(columnUpdate.targets);
                    });
                  }
                }
              }
            }
            List<int> changeIndexs = [];
            List<ColumnLogic> updateSelectedValues = props.updateSelectedValue;
            List<ColumnLogic> updateValueRanges = props.updateValueRange;
            List<ColumnLogic> hiddenCol = props.hiddenCol;
            List<ColumnLogic> showCol = props.showCol;
            List<ColumnLogic> enableCol = props.enableCol;
            List<ColumnLogic> readOnlyCol = props.readonlyCol;

            List<ColumnLogic> show = props.show;
            List<ColumnLogic> hidden = props.hidden;
            String valueDropdownData = selected[0].value;

            if (show != null) {
              for (int i = 0; i < show.length; i++) {
                List<String> targets = show[i].targets;
                String refValue = show[i].refValue;
                if (refValue ==
                    valueDropdownData) // so sánh với refValue để lấy giá trị
                {
                  for (int a = 0; a < targets.length; a++) {
                    String column = targets[a];
                    for (int c = 0; c < fields.length; c++) {
                      String code = fields[c].code;
                      if (column == code) {
                        fields[c].isHidden = false;
                        changeIndexs.add(c);
                      }
                    }
                  }
                }
              }
            }

            if (hidden != null) {
              for (int i = 0; i < hidden.length; i++) {
                List<String> targets = hidden[i].targets;
                String refValue = hidden[i].refValue;
                if (refValue == valueDropdownData)
                // so sánh với refValue để lấy giá trị
                {
                  for (int a = 0; a < targets.length; a++) {
                    String column = targets[a];
                    for (int c = 0; c < fields.length; c++) {
                      String code = fields[c].code;
                      if (column == code) {
                        fields[c].isHidden = true;
                        changeIndexs.add(c);
                      }
                    }
                  }
                }
              }
            }
            notifyChangedAll(changeIndexs);
            // check các cột bị ảnh hưởng trong TableField
            List<Pair<int, String>> colIndexsChanged = [];
            for (int i = 0; i < fields.length; i++) {
              Field fieldItem = fields[i];

              // set enable column:
              if (enableCol != null && enableCol.length > 0) {
                for (int a = 0; a < enableCol.length; a++) {
                  String refValue = enableCol[a].refValue;
                  if (valueDropdownData == refValue) {
                    List<String> targets = enableCol[a].targets;
                    for (int b = 0; b < targets.length; b++) {
                      String colReplace = targets[b];
                      colIndexsChanged.add(Pair(
                          SendTableColListener.TYPE_ENABLE_COL, colReplace));
                    }
                  }
                }
              }
              // set readonlyCol:

              if (readOnlyCol != null && readOnlyCol.length > 0) {
                for (int a = 0; a < readOnlyCol.length; a++) {
                  String refValue = readOnlyCol[a].refValue;
                  if (valueDropdownData == refValue) {
                    List<String> targets = readOnlyCol[a].targets;
                    for (int b = 0; b < targets.length; b++) {
                      String colReplace = targets[b];
                      colIndexsChanged.add(Pair(
                          SendTableColListener.TYPE_READONLY_COL, colReplace));
                    }
                  }
                }
              }

              // set item hiện:
              if (showCol != null && showCol.length > 0) {
                for (int a = 0; a < showCol.length; a++) {
                  if (valueDropdownData == showCol[a].refValue) {
                    List<String> targets = showCol[a].targets;
                    for (int b = 0; b < targets.length; b++) {
                      String colReplace = targets[b];
                      colIndexsChanged.add(
                          Pair(SendTableColListener.TYPE_SHOW_COL, colReplace));
                    }
                  }
                }
              }

              // set item ẩn
              if (hiddenCol != null && hiddenCol.length > 0) {
                for (int a = 0; a < hiddenCol.length; a++) {
                  if (valueDropdownData ==
                      hiddenCol[a]
                          .refValue) // so sánh Value của Dropdowndata với RefValue của Hidden Col
                  {
                    List<String> targets = hiddenCol[a].targets;
                    for (int b = 0; b < targets.length; b++) {
                      String colReplace = targets[b];
                      colIndexsChanged.add(Pair(
                          SendTableColListener.TYPE_HIDDEN_COL, colReplace));
                    }
                  }
                }
              }
              if (sendTableColListener != null)
                sendTableColListener?.forEach((element) {
                  element?.updateCol(colIndexsChanged);
                });
              int selectedPosition = model.dropdownData.indexOf(selected[0]);
              // khi click vào thì update item khác: updateValueRanges và updateSelectedValues xử lý logic giống nhau (sever đã confirm)
              if (updateValueRanges != null && updateValueRanges.length > 0) {
                handleUpdateValue(i, updateValueRanges, fieldItem, model.dropdownData, selectedPosition);
              }

              if (updateSelectedValues != null &&
                  updateSelectedValues.length > 0) {
                handleUpdateValue(i, updateSelectedValues, fieldItem,
                    model.dropdownData, selectedPosition);
              }
            }
            // todo update Tháng 9-2020
            // updateAPILinkDropdown:
            List<LogicColumnUpdate> updateApiLinkDropDowns =
                props.updateApiLinkDropDowns;
            if (updateApiLinkDropDowns != null &&
                updateApiLinkDropDowns.length > 0) {
              // chỉ có 1 item:
              for (int a = 0; a < updateApiLinkDropDowns.length; a++) {
                LogicColumnUpdate updateAPILinkDropdown =
                    updateApiLinkDropDowns[a];
                if (valueDropdownData == updateAPILinkDropdown.refValue) {
                  List<String> targets = updateAPILinkDropdown
                      .targets; // lấy danh sách cột bị ảnh hưởng (chỉ có 1):
                  List<String> params = updateAPILinkDropdown.params;
                  if (targets.length > 0) {
                    String link = updateAPILinkDropdown.link;
                    if (sendTableColListener != null) {
                      sendTableColListener?.forEach((element) {
                        element?.sendUpdateApiLinkDropDown(
                            targets, link, params);
                      });
                    }
                  }

                  break;
                }
              }
            }

            // calculateWithApiReturnStringValues
            List<LogicColumnUpdate> calculateWithApiReturnStringValues =
                props.calculateWithApiReturnStringValues;
            if (calculateWithApiReturnStringValues != null) {
              if (calculateWithApiReturnStringValues.length > 0) // chỉ có 1
              {
                LogicColumnUpdate calculateWithApi =
                    calculateWithApiReturnStringValues[0];
                calculateWithApiListener(calculateWithApi, false);
              }
            }

            List<LogicColumnUpdate> calculateWithApis = props.calculateWithApi;
            if (calculateWithApis != null) {
              if (calculateWithApis.length > 0) // chỉ có 1
              {
                LogicColumnUpdate calculateWithApi = calculateWithApis[0];
                calculateWithApiListener(calculateWithApi, false);
              }
            }
          }
        });

    choiceDialog.showChoiceDialog();
  }
}
