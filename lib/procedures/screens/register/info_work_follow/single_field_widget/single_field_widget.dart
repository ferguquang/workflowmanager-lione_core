import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/list_table_item_model.dart';
import 'package:workflow_manager/procedures/models/response/logic_column_update.dart';
import 'package:workflow_manager/procedures/models/response/pair.dart';
import 'package:workflow_manager/procedures/models/response/props.dart';
import 'package:workflow_manager/procedures/models/response/send_table_col_listener.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_checkbox_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_file_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget_repository.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

import 'base/single_field_repository_base.dart';
import 'base/single_field_widget_base.dart';
import 'dropdown_widget/single_field_dropdown_list_widget.dart';
import 'edittext_widget/single_field_edittext_widget.dart';
import 'single_field_text_area_widget.dart';
import 'single_field_text_editor_widget.dart';

class SingleFieldWidget extends StatefulWidget {
  static const int TYPE_DROPDOWN_LIST = 1;
  static const int TYPE_EDIT_TEXT = 2;
  static const int TYPE_CHECKBOX = 3;
  static const int TYPE_FILE = 4;
  static const int TYPE_TEXT_EDITOR = 5;
  static const int TYPE_TEXT_AREA = 6;
  List<Field> fields;
  bool isReadonly;
  List<SendTableColListener> sendTableColListener;
  int countValidating = 0;
  String errorMessage;
  bool isViewInOneRow;
  bool isShowInRowInList;
  Color fixColor;

  SingleFieldWidget(this.fields,
      {this.isReadonly = false,
      GlobalKey key,
      this.sendTableColListener,
      this.isViewInOneRow = false,
      this.isShowInRowInList = false,
      this.fixColor})
      : super(key: key ?? GlobalKey()) {
    if (isNullOrEmpty(fields)) return;
    for (Field field in fields) {
      if (isNotNullOrEmpty(field?.props?.calRow)) {
        for (String cal in field.props.calRow) {
          cal=cal.replaceAll(" ", "");
          List<String> operator = cal.split(  RegExp(r"="));
          if (isNotNullOrEmpty(operator)) {
            if (field.code == operator[0]) {
              List<String> items =
                  operator[1].split(RegExp(r"[\+\-\*/\:\s=]+"));
              for (String code in items) {
                for (Field childField in fields) {
                  if (childField.code == code) {
                    if (isNullOrEmpty(childField.props)) {
                      childField.props = Props();
                    }
                    if (isNullOrEmpty(childField?.props?.calRow))
                      childField.props.calRow = [];
                    childField.props.calRow = field.props.calRow;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  reload(List<int> indexToReload) {
    getState().reload(indexToReload);
  }

  SingleFieldWidgetState getState() {
    GlobalKey _key = (key as GlobalKey);
    if (_key.currentState != null)
      return _key.currentState as SingleFieldWidgetState;
  }

  _setCalForFields(List<Field> listFields, String cal, String code) {
    for (Field field in listFields) {
      if (field.code == code) {
        if (isNullOrEmpty(field.props)) {
          field.props = Props();
        }
        if (isNullOrEmpty(field?.props?.calCol)) field.props.calCol = [];
        field.props.calCol.add(cal);
        field.props.calCol = field.props.calCol.toSet().toList();
      }
    }
  }

  void onFieldEditted(
      List<ListTableItemModel> listListFields, List<Field> listTableField) {
    for (Field field in fields) {
      if (isNotNullOrEmpty(field?.props?.calCol)) {
        for (String cal in field.props.calCol) {
          List<String> operator = cal.split(RegExp(r"="));
          String code = operator[1].split(RegExp("[\\(\\)\\+]"))[1].trim();
          _setCalForFields(listTableField, cal, code);
          if(isNotNullOrEmpty(listListFields)){
            for(ListTableItemModel tableItemModel in listListFields){
              _setCalForFields(tableItemModel.getFieldList(), cal, code);
            }
          }
        }
      }
    }
    Map<String, Pair<String, StringBuffer>> calResult = Map();
    List<Field> fieldList = listTableField;
    if (isNotNullOrEmpty(listListFields)) {
      fieldList = listListFields[0].getFieldList();
    }
    for (int i = 0; i < fieldList.length; i++) {
      Props props = fieldList[i].props;
      if (props != null && props.calCol != null && props.calCol.length > 0) {
        List<String> colColList = props.calCol;
        for (int j = 0; j < colColList.length; j++) {
          String colCol = colColList[j];
          var stringArray = colCol.split("=");
          String resultCol = stringArray[0].trim();
          String recipe = colCol.split("=")[1].trim();
          recipe = recipe.split(RegExp("[\\(\\)\\+]"))[1].trim();
          Pair<String, StringBuffer> content =
              new Pair(recipe, new StringBuffer());
          calResult[resultCol] = content;
        }
      }
    }
    List<Pair<String, StringBuffer>> contents = [];
    contents.addAll(calResult.values);
    for (ListTableItemModel list in listListFields) {
      fieldList = list.getFieldList();
      for (int i = 0; i < fieldList.length; i++) {
        Field field = fieldList[i];
        for (int j = 0; j < contents.length; j++) {
          if (contents[j].key == field.code) {
            contents[j]
                .value
                .write(isNotNullOrEmpty(field.value) ? field.value : "0");
            contents[j].value.write("+");
          }
        }
      }
    }
    for (String key in calResult.keys) {
      StringBuffer sb = calResult[key].value;
      String value = sb.toString();
      if (value.length > 0) {
        value = value
            .substring(0, sb.length - 1)
            .replaceAll(Constant.SEPARATOR_THOUSAND, "");
      }
      caculateData(key, value);
    }
  }

  void caculateData(String cotKetQua, String congThucTong) {
    getState().caculateData(cotKetQua, congThucTong);
  }

  @override
  SingleFieldWidgetState createState() => SingleFieldWidgetState();
}

class SingleFieldWidgetState extends State<SingleFieldWidget>
    with AutomaticKeepAliveClientMixin {
  List<Field> fields;
  SingleFieldWidgetRepository singleFieldWidgetRepository =
      SingleFieldWidgetRepository();
  Map<int, GlobalKey> _keys = Map();

  setValueForAllField() async {
    for (int i = 0; i < fields.length; i++) {
      Field field = fields[i];
      if (field.type == "texteditor") {
        await (_keys[i].currentState as SingleFieldTextEditorWidgetState)
            .setTextToField();
      }
    }
  }

  reload(List<int> indexToReload) {
    for (int i in indexToReload) {
      GlobalKey _key = _keys[i];
      if (_key != null && _key.currentWidget != null)
        (_key.currentWidget as SingleFieldWidgetBase).reload();
    }
  }

  reloadIndex(int index) {
    GlobalKey _key = _keys[index];
    if (_key != null && _key.currentWidget != null)
      (_key.currentWidget as SingleFieldWidgetBase).reload();
  }

  SingleFieldRepositoryBase getSingleFieldRepositoryBase(int index) {
    GlobalKey _key = _keys[index];
    if (_key != null && _key.currentState != null)
      return (_key.currentState as SingleFieldWidgetBaseState)
          .singleFieldRepositoryBase;
    return null;
  }

  void caculateData(String cotKetQua, String congThucTong) {
    for (int i = 0; i < fields.length; i++) {
      String cot = fields[i].code;
      if (cotKetQua == cot) {
        String kq = calcString(congThucTong);
        fields[i].value = kq;
        reloadIndex(i);
        List<LogicColumnUpdate> calculateWithApiReturnStringValues =
            fields[i].props.calculateWithApiReturnStringValues;
        if (calculateWithApiReturnStringValues != null) {
          if (calculateWithApiReturnStringValues.length > 0) {
            LogicColumnUpdate calculateWithApi =
                calculateWithApiReturnStringValues[0];
            getSingleFieldRepositoryBase(i)
                .calculateWithApiListener(calculateWithApi, true);
          }
        }

        List<LogicColumnUpdate> updateInfos = fields[i].props.updateInfos;
        if (updateInfos != null) {
          if (updateInfos.length > 0) {
            LogicColumnUpdate updateInfo = updateInfos[0];
            getSingleFieldRepositoryBase(i)
                .calculateUpdateInfoInSingleField(updateInfo);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fields = widget.fields;
    return ChangeNotifierProvider.value(
      value: singleFieldWidgetRepository,
      child: Consumer(
        builder: (context,
            SingleFieldWidgetRepository singleFieldWidgetRepository, child) {
          _keys = Map();
          return Container(
            padding: widget.isShowInRowInList
                ? EdgeInsets.zero
                : EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: fields?.length ?? 0,
              itemBuilder: (context, index) {
                Field field = fields[index];
                int type = getType(field);
                GlobalKey key = GlobalKey();
                _keys[index] = key;
                double verticalPadding = widget.isShowInRowInList ? 0 : 4;
                switch (type) {
                  case SingleFieldWidget.TYPE_DROPDOWN_LIST:
                    {
                      return SingleFieldDropdownListWidget(
                        field,
                        widget.isReadonly,
                        widget.isViewInOneRow,
                        key: key,
                        verticalPadding: verticalPadding,
                      );
                    }
                  case SingleFieldWidget.TYPE_EDIT_TEXT:
                    {
                      return SingleFieldEditTextWidget(
                          field, widget.isReadonly, widget.isViewInOneRow,
                          verticalPadding: verticalPadding, key: key);
                    }
                  case SingleFieldWidget.TYPE_CHECKBOX:
                    {
                      return SingleFieldCheckboxWidget(
                          field, widget.isReadonly, widget.isViewInOneRow,
                          verticalPadding: verticalPadding, key: key);
                    }
                  case SingleFieldWidget.TYPE_FILE:
                    {
                      return SingleFieldFileWidget(
                          field, widget.isReadonly, widget.isViewInOneRow,
                          verticalPadding: verticalPadding, key: key);
                    }
                  case SingleFieldWidget.TYPE_TEXT_EDITOR:
                    {
                      return SingleFieldTextEditorWidget(
                          field, widget.isReadonly, widget.isViewInOneRow,
                          verticalPadding: verticalPadding, key: key);
                    }
                  case SingleFieldWidget.TYPE_TEXT_AREA:
                    {
                      return SingleFieldTextAreaWidget(
                          field, widget.isReadonly, widget.isViewInOneRow,
                          verticalPadding: verticalPadding, key: key);
                    }
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }

  int getType(Field field) {
    if (field.isCheckbox) {
      return SingleFieldWidget.TYPE_CHECKBOX;
    } else if (field.isDropdown) {
      return SingleFieldWidget.TYPE_DROPDOWN_LIST;
    } else if (field.type == "text" ||
        field.type == "number" ||
        field.type == "decimal" ||
        field.type == "datetime" ||
        field.type == "fctext" ||
        field.type == "fcnumber" ||
        field.type == "fcdatetime" ||
        field.type == "fcdecimal") {
      return SingleFieldWidget.TYPE_EDIT_TEXT;
    } else if (field.type == "fcfile" || field.type == "file") {
      return SingleFieldWidget.TYPE_FILE;
    } else if (field.type == "texteditor") {
      return SingleFieldWidget.TYPE_TEXT_EDITOR;
    } else if (field.type == "textarea") {
      return SingleFieldWidget.TYPE_TEXT_AREA;
    }
    return SingleFieldWidget.TYPE_EDIT_TEXT;
  }

  @override
  bool get wantKeepAlive => true;
}
