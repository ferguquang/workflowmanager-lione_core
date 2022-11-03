import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/int.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/FCFilemodel.dart';
import 'package:workflow_manager/procedures/models/response/data_record_save_data_response.dart';
import 'package:workflow_manager/procedures/models/response/field_table_list.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/list_table_item_model.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/event_show_action.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/group_table_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/table_field_widget.dart';

import 'header_step_widget.dart';

class CurrentStepWidget extends StatefulWidget {
  CurrentStep model;
  int type;
  int iDServiceRecord;
  int idServiceRecordWfStep;

  CurrentStepWidget(
      this.model, this.type, this.iDServiceRecord, this.idServiceRecordWfStep);

  @override
  _CurrentStepWidgetState createState() => _CurrentStepWidgetState();
}

class _CurrentStepWidgetState extends State<CurrentStepWidget> {
  CurrentStep model;
  SingleFieldWidget _singleFieldWidget;
  List<TableFieldWidget> _tableFieldWidget = [];
  bool _isFirstLoad = true;
  GlobalKey<SingleFieldWidgetState> _singleFieldKey = GlobalKey();
  GroupTableFieldWidget _groupTableFieldWidget;
  bool isShowContent = true;
  bool isShowInfoContent = true;

  @override
  void initState() {
    super.initState();
    // if (model.isAutoSave) {
    //   donePress();
    // }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (model.isAutoSave) {
        donePress();
      }
    });
  }

  bool _isReadonly() {
    return widget.type != DetailProcedureScreen.TYPE_RESOLVE;
  }

  @override
  Widget build(BuildContext context) {
    model = widget.model;
    if (_isFirstLoad && model != null || model.isCheckReLoadModel == true) {
      if (isNullOrEmpty(model?.groupInfos)) {
        _tableFieldWidget = [];
        for (TableFieldInfo tableList
            in model?.fieldTableList?.tableFieldInfos) {
          _tableFieldWidget.add(TableFieldWidget(
            tableList?.fields ?? [],
            _isReadonly(),
            null,
            isAdd: tableList.isAdd,
            isDelete: tableList.isDelete,
            indexTitle: tableList.id,
            tableName: tableList.name,
            iDTable: tableList.iDTable,
          ));
        }
      } else {
        _groupTableFieldWidget = GroupTableFieldWidget(
            model?.tableFields, _isReadonly(), null, model?.groupInfos);
      }
      _singleFieldWidget = SingleFieldWidget(
        model?.singleFields ?? [],
        isReadonly: _isReadonly(),
        key: _singleFieldKey,
        isViewInOneRow: false,
      );
      if (isNotNullOrEmpty(model?.groupInfos)) {
        _singleFieldWidget?.sendTableColListener = _tableFieldWidget;
        _groupTableFieldWidget.onFieldEditted =
            _singleFieldWidget.onFieldEditted;
      } else {
        _singleFieldWidget?.sendTableColListener = _tableFieldWidget;
        _tableFieldWidget.forEach((element) {
          element.onFieldEditted = _singleFieldWidget.onFieldEditted;
        });
      }
      _isFirstLoad = false;
      model.isCheckReLoadModel = false;
    }
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        HeaderStepWidget("Bước hiện tại", (isExpanded) {
          isShowContent = isExpanded;
          setState(() {});
        }, isShowContent),
        Visibility(
          visible: isShowContent,
          child: Column(
            children: [
              _buildRow("Tên bước", model?.name ?? ""),
              _buildRow("Phụ trách", _getExecutes() ?? ""),
              _buildRow("Ngày kết thúc",
                  model?.endDate?.toDate(Constant.ddMMyyyyHHmm) ?? ""),
              _buildRow(
                  "Thời gian còn lại", model?.dateLine?.dateLineString ?? "",
                  contentColor:
                      model?.dateLine?.isLate == true ? Colors.red : null),
            ],
          ),
        ),
        Visibility(
          visible: !(isNullOrEmpty(model?.singleFields) &&
              isNullOrEmpty(model?.tableFields)),
          child: HeaderStepWidget("Thông tin bước hiện tại", (isExpanded) {
            isShowInfoContent = isExpanded;
            setState(() {});
          }, isShowInfoContent),
        ),
        Visibility(
          visible: isShowInfoContent &&
              !(isNullOrEmpty(model?.singleFields) &&
                  isNullOrEmpty(model?.tableFields)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: isNotNullOrEmpty(model?.singleFields),
                child: _singleFieldWidget,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Visibility(
                  visible: isNotNullOrEmpty(model?.tableFields),
                  child: Column(
                    children: [
                      _groupTableFieldWidget ??
                              isNotNullOrEmpty(_tableFieldWidget)
                          ? ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: _tableFieldWidget,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),

              Visibility(
                  visible: isNotNullOrEmpty(model?.singleFields) ||
                      isNotNullOrEmpty(model?.tableFields),
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.blue),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 16, color: Colors.white),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                        ),
                        InkWell(
                          child: Text(
                            "Lưu thông tin",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: donePress,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  donePress() async {
    FocusScope.of(context).unfocus();
    if (model.singleFields.length > 0)
      await _singleFieldKey.currentState.setValueForAllField();
    List<String> listNumberTypes = ["number", "fcnumber"];
    // dữ liệu trong bảng //todo ko đc xóa
    Map<String, dynamic> params = Map();

    List<Field> tableFields = model?.tableFields;
    List<ListTableItemModel> listTableItem = [];
    params["IDServiceRecord"] = widget.iDServiceRecord;
    params["IDServiceRecordWfStep"] = widget.idServiceRecordWfStep;
    String listIntString = "";
    if (isNotNullOrEmpty(model?.groupInfos)) {
      listTableItem = _groupTableFieldWidget?.listTableItem;
      bool isCheckValidate =
          addParamsFromTableField(params, listTableItem, tableFields);
      if (isCheckValidate == false) return;
      List<String> listValueColumn = [];
      for (int row = 0; row < listTableItem.length; row++) {
        String value = listTableItem[row].getFieldList()[0].groupValues[0];
        listValueColumn.add("\"" + value + "\"");
      }

      params["IDGroup"] = "[" + listValueColumn.join(",") + "]";
      List<int> idTables = [];
      for (var row in listTableItem) {
        idTables.add(row.fieldList[0].iDTable);
      }
      params["IDTable"] = "[${idTables.join(",")}]";
      List<int> iDFieldChilds = [];
      if (isNotNullOrEmpty(tableFields)) {
        if (tableFields[0]?.idRows == null)
          iDFieldChilds = [];
        else
          iDFieldChilds = tableFields[0].idRows;
        int countRow = iDFieldChilds.length;
        for (int i = countRow; i < listTableItem.length; i++) {
          iDFieldChilds.add(0);
        }
      }
      if (isNotNullOrEmpty(iDFieldChilds)) {
        params["IDFieldChild"] = '[${iDFieldChilds.join(",")}]';
      }
      params["FieldIndex"] = listTableItem.length.toString();
    } else {
      List<String> totalFields = [];
      _tableFieldWidget.forEach((element) {
        element.listTableItem.forEach((element) {
          totalFields.add('"0"');
        });
      });
      listIntString = '"[${totalFields.join(",")}]"';
      params["IDFieldChild"] = listIntString;
      params["IDGroup"] = listIntString;
      List<String> listFieldIndex = [];
      List<String> listIDTable = [];
      for (int i = 0; i < _tableFieldWidget.length; i++) {
        listFieldIndex.add('"${_tableFieldWidget[i].listTableItem.length}"');
        _tableFieldWidget[i].listTableItem.forEach((element) {
          listIDTable.add('"${element.fieldList[0].iDTable}"');
        });
      }
      params["FieldIndex"] = '[${listFieldIndex.join(",")}]';
      bool isCheckValidate2 = true;
      for(TableFieldWidget widget in _tableFieldWidget){
        isCheckValidate2 = addParamsFromTableField(
            params, widget.listTableItem, widget.listField);
        if(isCheckValidate2==false)
          break;
      }
      if (isCheckValidate2 == false) return;
      params["IDTable"] = '[${listIDTable.join(",")}]';
    }
    List<Field> singleFields = model?.singleFields;
    for (int i = 0; i < singleFields.length; i++) // code chỉnh sửa
    {
      String key = singleFields[i].key;
      String value = singleFields[i].value;
      if (!singleFields[i].isHidden == true) {
        if (singleFields[i].isRequired == true && isNullOrEmpty(value)) {
          showErrorToast("Trường " + singleFields[i].name + " cần bắt buộc!!!");
          return;
        }
      }

      if (listNumberTypes.contains(singleFields[i].type)) {
        value = convertDoubleToInt(value);
      }
      params[key] = value;
    }
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getQTTTRecordSaveData, params);
    DataRecordSaveDataResponse dataRecordSaveDataResponse =
        DataRecordSaveDataResponse.fromJson(response);
    if (dataRecordSaveDataResponse.status == 1) {
      eventBus.fire(EventShowAction());
      // DataRecordSaveData dataRecordSaveData = dataRecordSaveDataResponse.data;
      showSuccessToast("Lưu thông tin thành công.");
    } else {
      showErrorToast(dataRecordSaveDataResponse,
          defaultMessage: "Lưu thông tin thất bại");
    }
  }

  bool isContainDuplicate<T>(List<T> list) {
    Set<T> forCheck = Set();
    for (T t in list) {
      if (!forCheck.contains(t)) {
        forCheck.add(t);
      } else {
        return true;
      }
    }
    return false;
  }

  bool addParamsFromTableField(Map<String, dynamic> params,
      List<ListTableItemModel> listTableItem, List<Field> tableFields) {
    List<String> listNumberTypes = ["number", "fcnumber"];
    for (int column = 0; column < tableFields.length; column++) {
      List<String> listValueColumn = [];
      if (isNotNullOrEmpty(listTableItem)) {
        for (int row = 0; row < listTableItem.length; row++) {
          bool isHidden = listTableItem[row].fieldList[column].isHidden == true;
          String value = listTableItem[row].fieldList[column].value;
          bool isRequired =
              listTableItem[row].fieldList[column].isRequired == true;
          bool isReadOnly =
              listTableItem[row].fieldList[column].isReadonly == true;
          if (isRequired && !isReadOnly && isNullOrEmpty(value) && !isHidden) {
            showErrorToast("Trường " +
                listTableItem[row].fieldList[column].name +
                " không được để trống");
            return false;
          }

          if (listTableItem[row].fieldList[column].isMoney == true) {
            value = trimCommaOfString(value);
          }
          if (listNumberTypes
              .contains(listTableItem[row].fieldList[column].type)) {
            value = convertDoubleToInt(value);
          }
          listValueColumn.add("\"" + value + "\"");
          tableFields[column].isHidden = isHidden;
        }
      } else {
        for (Field field in tableFields) {
          if (field.isRequired == true) {
            showErrorToast("Trường " + field.name + " không được để trống");
            return false;
          }
        }
      }
      // check trùng nếu Unique = true
      if (tableFields[column].isUnique == true) {
        String codeName = tableFields[column].name;
        for (int a = 0; a < listValueColumn.length; a++) {
          if (isContainDuplicate(listValueColumn)) {
            showErrorToast(codeName + " đã bị trùng!!!");
            return false;
          }
        }
      }

      String valueColumn = "[" + listValueColumn.join(", ") + "]";
      String key = tableFields[column].key;
      if (tableFields[column].type == "fcfile") {
        for (int row = 0; row < listTableItem.length; row++) {
          String valueColumnFile = "";
          valueColumnFile = listTableItem[row].fieldList[column].value;
          List<FCFileModel> fileModels = [];
          if (isNotNullOrEmpty(valueColumnFile)) {
            var json = jsonDecode(valueColumnFile);
            if (isNotNullOrEmpty(json)) {
              json.forEach((v) {
                fileModels.add(FCFileModel.fromJson(v));
              });
            }
            List<String> fileNames = [];
            List<String> filePaths = [];
            if (fileModels != null) {
              for (int j = 0; j < fileModels.length; j++) {
                fileNames.add("\"" + fileModels[j].fileName + "\"");
                filePaths.add("\"" + fileModels[j].filePath + "\"");
              }

              String sendFileNameTableFields = "[" + fileNames.join(", ") + "]";
              String sendFilePathTableFields = "[" + filePaths.join(", ") + "]";

              params[key + "_N_" + (row + 1).toString()] =
                  sendFileNameTableFields;
              params[key + "_P_" + (row + 1).toString()] =
                  sendFilePathTableFields;
            }
          }
        }
      } else {
        params[key] = valueColumn;
      }
    }
    return true;
  }

  String trimCommaOfString(String string) {
    if (isNullOrEmpty(string)) {
      return "";
    }
    if (string.contains(",")) {
      return string.replaceAll(",", "");
    } else {
      return string;
    }
  }

  String _getExecutes() {
    List<String> names = [];
    // users
    if (isNotNullOrEmpty(model?.executors?.users)) {
      for (User user in model?.executors.users) {
        names.add(user.name);
      }
    }
    // depts
    if (isNotNullOrEmpty(model?.executors?.depts)) {
      for (HandlerInfo dept in model?.executors.depts) {
        names.add(dept.name);
      }
    }
    // postions
    if (isNotNullOrEmpty(model?.executors?.positions)) {
      for (Position position in model?.executors.positions) {
        names.add(position.name);
      }
    }
    // teams
    if (isNotNullOrEmpty(model?.executors?.teams)) {
      for (HandlerInfo position in model?.executors.teams) {
        names.add(position.name);
      }
    }
    return names.join("\n");
  }

  Widget _buildRow(String lable, String title, {Color contentColor}) {
    return Padding(
      padding: EdgeInsets.only(top: 4, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            style: TextStyle(color: getColor("#7B7A7B")),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.end,
              style: TextStyle(color: contentColor ?? getColor("#3D3D3D")),
            ),
          )
        ],
      ),
    );
  }
}
