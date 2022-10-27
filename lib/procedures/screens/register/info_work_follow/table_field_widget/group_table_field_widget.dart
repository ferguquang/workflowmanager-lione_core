import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/category.dart';
import 'package:workflow_manager/procedures/models/response/data_list_dynamiclly.dart';
import 'package:workflow_manager/procedures/models/response/drop_down_datum.dart';
import 'package:workflow_manager/procedures/models/response/group_infos.dart';
import 'package:workflow_manager/procedures/models/response/list_table_item_model.dart';
import 'package:workflow_manager/procedures/models/response/pair.dart';
import 'package:workflow_manager/procedures/models/response/send_table_col_listener.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/table_field_widget.dart';

import '../table_field_view_dialog.dart';
import '../text_editor_widget.dart';

class GroupTableFieldWidget extends StatefulWidget with SendTableColListener {
  List<ListTableItemModel> listTableItem = [];
  bool isReadonly;
  bool isViewInOneRow = false;
  OnFieldEdited onFieldEditted;
  List<Field> listField;
  List<GroupInfos> groupInfos; // group
  bool isShowInRowInList;
  void Function(List<ListTableItemModel>) onAddItem;

  GroupTableFieldWidget(List<Field> listField, this.isReadonly,
      this.onFieldEditted, this.groupInfos,
      {GlobalKey key, this.onAddItem, this.isShowInRowInList})
      : super(key: key ?? GlobalKey()) {
    this.listField = listField;
    if (isNullOrEmpty(listTableItem)) {
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
    }
    if (isReadonly == true) {
      for (int i = 0; i < listTableItem.length; i++) {
        for (int j = 0; j < listTableItem[i].getFieldList().length; j++) {
          listTableItem[i].getFieldList()[j].isReadonly = true;
        }
      }
    }
  }

  @override
  void updateCol(List<Pair<int, String>> colInfo) {
    getState().updateCol(colInfo);
  }

  @override
  void sendUpdateApiLinkDropDown(
      List<String> target, String link, List<String> params) {
    getState().sendUpdateApiLinkDropDown(target, link, params);
  }

  @override
  void onClearDataInTableField(List<String> resetCol) {
    getState().onClearDataInTableField(resetCol);
  }

  _GroupTableFieldWidgetState getState() {
    return (key as GlobalKey).currentState as _GroupTableFieldWidgetState;
  }

  @override
  _GroupTableFieldWidgetState createState() => _GroupTableFieldWidgetState();
}

class _GroupTableFieldWidgetState extends State<GroupTableFieldWidget>
    with AutomaticKeepAliveClientMixin {
  List<ListTableItemModel> listTableItem = [];
  List<List<ListTableItemModel>> mainListTableItem = [];
  List<Field> listField;
  List<GroupInfos> groupInfos;

  void onFieldEditted(List<ListTableItemModel> listTableItemModels, int index,
      List<Field> listTableField) {
    mainListTableItem[index] = listTableItemModels;
    listTableItem.clear();
    for (List<ListTableItemModel> listTableItemModels in mainListTableItem) {
      listTableItem.addAll(listTableItemModels);
    }
    if (widget.onFieldEditted != null) {
      widget.onFieldEditted(listTableItem, listTableField);
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
        for (int i = 0; i < listTableItem.length; i++) {
          for (int a = 0; a < listTableItem[i].getFieldList().length; a++) {
            String code = listTableItem[i]
                .getFieldList()[a]
                .code; // lấy code trong danh sách
            if (code == codeBiAnhHuong) // check trùng code
            {
              listTableItem[i].getFieldList()[a].dropdownData.clear();
              List<DropdownDatum> dropdownDatumList = [];
              for (int b = 0; b < categories.length; b++) {
                Category dropDownDataNew = categories[b];
                DropdownDatum dropdownDatumAdd = new DropdownDatum();
                dropdownDatumAdd.value = dropDownDataNew.id.toString();
                dropdownDatumAdd.text = dropDownDataNew.name;
                dropdownDatumList.add(dropdownDatumAdd);
              }

              listTableItem[i].getFieldList()[a].dropdownData =
                  dropdownDatumList;
              dropdownDatum = dropdownDatumList;
            }
          }
        }
      }
    }
  }
  void onClearDataInTableField(List<String> resetCol) {
    for (int i = 0; i < listTableItem.length; i++) {
      for (int a = 0; a < listTableItem[i].getFieldList().length; a++) {
        listTableItem[i].getFieldList()[a].displayText = "";
        listTableItem[i].getFieldList()[a].value = "";
        listTableItem[i].getFieldList()[a].warning = "";
      }
    }
    setState(() {

    });
  }

  @override
  void updateCol(List<Pair<int, String>> colInfo) {
    if (isNullOrEmpty(colInfo)) return;
    for (int i = 0; i < listTableItem.length; i++) {
      for (int a = 0; a < listTableItem[i].getFieldList().length; a++) {
        listTableItem[i].getFieldList()[a].displayText = "";
        listTableItem[i].getFieldList()[a].value = "";
        listTableItem[i].getFieldList()[a].warning = "";
      }
    }
    if (widget.onFieldEditted != null) {
      widget.onFieldEditted(listTableItem, widget.listField);
    }
    for (ListTableItemModel model in listTableItem) {
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
    listTableItem = widget.listTableItem;
    listField = widget.listField;
    groupInfos = widget.groupInfos;
    if (isNotNullOrEmpty(listTableItem)) // chỉnh sửa
    {
      List<String> groupValues = listField[0].groupValues;
      for (int i = 0; i < groupInfos.length; i++) {
        String iIDGroupInfos;
        List<int> listPositionIDGroup = [];
        iIDGroupInfos = groupInfos[i].iD;
        List<ListTableItemModel> childList = [];
        if (listField.length > 0) {
          for (int i = 0; i < listField[0].groupValues.length; i++) {
            String sIDGroup = listField[0].groupValues[i];
            if (sIDGroup == iIDGroupInfos) {
              listPositionIDGroup.add(i);
            }
          }
        }

        for (int iID in listPositionIDGroup) {
          childList.add(listTableItem[iID]);
        }

        for (ListTableItemModel dataTableModel in childList) {
          for (Field field in dataTableModel.getFieldList()) {
            field.groupValues.clear();
            field.groupValues.add(iIDGroupInfos);
          }
        }
        mainListTableItem.add(childList);
      }
    } else {
      for (int i = 0; i < groupInfos.length; i++) {
        mainListTableItem.add([]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isNotNullOrEmpty(mainListTableItem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: mainListTableItem?.length ?? 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              double padding = widget.isShowInRowInList != true ? 0 : 16;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: getWidgetInList(groupInfos[index]?.name ?? "",
                            groupInfos[index]?.fieldValues ?? ""),
                      ),
                      InkWell(
                        child: Visibility(
                            visible: !widget.isReadonly,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: getColor("#787878")),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: Text("Thêm"),
                            )),
                        onTap: () {
                          addItem(index);
                        },
                      )
                    ],
                  ),
                  mainListTableItem[index].length > 0
                      ? Container(
                          constraints: BoxConstraints(minHeight: 30),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    widget.isShowInRowInList != true ? 16 : 0),
                            child: TableFieldWidget(
                              null,
                              widget.isReadonly,
                              (list, tableFields) {
                                onFieldEditted(list, index, tableFields);
                              },
                              listTableItem: mainListTableItem[index],
                              isShowHeader: false,
                              isShowInRowInList: widget.isShowInRowInList,
                              hasGroupInfo: true,
                            ),
                          ),
                        )
                      : Container(
                          height: widget.isShowInRowInList != true ? 30 : 0,
                        ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getWidgetInList(String name, String weight) {
    if (widget.isShowInRowInList == true)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 0.1,
            color: Colors.grey[400],
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              (name).toUpperCase(),
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),
        ],
      );
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (name).toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Visibility(
            visible: widget.isShowInRowInList != true,
            child: Text((weight ?? "").toUpperCase()),
          )
        ],
      );
  }

  addItem(int index) {
    ListTableItemModel itemTableAdd = new ListTableItemModel(listField);
    String sIDGroupInfos = groupInfos[index].iD;

    for (int i = 0; i < itemTableAdd.getFieldList().length; i++) {
      itemTableAdd.getFieldList()[i].groupValues.add(sIDGroupInfos.toString());
    }
    int count = 0;
    for (int i = 0; i < mainListTableItem.length; i++) {
      if (i <= index) {
        count += mainListTableItem[i].length;
      }
    }
    listTableItem.insert(count, itemTableAdd);
    mainListTableItem[index].add(itemTableAdd);
    // if(widget.onFieldEditted!=null){
    //   widget.onFieldEditted(listTableItem);
    // }
    setState(() {});
  }

  String getTitle(int index) {
    ListTableItemModel model = listTableItem[index];
    String name = "";
    bool isTextSeted = false;
    if (model.getFieldList().length > 0) {
      for (int i = 0; i < model.getFieldList().length; i++) {
        bool isHiden = false;
        if (widget.isViewInOneRow) {
          isHiden = model.getFieldList()[i].isHiddenOnView;
        } else {
          isHiden = model.getFieldList()[i].isHidden;
        }

        if (!isHiden) {
          if (isNotNullOrEmpty(model.getFieldList()[i].value)) {
            bool isDropDown = model.getFieldList()[i].isDropdown;
            if (isDropDown) {
              String value = model.getFieldList()[i].value;
              List<DropdownDatum> dropdownDatum =
                  model.getFieldList()[i].dropdownData;
              for (int a = 0; a < dropdownDatum.length; a++) {
                String valueInDropDown = dropdownDatum[a].value;
                if (value == valueInDropDown) {
                  String text = dropdownDatum[a].text;
                  name = model.getFieldList()[i].name + ": " + text;
                  break;
                }
              }
            } else {
              name =
                  "${model.getFieldList()[i].name}: ${model.getFieldList()[i].value}";
            }
          } else {
            name = model.getFieldList()[i].name;
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
