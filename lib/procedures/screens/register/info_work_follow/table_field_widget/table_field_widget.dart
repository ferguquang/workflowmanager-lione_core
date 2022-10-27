import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/category.dart';
import 'package:workflow_manager/procedures/models/response/data_list_dynamiclly.dart';
import 'package:workflow_manager/procedures/models/response/drop_down_datum.dart';
import 'package:workflow_manager/procedures/models/response/list_table_item_model.dart';
import 'package:workflow_manager/procedures/models/response/pair.dart';
import 'package:workflow_manager/procedures/models/response/props.dart';
import 'package:workflow_manager/procedures/models/response/send_table_col_listener.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';

import '../table_field_view_dialog.dart';

typedef OnFieldEdited = void Function(
    List<ListTableItemModel> listTableItemModels, List<Field> listTableField);

class TableFieldWidget extends StatefulWidget with SendTableColListener {
  List<ListTableItemModel> listTableItem = [];
  bool isReadonly;
  bool isViewInOneRow = false;
  List<Field> listField;
  OnFieldEdited onFieldEditted;
  void Function(List<ListTableItemModel>) onAddItem;
  bool isShowHeader;
  bool isShowInRowInList;
  bool hasGroupInfo;
  bool isAdd;
  bool isDelete;
  int indexTitle;
  String tableName;
  int iDTable;
  int id;

  TableFieldWidget(List<Field> listField, this.isReadonly, this.onFieldEditted,
      {GlobalKey key,
      this.isAdd = true,
      this.isDelete = true,
      this.onAddItem,
      this.isShowHeader = true,
      this.listTableItem,
      this.isShowInRowInList,
      this.indexTitle,
      this.tableName,
      this.iDTable,
      this.id,
      this.hasGroupInfo})
      : super(key: key ?? GlobalKey()) {
    _generate(listField,false);
  }

  void _generate(List<Field> listField,bool isResetListTableItem) {
    if (isNullOrEmpty(listTableItem)||isResetListTableItem) listTableItem = [];
    if (isNullOrEmpty(listTableItem)) {
      this.listField = listField;
      if (isNotNullOrEmpty(listField)) {
        int itemCount = listField[0]?.values?.length ?? 0;
        if (itemCount > 0) {
          for (int i = 0; i < itemCount; i++) {
            ListTableItemModel model = ListTableItemModel(listField);
            listTableItem.add(model);
          }
          for (int i = 0; i < listTableItem.length; i++) {
            ListTableItemModel listListTableItem = listTableItem[i];
            for (int a = 0; a < listListTableItem.getFieldList().length; a++) {
              List<String> value = listListTableItem.getFieldList()[a].values;
              for (int c = 0; c < value.length; c++) {
                if (c == i) {
                  listTableItem[i].getFieldList()[a].value = value[c];
                }
              }
            }
          }
        }
      }
    } else {
      this.listField = listTableItem[0].getFieldList();
    }
    if (isReadonly == true) {
      for (int i = 0; i < listTableItem.length; i++) {
        for (int j = 0; j < listTableItem[i].getFieldList().length; j++) {
          listTableItem[i].getFieldList()[j].isReadonly = true;
        }
      }
    }
    for (Field field in listField) {
      if (isNotNullOrEmpty(field?.props?.cal)) {
        for (String cal in field.props.cal) {
          cal = cal.replaceAll(" ", "");
          List<String> operator = cal.split(RegExp(r"="));
          if (isNotNullOrEmpty(operator)) {
            if (field.code == operator[0]) {
              List<String> items =
                  operator[1].split(RegExp(r"[\+\-\*/\:\s=]+"));
              for (String code in items) {
                for (Field childField in listField) {
                  if (childField.code == code) {
                    if (isNullOrEmpty(childField.props)) {
                      childField.props = Props();
                    }
                    if (isNullOrEmpty(childField?.props?.cal))
                      childField.props.cal = [];
                    childField.props.cal = field.props.cal;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  void genTableRow(int targetId, List<Map<String, dynamic>> rows) {
    super.genTableRow(targetId, rows);
    getState()?.genTableRow(targetId, rows);
  }

  void updateCol(List<Pair<int, String>> colInfo) {
    getState()?.updateCol(colInfo);
  }

  @override
  void sendUpdateApiLinkDropDown(
      List<String> target, String link, List<String> params) {
    getState()?.sendUpdateApiLinkDropDown(target, link, params);
  }

  @override
  void onClearDataInTableField(List<String> resetCol) {
    getState()?.onClearDataInTableField(resetCol);
  }

  _TableFieldWidgetState getState() {
    return (key as GlobalKey).currentState as _TableFieldWidgetState;
  }

  @override
  _TableFieldWidgetState createState() => _TableFieldWidgetState();
}

class _TableFieldWidgetState extends State<TableFieldWidget>
    with AutomaticKeepAliveClientMixin {
  String title;

  void genTableRow(int targetId, List<Map<String, dynamic>> rows) {
    if (targetId == widget.iDTable &&
        isNotNullOrEmpty(rows) &&
        widget.listField != null) {
      for (int i = 0; i < rows[0].keys.length; i++) {
        Field field = widget.listField[i];
        field.values = rows
            .map((e) => e[rows[0].keys.elementAt(i)].toString())
            .toList()
            .cast<String>();
      }
      widget._generate(widget.listField,true);
      setState(() {});
    }
  }

  void sendUpdateApiLinkDropDown(
      List<String> targets, String link, List<String> stringParams) async {
    Map<String, String> params = new Map();
    var json = await ApiCaller.instance.postFormData(link, params);
    DataListDynamicllyResponse response =
        DataListDynamicllyResponse.fromJson(json);
    if (response.status == 1) {
      List<Category> categories = response.data.categories;
      List<DropdownDatum> dropdownDatum = [];
      for (int x = 0; x < targets.length; x++) {
        String codeBiAnhHuong = targets[x]; // lấy code bị ảnh hưởng
        if (isNotNullOrEmpty(widget.listTableItem))
          for (int i = 0; i < widget.listTableItem.length; i++) {
            _updateColvalue(widget.listTableItem[i].getFieldList(), codeBiAnhHuong,
                categories, dropdownDatum);
          }
        _updateColvalue(
            widget.listField, codeBiAnhHuong, categories, dropdownDatum);
      }
    }
  }

  void _updateColvalue(List<Field> fields, String codeBiAnhHuong,
      List<Category> categories, List<DropdownDatum> dropdownDatum) {
    for (int a = 0; a < fields.length; a++) {
      String code = fields[a].code; // lấy code trong danh sách
      if (code == codeBiAnhHuong) // check trùng code
      {
        fields[a].dropdownData.clear();
        List<DropdownDatum> dropdownDatumList = [];
        for (int b = 0; b < categories.length; b++) {
          Category dropDownDataNew = categories[b];
          DropdownDatum dropdownDatumAdd = new DropdownDatum();
          dropdownDatumAdd.value = dropDownDataNew.id.toString();
          dropdownDatumAdd.text = dropDownDataNew.name;
          dropdownDatumList.add(dropdownDatumAdd);
        }

        fields[a].dropdownData = dropdownDatumList;
        dropdownDatum = dropdownDatumList;
      }
    }
  }

  void onClearDataInTableField(List<String> resetCol) {
    for (int i = 0; i < widget.listTableItem.length; i++) {
      for (int a = 0; a < widget.listTableItem[i].getFieldList().length; a++) {
        widget.listTableItem[i].getFieldList()[a].displayText = "";
        widget.listTableItem[i].getFieldList()[a].value = "";
        widget.listTableItem[i].getFieldList()[a].warning = "";
      }
    }
    setState(() {});
  }

  void updateCol(List<Pair<int, String>> colInfo) {
    if (isNullOrEmpty(colInfo)) return;
    for (int i = 0; i < widget.listTableItem.length; i++) {
      for (int a = 0; a < widget.listTableItem[i].getFieldList().length; a++) {
        widget.listTableItem[i].getFieldList()[a].displayText = "";
        widget.listTableItem[i].getFieldList()[a].value = "";
        widget.listTableItem[i].getFieldList()[a].warning = "";
      }
    }
    if (widget.onFieldEditted != null) {
      widget.onFieldEditted(widget.listTableItem, widget.listField);
    }
    for (ListTableItemModel model in widget.listTableItem) {
      for (Field field in model.getFieldList()) {
        for (Pair<int, String> info in colInfo) {
          if (info.value == field.code) {
            switch (info.key) {
              case SendTableColListener.TYPE_SHOW_COL:
                {
                  field.isHidden = false;
                  break;
                }
              case SendTableColListener.TYPE_HIDDEN_COL:
                {
                  field.isHidden = true;
                  break;
                }
              case SendTableColListener.TYPE_ENABLE_COL:
                {
                  field.isReadonly = false;
                  break;
                }
              case SendTableColListener.TYPE_READONLY_COL:
                {
                  field.isReadonly = true;
                  break;
                }
            }
          }
        }
      }
    }
    for (Field field in widget.listField) {
      for (Pair<int, String> info in colInfo) {
        if (info.value == field.code) {
          switch (info.key) {
            case SendTableColListener.TYPE_SHOW_COL:
              {
                field.isHidden = false;
                break;
              }
            case SendTableColListener.TYPE_HIDDEN_COL:
              {
                field.isHidden = true;
                break;
              }
            case SendTableColListener.TYPE_ENABLE_COL:
              {
                field.isReadonly = false;
                break;
              }
            case SendTableColListener.TYPE_READONLY_COL:
              {
                field.isReadonly = true;
                break;
              }
          }
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.listTableItem = widget.listTableItem;
    title = "Bảng dữ liệu ${widget.indexTitle ?? ''}";
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isNotNullOrEmpty(widget.listField) ||
          isNotNullOrEmpty(widget.listTableItem),
      child: Column(
        children: [
          Visibility(
            visible: widget.isShowHeader && widget.isShowInRowInList != true,
            child: Row(
              children: [
                Expanded(
                    child: Text(isNotNullOrEmpty(widget.tableName)
                        ? widget.tableName
                        : title ?? "Bảng dữ liệu")),
                InkWell(
                  child: Visibility(
                      visible: !widget.isReadonly && widget.isAdd,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: getColor("#787878")),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Text("Thêm"),
                      )),
                  onTap: addItem,
                )
              ],
            ),
          ),
          ListView.builder(
            itemCount: widget.listTableItem?.length ?? 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String value = "";
              ListTableItemModel fieldTable = widget.listTableItem[index];
              return Padding(
                padding: EdgeInsets.only(
                    top: (widget.isShowInRowInList != true ? 8.0 : 0.0)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Visibility(
                            visible: widget.hasGroupInfo != true,
                            child: Text("${index + 1}. ")),
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                openItem(index);
                              },
                              child: widget.hasGroupInfo == true
                                  ? widget.isShowInRowInList == true
                                      ? getWidgetInList(
                                          getTitle(index), value, false)
                                      : Text(getTitle(index))
                                  : getWidgetInList(
                                      getTitle(index), value, false)),
                        ),
                        Visibility(
                          visible: widget.isShowInRowInList != true &&
                              widget.isDelete,
                          child: Opacity(
                            opacity: !widget.isReadonly ? 1 : 0,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                              ),
                              onTap: () {
                                removeItem(index);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(padding: EdgeInsets.only(top: 16))
        ],
      ),
    );
  }

  Widget getWidgetInList(String content, String value, bool isHeader) {
    TextStyle textStyle;
    if (isHeader)
      textStyle = TextStyle(color: Colors.black);
    else {
      textStyle = TextStyle(color: getColor("#858585"));
    }
    return Column(children: [
      Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
                child: Text(
              content ?? "",
              style: textStyle,
            )),
            Text(value ?? "", style: textStyle),
            Visibility(
                visible: widget.isShowInRowInList == true && !isHeader,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ))
          ],
        ),
      ),
      Divider(
        height: 0.1,
        color: Colors.grey[400],
      ),
    ]);
  }

  removeRowId(ListTableItemModel item) {
    if (item == null ||
        isNullOrEmpty(widget.listField) ||
        isNullOrEmpty(widget.listField[0].idRows)) return;
    int index = widget.listTableItem.indexOf(item);
    if (index == -1) return;
    if (index >= widget.listField[0].idRows.length) return;
    for (Field field in widget.listField) {
      field.idRows.removeAt(index);
    }
    for (ListTableItemModel table in widget.listTableItem) {
      for (Field field in table.getFieldList()) {
        field.idRows.removeAt(index);
      }
    }
  }

  removeItem(int index) {
    ConfirmDialogFunction confirmDialogFunction = ConfirmDialogFunction(
      context: context,
      content: "Bạn có muốn xóa bảng này?",
      onAccept: () {
        removeRowId(widget.listTableItem[index]);
        widget.listTableItem.removeAt(index);
        if (widget.onFieldEditted != null)
          widget.onFieldEditted(widget.listTableItem, widget.listField);
        setState(() {});
      },
    );
    confirmDialogFunction.showConfirmDialog();
  }

  openItem(int index) async {
    FocusScopeNode focusScopeNode = FocusScope.of(context);
    focusScopeNode.unfocus();
    ListTableItemModel listTableItemModel = await pushPage(
        context,
        TableFieldViewDialog(widget.listTableItem[index], widget.isReadonly,
            widget.indexTitle != null ? "$title.${index + 1}" : null));
    if (listTableItemModel != null) {
      widget.listTableItem.insert(index, listTableItemModel);
      widget.listTableItem.removeAt(index + 1);
      if (widget.onFieldEditted != null) {
        widget.onFieldEditted(widget.listTableItem, widget.listField);
      }
    }
    setState(() {});
  }

  addItem() {
    ListTableItemModel listTableItemModel =
        ListTableItemModel(widget.listField);
    widget.listTableItem.add(listTableItemModel);
    if (widget.onAddItem != null) widget.onAddItem(widget.listTableItem);
    setState(() {});
  }

  String getTitle(int index) {
    ListTableItemModel model = widget.listTableItem[index];
    String name = "";
    bool isTextSeted = false;
    if (model.getFieldList().length > 0) {
      for (int i = 0; i < model.getFieldList().length; i++) {
        bool isHiden = false;
        Field field = model.getFieldList()[i];
        if (widget.isViewInOneRow) {
          isHiden = field.isHiddenOnView;
        } else {
          isHiden = field.isHidden;
        }

        if (!isHiden) {
          if (isNotNullOrEmpty(field.value)) {
            bool isDropDown = field.isDropdown;
            if (isDropDown) {
              String value = field.value;
              List<DropdownDatum> dropdownDatum = field.dropdownData;
              for (int a = 0; a < dropdownDatum.length; a++) {
                String valueInDropDown = dropdownDatum[a].value;
                if (value == valueInDropDown) {
                  String text = dropdownDatum[a].text;
                  name = field.name + ": " + text;
                  break;
                }
              }
            } else {
              String value = field.value;
              if (isNotNullOrEmpty(value) &&
                  (field.type == "datetime" || field.type == "fcdatetime"))
                value = value.replaceAll("-", "/");
              name = "${field.name}: ${value}";
            }
          } else {
            name = field.name;
          }
          isTextSeted = true;
          break;
        }
      }
    }
    if (!isTextSeted) name = "Bảng dữ liệu";
    return name;
  }

  @override
  bool get wantKeepAlive => true;
}
