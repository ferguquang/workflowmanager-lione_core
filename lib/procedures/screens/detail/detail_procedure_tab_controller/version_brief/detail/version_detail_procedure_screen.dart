import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/field_child_datum.dart';
import 'package:workflow_manager/procedures/models/response/file_data.dart';
import 'package:workflow_manager/procedures/models/response/files.dart';
import 'package:workflow_manager/procedures/models/response/group_infos.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/version_brief/detail/version_file_detail.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_text_editor_widget.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

import 'produre_version2_item_model.dart';

class VersionDetailProcedureScreen extends StatefulWidget {
  RecordVersions recordVersions;

  VersionDetailProcedureScreen(this.recordVersions);

  @override
  _VersionDetailProcedureScreenState createState() =>
      _VersionDetailProcedureScreenState();
}

class _VersionDetailProcedureScreenState
    extends State<VersionDetailProcedureScreen> {
  RecordVersions data;
  List<ProdureVersion2ItemModel> listData = [];

  @override
  void initState() {
    super.initState();
    data = widget.recordVersions;
    addItem();
  }

  addItem() {
    ProdureVersion2ItemModel requierNameItem = new ProdureVersion2ItemModel(
        nameField: "Người yêu cầu bổ sung", content: data.requierName);
    ProdureVersion2ItemModel additionStepItem = new ProdureVersion2ItemModel(
        nameField: "Bước bổ sung hồ sơ", content: data.additionStep);
    ProdureVersion2ItemModel additionerNameItem = new ProdureVersion2ItemModel(
        nameField: "Người bổ sung", content: data.additionerName);
    ProdureVersion2ItemModel contentItem = new ProdureVersion2ItemModel(
        nameField: "Ghi chú", content: data.content);
    ProdureVersion2ItemModel timeItem = new ProdureVersion2ItemModel(
        nameField: "Thời gian bổ sung hồ sơ",
        content: isNotNullOrEmpty(data.additionTime)
            ? data.additionTime.replaceAll("-", "/")
            : "");

    listData.add(requierNameItem);
    listData.add(additionStepItem);
    listData.add(additionerNameItem);
    listData.add(contentItem);
    listData.add(timeItem);

    ProdureVersion2ItemModel dataItem =
        new ProdureVersion2ItemModel(nameField: "Trường dữ liệu", content: "");
    dataItem.isTextColor = true;
    dataItem.isTextType = true;
    listData.add(dataItem);

    if (isNotNullOrEmpty(data.data)) // list data
    {
      for (int i = 0; i < data.data.length; i++) {
        DataRecordVersion recordData = data.data[i];
        ProdureVersion2ItemModel model = new ProdureVersion2ItemModel(
            nameField: recordData.title, content: "");
        model.isTextColor = true;
        model.iNumberIndexTableField = i;
        listData.add(model);

        if (recordData.type == 4) // type = 4 là file
        {
          if (isNullOrEmpty(recordData.oldFiles)) {
            ProdureVersion2ItemModel contentOldItem =
                new ProdureVersion2ItemModel.nameConntent("Nội dung cũ ", "");
            listData.add(contentOldItem);
          } else {
            ProdureVersion2ItemModel contentOldItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung cũ ",
                    recordData.oldFiles.length == 0
                        ? ""
                        : recordData.oldFiles.length.toString());
            contentOldItem.isShowButton = true;
            contentOldItem.filesList = recordData.oldFiles;
            listData.add(contentOldItem);
          }

          if (isNullOrEmpty(recordData.newFiles)) {
            ProdureVersion2ItemModel contentNewItem =
                new ProdureVersion2ItemModel.nameConntent("Nội dung mới ", "");
            listData.add(contentNewItem);
          } else {
            ProdureVersion2ItemModel contentNewItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung mới ",
                    recordData.newFiles.length == 0
                        ? ""
                        : recordData.newFiles.length.toString());
            contentNewItem.isShowButton = true;
            contentNewItem.filesList = recordData.newFiles;
            listData.add(contentNewItem);
          }
        } else if (recordData.type == 5) // type = 5 là textarea
        {
          ProdureVersion2ItemModel contentOldItem =
              new ProdureVersion2ItemModel.nameConntent(
                  "Nội dung cũ ", recordData.oldVal);
          contentOldItem.type = "textarea";
          listData.add(contentOldItem);

          ProdureVersion2ItemModel contentNewItem =
              new ProdureVersion2ItemModel.nameConntent(
                  "Nội dung mới ", recordData.newVal);
          contentNewItem.type = "textarea";
          listData.add(contentNewItem);
        } else if (recordData.type == 6) // type = 6 là texteditor
        {
          ProdureVersion2ItemModel contentOldItem =
              new ProdureVersion2ItemModel.nameConntent(
                  "Nội dung cũ ", recordData.oldVal);
          contentOldItem.type = "texteditor";
          listData.add(contentOldItem);

          ProdureVersion2ItemModel contentNewItem =
              new ProdureVersion2ItemModel.nameConntent(
                  "Nội dung mới ", recordData.newVal);
          contentNewItem.type = "texteditor";
          listData.add(contentNewItem);
        } else if (recordData.type == 7) // type = 7 là checkBox
        {
          ProdureVersion2ItemModel contentOldItem =
              new ProdureVersion2ItemModel.nameConntent(
                  "Nội dung cũ ", recordData.oldVal);
          contentOldItem.isCheckbox = true;
          listData.add(contentOldItem);

          ProdureVersion2ItemModel contentNewItem =
              new ProdureVersion2ItemModel.nameConntent(
                  "Nội dung mới ", recordData.newVal);
          contentNewItem.isCheckbox = true;
          listData.add(contentNewItem);
        } else {
          ProdureVersion2ItemModel contentOldItem =
              new ProdureVersion2ItemModel.nameConntent(
                  "Nội dung cũ ", recordData.oldVal);
          listData.add(contentOldItem);
          ProdureVersion2ItemModel contentNewItem =
              new ProdureVersion2ItemModel.nameConntent(
                  "Nội dung mới ", recordData.newVal);
          listData.add(contentNewItem);
        }
      }
    }

    if (isNotNullOrEmpty(data.fileData)) // list fileData
    {
      List<Files> filesListOld = [];
      List<Files> filesListNew = [];
      for (int i = 0; i < data.fileData.length; i++) {
        int iSize = data.fileData.length;

        for (int j = 0; j < iSize; j++) {
          Files filesOld =
              new Files(data.fileData[j].oldVal, data.fileData[j].oldPath);
          filesListOld.add(filesOld);

          Files filesNew =
              new Files(data.fileData[j].newVal, data.fileData[j].newPath);
          filesListNew.add(filesNew);
        }

        FileData file = data.fileData[i];
        ProdureVersion2ItemModel model =
            new ProdureVersion2ItemModel.nameConntent(file.title, "");
        model.isTextColor = true;
        model.iNumberIndexTableField = i;
        listData.add(model);

        ProdureVersion2ItemModel contentOldItem =
            new ProdureVersion2ItemModel.nameConntent("Nội dung cũ ",
                filesListOld.length == 0 ? "" : filesListOld.length.toString());
        contentOldItem.isShowButton = true;
        contentOldItem.filesList = filesListOld;
        listData.add(contentOldItem);

        ProdureVersion2ItemModel contentNewItem =
            new ProdureVersion2ItemModel.nameConntent("Nội dung mới ",
                filesListNew.length == 0 ? "" : filesListNew.length.toString());
        contentNewItem.filesList = filesListNew;
        contentNewItem.isShowButton = true;
        listData.add(contentNewItem);
        break;
      }
    }

//        listData.add(new ProdureVersion2ItemModel("FieldChildData",""));
    List<ProdureVersion2ItemModel> listNews = [];
    if (isNotNullOrEmpty(data.fieldChildData)) // list getFieldChildData
    {
      for (int i = 0; i < data.fieldChildData.length; i++) {
        List<FieldChildDatum> dataField = data.fieldChildData[i];
        for (int j = 0; j < dataField.length; j++) {
          FieldChildDatum childDatum = dataField[j];

          ProdureVersion2ItemModel model =
              new ProdureVersion2ItemModel.nameConntent(childDatum.title, "");
          model.isTextColor = true;
          model.sIDGroupInfos = childDatum.iDGroup;
          listNews.add(model);

          if (childDatum.type == 4) // type = 4 là file
          {
            if (isNullOrEmpty(childDatum.oldFiles)) {
              ProdureVersion2ItemModel contentOldItem =
                  new ProdureVersion2ItemModel.nameConntent("Nội dung cũ ", "");
              contentOldItem.sIDGroupInfos = childDatum.iDGroup;
              listNews.add(contentOldItem);
            } else {
              ProdureVersion2ItemModel contentOldItem =
                  new ProdureVersion2ItemModel.nameConntent(
                      "Nội dung cũ ",
                      childDatum.oldFiles.length == 0
                          ? ""
                          : childDatum.oldFiles.length.toString());
              contentOldItem.isShowButton = true;
              contentOldItem.filesList = childDatum.oldFiles;
              contentOldItem.sIDGroupInfos = childDatum.iDGroup;
              listNews.add(contentOldItem);
            }

            if (isNullOrEmpty(childDatum.newFiles)) {
              ProdureVersion2ItemModel contentNewItem =
                  new ProdureVersion2ItemModel.nameConntent(
                      "Nội dung mới ", "");
              contentNewItem.sIDGroupInfos = childDatum.iDGroup;
              listNews.add(contentNewItem);
            } else {
              ProdureVersion2ItemModel contentNewItem =
                  new ProdureVersion2ItemModel.nameConntent(
                      "Nội dung mới ",
                      childDatum?.newFiles?.length == 0
                          ? ""
                          : childDatum?.newFiles?.length.toString());
              contentNewItem.isShowButton = true;
              contentNewItem.filesList = childDatum.newFiles;
              contentNewItem.sIDGroupInfos = childDatum.iDGroup;
              listNews.add(contentNewItem);
            }
          } else if (childDatum.type == 5) // type = 5 là textarea
          {
            ProdureVersion2ItemModel contentOldItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung cũ ", childDatum.oldVal);
            contentOldItem.type = "textarea";
            contentOldItem.sIDGroupInfos = childDatum.iDGroup;
            listNews.add(contentOldItem);

            ProdureVersion2ItemModel contentNewItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung mới ", childDatum.newVal);
            contentNewItem.type = "textarea";
            contentNewItem.sIDGroupInfos = childDatum.iDGroup;
            listNews.add(contentNewItem);
          } else if (childDatum.type == 6) // type = 6 là texteditor
          {
            ProdureVersion2ItemModel contentOldItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung cũ ", childDatum.oldVal);
            contentOldItem.type = "texteditor";
            contentOldItem.sIDGroupInfos = childDatum.iDGroup;
            listNews.add(contentOldItem);

            ProdureVersion2ItemModel contentNewItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung mới ", childDatum.newVal);
            contentNewItem.type = "texteditor";
            contentNewItem.sIDGroupInfos = childDatum.iDGroup;
            listNews.add(contentNewItem);
          } else if (childDatum.type == 7) // type = 7 là checkBox
          {
            ProdureVersion2ItemModel contentOldItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung cũ ", childDatum.oldVal);
            contentOldItem.isCheckbox = true;
            contentOldItem.sIDGroupInfos = childDatum.iDGroup;
            listNews.add(contentOldItem);

            ProdureVersion2ItemModel contentNewItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung mới ", childDatum.newVal);
            contentNewItem.isCheckbox = true;
            contentNewItem.sIDGroupInfos = childDatum.iDGroup;
            listNews.add(contentNewItem);
          } else {
            ProdureVersion2ItemModel contentOldItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung cũ ", childDatum.oldVal);
            contentOldItem.sIDGroupInfos = childDatum.iDGroup;
            listNews.add(contentOldItem);

            ProdureVersion2ItemModel contentNewItem =
                new ProdureVersion2ItemModel.nameConntent(
                    "Nội dung mới ", childDatum.newVal);
            contentNewItem.sIDGroupInfos = childDatum.iDGroup;
            listNews.add(contentNewItem);
          }
        }
      }
    }

    if (isNullOrEmpty(data?.groupInfos)) {
      listData.addAll(listNews);
    } else {
      for (int i = 0; i < data.groupInfos.length; i++) {
        List<ProdureVersion2ItemModel> listGroupInfos = [];
        GroupInfos groupInfos = data.groupInfos[i];
        for (int j = 0; j < listNews.length; j++) {
          ProdureVersion2ItemModel itemModel = listNews[j];
          if (groupInfos.iD == itemModel.sIDGroupInfos) {
            listGroupInfos.add(itemModel);
          }
        }

        String name = data.groupInfos[i].name;
        ProdureVersion2ItemModel model =
            new ProdureVersion2ItemModel.nameConntent(name, "");
        model.isShowButton = false;
        model.isTextColor = true;
        model.isCheckGroupInfos = true;
        model.isTextType = true;
        model.listGroupInfos = listGroupInfos;
        listData.add(model);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chi tiết phiên bản hồ sơ"),
        ),
        body: SafeArea(
          child: Container(
            child: _buildList(listData,false),
          ),
        ));
  }

  Widget _buildList(List<ProdureVersion2ItemModel> list,bool isChild) {
    return isNullOrEmpty(list)
        ? Container()
        : ListView.builder(
      shrinkWrap: isChild,
            physics:isChild?NeverScrollableScrollPhysics():null ,
            itemCount: list.length,
            itemBuilder: (context, index) {
              ProdureVersion2ItemModel itemData = list[index];
              Field field;
              if (itemData.type == "texteditor") {
                field = Field();
                field.isReadonly = true;
                field.isRequired = false;
                field.name = itemData.nameField;
                field.value = itemData.content;
              } else if (itemData.type == 'textarea') {
                itemData.content =
                    itemData.content.replaceAll(RegExp(r"\n"), " ");
              }
              Color nameColor;
              if (itemData.isTextColor == true) {
                nameColor = Colors.black;
              } else {
                nameColor = Colors.grey;
              }
              bool isBold = itemData.isTextType == true;
              return InkWell(
                onTap: () {
                  if (itemData.isShowButton != true) return;
                  pushPage(context, VersionFileDetail(itemData.filesList));
                },
                child: WidgetListItem(
                  isShowInRowInList: true,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(itemData?.nameField ?? "",
                                    style: TextStyle(
                                        color: nameColor,
                                        fontWeight: isBold
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                Expanded(
                                    child: Visibility(
                                      visible: itemData.type != "texteditor",
                                      child: Text(
                                        itemData?.content ?? "",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: itemData.isCheckbox == true
                                                ? Colors.transparent
                                                : Colors.grey),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: itemData.type == "texteditor",
                              child: SingleFieldTextEditorWidget(
                                field,
                                true,
                                true,
                                verticalPadding: 0,
                              )),
                          Visibility(
                              visible: itemData.isShowButton == true,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.black.withAlpha(120),
                                ),
                              )),
                          Visibility(
                              visible: itemData.isCheckbox == true,
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                  value: itemData.content == "1",
                                ),
                              )),
                        ],
                      ),
                      Visibility(
                          visible: itemData.isCheckGroupInfos == true,
                          child: isNullOrEmpty(itemData.listGroupInfos)
                              ? Container()
                              : _buildList(itemData.listGroupInfos,true))
                    ],
                  ),
                ),
              );
            },
          );
  }
}
