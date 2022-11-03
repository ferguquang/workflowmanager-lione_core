import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/procedures/models/response/FCFileModel.dart';
import 'package:workflow_manager/procedures/models/response/data_register_save_response.dart';
import 'package:workflow_manager/procedures/models/response/data_signature_list_response.dart';
import 'package:workflow_manager/procedures/models/response/field_table_list.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/list_position_dept_selected_model.dart';
import 'package:workflow_manager/procedures/models/response/list_table_item_model.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/models/response/register_create_response.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/models/response/star.dart';
import 'package:workflow_manager/procedures/models/response/step_template_file.dart';
import 'package:workflow_manager/procedures/models/response/uploaded_file.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/event_reload_detail_procedure.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/assign_widget/assign_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/rating_screen.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/group_table_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/table_field_widget.dart';
import 'package:workflow_manager/procedures/widgets/pdf/signal_screen.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';
import 'package:workflow_manager/workflow/screens/details/flow_chart.dart';

import '../../../../main.dart';
import '../step_widget.dart';
import 'info_work_follow_repository.dart';

class InfoWorkFollowScreen extends StatefulWidget {
  int idService;
  bool isReadonly;
  bool isUpdate;
  bool isAddInSendCol =
      false; // để biết được khi nào thì add item của ẩn/hiện cột
  ListTableItemModel itemTableAdd;
  ListTableItemModel itemAddInSendCol;
  bool isViewInOneRow;

  InfoWorkFollowScreen(
      this.idService, this.isReadonly, this.isUpdate, this.isViewInOneRow);

  @override
  State<StatefulWidget> createState() {
    return _InfoWorkFollowScreenState();
  }
}

class _InfoWorkFollowScreenState extends State<InfoWorkFollowScreen>
    with TickerProviderStateMixin {
  InfoWorkFollowRepository _infoWorkFollowRepository =
      InfoWorkFollowRepository();
  double _padding = 16;
  List<TableFieldWidget> _tableFieldWidget = [];
  GroupTableFieldWidget _groupTableFieldWidget;
  AssignWidget _assignWidget;
  SingleFieldWidget _singleFieldWidget;

  GlobalKey<SingleFieldWidgetState> _singleFieldKey = GlobalKey();
  GlobalKey _stepKey = GlobalKey();
  GlobalKey _assignKey = GlobalKey();
  TextEditingController _titleController = TextEditingController();
  bool isFirst = true;

  StreamSubscription _registerStream;

  @override
  void initState() {
    _infoWorkFollowRepository.loadData(widget.idService, widget.isUpdate);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSingleFieldWidget()?.sendTableColListener = _tableFieldWidget;

      if (_registerStream != null) _registerStream.cancel();
      _registerStream =
          eventBus.on<EventReloadDetailProcedure>().listen((event) {
        // khi giải quyết hồ sơ thành công (khi ký thành công sẽ vào đây)
        if (event.isFinish) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (event?.response?.status == 1) {
              backAll(event?.response?.data);
              showSuccessToast("Thêm mới hồ sơ thành công");
            }
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_registerStream != null) _registerStream.cancel();
  }

  SingleFieldWidget getSingleFieldWidget() {
    return _singleFieldWidget;
  }

  backAll(data) {
    (_stepKey.currentState as StepWidgetState).backAll(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isUpdate ? "Cập nhật hồ sơ đăng ký" : "Đăng ký hồ sơ"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ChangeNotifierProvider.value(
          value: _infoWorkFollowRepository,
          child: Consumer(
            builder: (context,
                InfoWorkFollowRepository infoWorkFollowRepository, child) {
              RegisterCreateModel registerCreateModel =
                  _infoWorkFollowRepository?.registerCreateModel;
              if (isFirst && registerCreateModel != null) {
                if (isNullOrEmpty(registerCreateModel.groupInfos)) {
                  _tableFieldWidget = [];
                  for (TableFieldInfo tableList
                      in registerCreateModel?.fieldTableList?.tableFieldInfos) {
                    _tableFieldWidget.add(TableFieldWidget(
                      tableList?.fields ?? [],
                      widget.isReadonly,
                      getSingleFieldWidget()?.onFieldEditted,
                      isAdd: tableList.isAdd,
                      isDelete: tableList.isDelete,
                      indexTitle: tableList.id,
                      iDTable: tableList.iDTable,
                      tableName: tableList.name,
                    ));
                  }
                } else {
                  _groupTableFieldWidget = GroupTableFieldWidget(
                      registerCreateModel?.tableFields,
                      widget.isReadonly,
                      null,
                      registerCreateModel.groupInfos);
                }
                _singleFieldWidget = SingleFieldWidget(
                  registerCreateModel?.singleFields ?? [],
                  isReadonly: widget.isReadonly == true,
                  key: _singleFieldKey,
                  isViewInOneRow: widget.isViewInOneRow,
                );
                if (isNotNullOrEmpty(registerCreateModel.groupInfos)) {
                  _singleFieldWidget?.sendTableColListener = _tableFieldWidget;
                  _groupTableFieldWidget.onFieldEditted =
                      _singleFieldWidget.onFieldEditted;
                } else {
                  _singleFieldWidget?.sendTableColListener = _tableFieldWidget;
                  _tableFieldWidget.forEach((e) =>
                      e.onFieldEditted = _singleFieldWidget.onFieldEditted);
                }
              }
              if (isFirst &&
                  _infoWorkFollowRepository?.registerCreateModel != null) {
                _assignWidget = AssignWidget(
                  registerCreateModel,
                  widget.isViewInOneRow,
                  globalKey: _assignKey,
                );
                isFirst = false;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: !widget.isUpdate,
                      child: StepWidget(
                        2,
                        _stepKey,
                        isUpdate: widget.isUpdate,
                      )),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: getColor("#F2F2F2"),
                          padding: EdgeInsets.all(_padding),
                          child: Text(
                            "THÔNG TIN THỦ TỤC ĐĂNG KÝ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              _buildHeadRow(registerCreateModel),
                              _buildRowInput(registerCreateModel),
                              _buildRowAttachFiles(registerCreateModel),
                              _buildRowFileTemplates(registerCreateModel),
                              _singleFieldWidget ?? Container(),
                              Divider(
                                height: 8,
                                color: getColor("#F2F2F2"),
                                thickness: 8,
                              ),
                              Padding(
                                  padding: EdgeInsets.all(_padding),
                                  child: _groupTableFieldWidget ??
                                          isNotNullOrEmpty(_tableFieldWidget)
                                      ? ListView(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: _tableFieldWidget,
                                        )
                                      : Container()),
                              _assignWidget ?? Container(),
                              SaveButton(
                                title: "Hoàn thành",
                                margin: EdgeInsets.only(
                                    bottom: _padding,
                                    left: _padding,
                                    right: _padding),
                                onTap: donePress,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  donePress() async {
    // if (isNotNullOrEmpty(getSingleFieldWidget().errorMessage)) {
    //   showErrorToast(getSingleFieldWidget().errorMessage);
    //   return;
    // }
    List<String> listNumberTypes = ["number", "fcnumber"];
    FocusScope.of(context).unfocus();
    Map<String, dynamic> params = Map();
    if (widget.isUpdate == true) {
      params["ID"] = widget.idService;
    } else {
      params["IDService"] = widget.idService;
    }
    if (isNullOrEmpty(_titleController.text)) {
      showErrorToast("Tiêu đề không được để trống");
      return;
    }
    await _singleFieldKey.currentState.setValueForAllField();
    print("___________chay sau nay");
    params["Name"] = _titleController.text;
    params["Priority"] =
        _infoWorkFollowRepository.isHighPriority == true ? 1 : 0;

    // file name, path và IsSignFile_{Path} của file trình ký (nếu có) của file đính kèm khác
    String sendFileName = "", sendFilePath = "", sendFilePathTrinhKy = "";
    bool isUpdate = widget.isUpdate == true;
    List<String> listFileName = [];
    List<String> listFilePath = [];
//                List<String> listFileTrinhKy = [];
    List<String> listIDFileKeep = []; // danh sách file đã có
    List<FileTemplate> attachFileModels =
        _infoWorkFollowRepository.registerCreateModel.attachedFiles;
    if (attachFileModels.length == 1) // ds file đính kèm khác chỉ có 1 file
    {
      sendFileName = attachFileModels[0].getFileName();
      sendFilePath = attachFileModels[0].path;

      // bỏ "/Storage/Files/" trong file path (nếu có)
      if (sendFilePath.contains("/Storage/Files/")) {
        List<String> pathArray = sendFilePath.split("/Storage/Files/");
        if (pathArray.length > 0) {
          sendFilePath = pathArray[pathArray.length - 1];
        }
      }

      // lưu file trinh ky - 1 file
      if (_infoWorkFollowRepository
                  .registerCreateModel.isEnableAttachSignFile ==
              true &&
          attachFileModels[0].isSignFile == true) {
        sendFilePathTrinhKy = "IsSignFile_" + sendFilePath;
        params[sendFilePathTrinhKy] = "1";
      }

      if (widget.isUpdate) {
        if (attachFileModels[0].isKeep == true) {
          params["IDServiceInfoFile"] = attachFileModels[0].iD;
        }
      }
    } else // ds file đính kèm khác có nhiều file
    {
      for (int i = 0; i < attachFileModels.length; i++) {
        String filePath = attachFileModels[i].path;

        // bỏ "/Storage/Files/" trong file path (nếu có)
        if (filePath.contains("/Storage/Files/")) {
          List<String> pathArray = filePath.split("/Storage/Files/");
          if (pathArray.length > 0) {
            filePath = pathArray[pathArray.length - 1];
          }
        }

        listFileName.add("\"" + attachFileModels[i]?.getFileName() + "\"");
        listFilePath.add("\"" + filePath + "\"");

        // lưu file trinh ky - nhiều file
        if (_infoWorkFollowRepository
                    .registerCreateModel.isEnableAttachSignFile ==
                true &&
            attachFileModels[i].isSignFile == true) {
          sendFilePathTrinhKy = "IsSignFile_" + filePath;
          params[sendFilePathTrinhKy] = "1";
        }

        if (isUpdate) {
          if (attachFileModels[i].isKeep == true) {
            listIDFileKeep.add(attachFileModels[i].iD.toString());
          }
        }
      }

      if (isNotNullOrEmpty(listFileName)) {
        sendFileName = "[" + listFileName.join(", ") + "]";
      }
      if (isNotNullOrEmpty(listFilePath)) {
        sendFilePath = "[" + listFilePath.join(", ") + "]";
      }
      print("XsendFileName = ${sendFileName}");
      if (isUpdate) {
        String sendIDServiceInfoFile = "[" + listIDFileKeep.join(", ") + "]";
        params["IDServiceInfoFile"] = sendIDServiceInfoFile;
      }
    }
    if (isUpdate && attachFileModels.length >= 1) {
      params["FileName"] = sendFileName;
      params["FilePath"] = sendFilePath;
    } else if (!isUpdate && attachFileModels.length >= 1) {
      params["FileName"] = sendFileName;
      params["FilePath"] = sendFilePath;
    }

    // lấy filename, path của d/s file template:
    List<StepTemplateFile> fileTemplates =
        _infoWorkFollowRepository.registerCreateModel.fileTemplates;
    for (int i = 0; i < fileTemplates.length; i++) {
      String fileTemplateName =
          fileTemplates[i]?.uploadedFile?.uploadedFileName;
      if (fileTemplates[i].isRequired == true) {
        if (isNullOrEmpty(fileTemplateName)) {
          showErrorToast(
              "Biểu mẫu " + fileTemplates[i].name + " cần có file đính kèm");
          return;
        }
      }

      String fileTemplatePath = fileTemplates[i].uploadedFile.uploadedFilePath;
      if (fileTemplatePath.contains("/Storage/Files/")) {
        List<String> pathArray = fileTemplatePath.split("/Storage/Files/");
        if (pathArray.length > 0) {
          fileTemplatePath = pathArray[pathArray.length - 1];
        }
      }

      params["FileName" + fileTemplates[i].iD.toString()] = fileTemplateName;
      params["FilePath" + fileTemplates[i].iD.toString()] = fileTemplatePath;

      if (fileTemplates[i].isKeep == true) {
        params["IDServiceInfoFile" + fileTemplates[i].iD.toString()] =
            fileTemplates[i].uploadedFile.iD.toString();
      }
    }
    List<User> listUserSelected = _assignWidget.getSelectedUsers();
    if (listUserSelected == null) listUserSelected = [];
    List<String> listIDUser = [];
    for (int i = 0; i < listUserSelected.length; i++) {
      listIDUser.add(listUserSelected[i].iD.toString());
    }
    if (listUserSelected.length >= 1) {
      params["IDUser"] = listIDUser.join(", ");
    }
    List<HandlerInfo> listDeptSelected = _assignWidget.getSelectedDepts();
    if (listDeptSelected == null) listDeptSelected = [];
    List<String> listIDDept = [];
    for (int i = 0; i < listDeptSelected.length; i++) {
      listIDDept.add(listDeptSelected[i].iD.toString());
    }
    if (listDeptSelected.length >= 1) {
      params["IDDept"] = listIDDept.join(", ");
    }
    List<HandlerInfo> listGroupSelected = _assignWidget.getSelectedTeams();
    if (listGroupSelected == null) listGroupSelected = [];
    List<String> listIDGroup = [];
    for (int i = 0; i < listGroupSelected.length; i++) {
      listIDGroup.add(listGroupSelected[i].iD.toString());
    }
    if (listGroupSelected.length >= 1) {
      params["IDTeam"] = listIDGroup.join(", ");
    }

    // IDPosition và (DeptofIDPosition + ID Position) vd: DeptofIDPosition345
    List<ListPositionDeptSelectedModel> listPositionDeptSelectedModels =
        _assignWidget.getSelectedPositionAndDepts();
    if (listPositionDeptSelectedModels == null)
      listPositionDeptSelectedModels = [];
    List<String> listIDPositionSelected = [];
    for (int i = 0; i < listPositionDeptSelectedModels.length; i++) {
      Position positionSelected =
          listPositionDeptSelectedModels[i].positionSelected;
      listIDPositionSelected.add(positionSelected.iD.toString());

      List<String> deptToIDPosition = [];
      for (int a = 0;
          a < listPositionDeptSelectedModels[i].listDeptSelected.length;
          a++) {
        HandlerInfo deptSelected =
            listPositionDeptSelectedModels[i].listDeptSelected[a];
        deptToIDPosition.add(deptSelected.iD.toString());
        params["DeptofIDPosition" + positionSelected.iD.toString()] =
            deptToIDPosition.join(", ");
      }
    }

    if (listIDPositionSelected.length > 0) {
      params["IDPosition"] = listIDPositionSelected.join(", ");
    }
    List<ListTableItemModel> listTableItem = [];
    if (_infoWorkFollowRepository.isCheckGroupInfos == true) {
      listTableItem = _groupTableFieldWidget.listTableItem;
    } else {
      listTableItem = [];
      _tableFieldWidget.forEach((element) {
        listTableItem.addAll(element.listTableItem);
      });
    }
    // dữ liệu trong bảng //todo ko đc xóa
    String listIntString = "";
    if (_infoWorkFollowRepository.isCheckGroupInfos == true) {
      List<Field> tableFields =
          _infoWorkFollowRepository.registerCreateModel.tableFields;
      bool isCheckValidate =
          addParamsFromTableField(params, listTableItem, tableFields);
      if (isCheckValidate == false) return;
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
      bool isCheckValidate = true;
      for (TableFieldWidget widget in _tableFieldWidget) {
        isCheckValidate = addParamsFromTableField(
            params, widget.listTableItem, widget.listField);
        if (isCheckValidate == false) break;
      }
      if (isCheckValidate == false) {
        return;
      }

      params["IDTable"] = '[${listIDTable.join(",")}]';
    }
    // điều kiện dành cho GroupInfos
    if (_infoWorkFollowRepository.isCheckGroupInfos == true) {
      List<String> listValueColumn = [];
      for (int row = 0; row < listTableItem.length; row++) {
        String value = listTableItem[row].getFieldList()[0].groupValues[0];
        listValueColumn.add("\"" + value + "\"");
      }
      if (isNotNullOrEmpty(listValueColumn)) {
        params["IDGroup"] = "[" + listValueColumn.join(",") + "]";
      }
    }

    List<Field> singleFields =
        _infoWorkFollowRepository.registerCreateModel.singleFields;
    for (int i = 0; i < singleFields.length; i++) // code chỉnh sửa
    {
      if (singleFields[i].type == "file" || singleFields[i].type == "fcfile") {
        String key = singleFields[i].key;
        String value = singleFields[i].value;
        List<FCFileModel> fileModels = [];
        if (isNotNullOrEmpty(value)) {
          var json = jsonDecode(value);
          if (isNotNullOrEmpty(json)) {
            json.forEach((v) {
              fileModels.add(FCFileModel.fromJson(v));
            });
          }
        }
        List<String> fileNameSingles = [];
        List<String> filePathSingles = [];
        if (fileModels != null) {
          for (int a = 0; a < fileModels.length; a++) {
            String fileName = fileModels[a].fileName;
            String filePath = fileModels[a].filePath;

            fileNameSingles.add("\"" + fileName + "\"");
            filePathSingles.add("\"" + filePath + "\"");
          }
          if (isNotNullOrEmpty(fileNameSingles)) {
            String valueNameSingles = "[" + fileNameSingles.join(", ") + "]";
            params[key + "_N"] = valueNameSingles;
          }
          if (isNotNullOrEmpty(filePathSingles)) {
            String valuePathSingles = "[" + filePathSingles.join(", ") + "]";
            params[key + "_P"] = valuePathSingles;
          }
        }
      } else {
        String key = singleFields[i].key;
        String value = singleFields[i].value;
        if (!singleFields[i].isHidden == true) {
          if (singleFields[i].isRequired == true && isNullOrEmpty(value)) {
            showErrorToast(
                "Trường " + singleFields[i].name + " cần bắt buộc!!!");
            return;
          }
        }
        if (singleFields[i].isMoney) {
          value = value.replaceAll(Constant.SEPARATOR_THOUSAND, "");
        }
        if (listNumberTypes.contains(singleFields[i].type)) {
          value = convertDoubleToInt(value);
        }
        params[key] = value;
      }
    }

    if (isUpdate) {
      params["IDService"] = _infoWorkFollowRepository.registerCreateModel.iD;
      var json = await ApiCaller.instance
          .postFormData(AppUrl.getQTTTRegisterChange, params);
      DataRegisterSaveResponse response = DataRegisterSaveResponse.fromJson(json);
      if (response.status == 1) {
        if (response.data.isSigned) {
          params["IDServiceRecordTemplateExport"] =
              response.data.iDServiceRecordTemplateExport;
          params["PdfPath"] = response.data.serviceInfoFile.path;
          params["FieldIndexCreate"] = listIntString;
          FileTemplate signalFile = FileTemplate(
              name: response.data?.serviceInfoFile?.name,
              path: "/Storage/Files/" + response.data?.serviceInfoFile?.path,
              signPath:
              "/Storage/Files/" + response.data?.serviceInfoFile?.path,
              extension: response.data?.serviceInfoFile?.extension);
          SignatureLocation signatureLocation;
          if (response?.data?.serviceFormStepSignConfig != null &&
              response?.data?.serviceFormStepSignConfig?.iD > 0) {
            signatureLocation = SignatureLocation();
            signatureLocation.page =
                response.data.serviceFormStepSignConfig.page;
            signatureLocation.height =
                response.data.serviceFormStepSignConfig.height;
            signatureLocation.width =
                response.data.serviceFormStepSignConfig.width;
            signatureLocation.pageHeight =
                response.data.serviceFormStepSignConfig.pageHeight;
            signatureLocation.pageWidth =
                response.data.serviceFormStepSignConfig.pageWidth;
            signatureLocation.signPage =
                response.data.serviceFormStepSignConfig.signPage;
            signatureLocation.totalPage =
                response.data.serviceFormStepSignConfig.totalPage;
            signatureLocation.x = response.data.serviceFormStepSignConfig.x;
            signatureLocation.y = response.data.serviceFormStepSignConfig.y;
          }
          DataRegisterSaveResponse responseSignal = await pushPage(
              context,
              SignalScreen(
                signalFile,
                response.data?.serviceRecord?.iD,
                "Ký ngay khi ký",
                signatureLocation: signatureLocation,
                signatures: response.data.userSignatures,
                paramsRegitster: params,
                action: response.data.action,
                iDGroupPdfForm: response.data.iDGroup.toString(),
              ));
        } else {
          showSuccessToast(response.messages);
          Navigator.pop(context, response);
          Navigator.pop(context);
        }
      } else {
        showErrorToast(response.messages);
      }
    } else {
      params["IDService"] = widget.idService.toString();
      var json = await ApiCaller.instance
          .postFormData(AppUrl.getQTTTRegisterSave, params);
      DataRegisterSaveResponse response =
          DataRegisterSaveResponse.fromJson(json);
      if (response.status == 1) {
        if (response.data.isSigned == true) {
          params["IDServiceRecordTemplateExport"] =
              response.data.iDServiceRecordTemplateExport;
          params["PdfPath"] = response.data.serviceInfoFile.path;
          params["FieldIndexCreate"] = listIntString;
          FileTemplate signalFile = FileTemplate(
              name: response.data?.serviceInfoFile?.name,
              path: "/Storage/Files/" + response.data?.serviceInfoFile?.path,
              signPath:
                  "/Storage/Files/" + response.data?.serviceInfoFile?.path,
              extension: response.data?.serviceInfoFile?.extension);
          SignatureLocation signatureLocation;
          if (response?.data?.serviceFormStepSignConfig != null &&
              response?.data?.serviceFormStepSignConfig?.iD > 0) {
            signatureLocation = SignatureLocation();
            signatureLocation.page =
                response.data.serviceFormStepSignConfig.page;
            signatureLocation.height =
                response.data.serviceFormStepSignConfig.height;
            signatureLocation.width =
                response.data.serviceFormStepSignConfig.width;
            signatureLocation.pageHeight =
                response.data.serviceFormStepSignConfig.pageHeight;
            signatureLocation.pageWidth =
                response.data.serviceFormStepSignConfig.pageWidth;
            signatureLocation.signPage =
                response.data.serviceFormStepSignConfig.signPage;
            signatureLocation.totalPage =
                response.data.serviceFormStepSignConfig.totalPage;
            signatureLocation.x = response.data.serviceFormStepSignConfig.x;
            signatureLocation.y = response.data.serviceFormStepSignConfig.y;
          }
          DataRegisterSaveResponse responseSignal = await pushPage(
              context,
              SignalScreen(
                signalFile,
                response.data?.serviceRecord?.iD,
                "Ký ngay khi ký",
                signatureLocation: signatureLocation,
                signatures: response.data.userSignatures,
                paramsRegitster: params,
                iDGroupPdfForm: response.data.iDGroup.toString(),
              ));
        } else {
          backAll(response.data);
          showSuccessToast("Thêm mới hồ sơ thành công");
        }
      } else {
        showErrorToast(response.isDefaultMesasge
            ? "Thêm mới hồ sơ thất bại"
            : response.messages);
      }
    }
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
        if (tableFields[column].isRequired == true) {
          showErrorToast("Bảng dữ liệu không được để trống");
          return false;
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

  Widget _buildHeadRow(RegisterCreateModel registerCreateModel) {
    return Container(
      padding: EdgeInsets.all(_padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 8, bottom: 8, right: 8),
              width: 40,
              height: 40,
              child: SVGImage(svgName: "register_type")),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        registerCreateModel?.name ?? "",
                      ),
                    ),
                    Container(
                      width: 70,
                      child: FittedBox(
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Star star = _infoWorkFollowRepository
                                .registerCreateModel.star;
                            pushPage(context, RatingScreen(star));
                          },
                          child: RatingBarIndicator(
                            // custom gì thì custom hết ở đây
                            rating: registerCreateModel?.star?.star ?? 0.0,
                            itemCount: 5,
                            itemPadding: EdgeInsets.all(0),
                            direction: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      size: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Text(
                      registerCreateModel?.code ?? "",
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      size: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Expanded(
                      child: Text(
                        registerCreateModel?.typeName ?? "",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        pushPage(
                            context,
                            FlowChart(await SharedPreferencesClass.get(
                                    SharedPreferencesClass.ROOT_KEY) +
                                _infoWorkFollowRepository
                                    .registerCreateModel.urlFlowChart +
                                "&Token=${await SharedPreferencesClass.getToken()}"));
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: getColor("#73A947")),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                                size: 16,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4),
                              ),
                              Text(
                                "Lưu đồ",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowInput(RegisterCreateModel registerCreateModel) {
    _titleController.text = registerCreateModel?.recordName ?? "";
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Tiêu đề", style: TextStyle(color: Colors.black)),
              TextSpan(text: "*", style: TextStyle(color: Colors.red))
            ]),
          ),
          TextField(
            controller: _titleController,
            onChanged: (value) {
              registerCreateModel?.recordName = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("Mức độ"),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _infoWorkFollowRepository.setHightPriority(false);
                    },
                    child: Row(children: [
                      Container(
                        width: 20,
                        height: 20,
                        child: Radio(
                          value:
                              _infoWorkFollowRepository.isHighPriority == false,
                          activeColor: Colors.blue,
                          groupValue: true,
                        ),
                      ),
                      Text(
                        "Thông thường",
                        style: TextStyle(
                            color: _infoWorkFollowRepository.isHighPriority ==
                                    false
                                ? Colors.blue
                                : Colors.grey),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _infoWorkFollowRepository.setHightPriority(true);
                  },
                  child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                          width: 20,
                          height: 20,
                          child: Radio(
                              groupValue: true,
                              value: _infoWorkFollowRepository.isHighPriority ==
                                  true,
                              activeColor: Colors.blue)),
                      Text(
                        "Quan trọng",
                        style: TextStyle(
                            color:
                                _infoWorkFollowRepository.isHighPriority == true
                                    ? Colors.blue
                                    : Colors.grey),
                      )
                    ],
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowFileTemplates(RegisterCreateModel registerCreateModel) {
    var fileTemplates = registerCreateModel?.fileTemplates;
    if (isNotNullOrEmpty(fileTemplates)) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: _padding, vertical: 8),
        child: StatefulBuilder(
          builder: (context, setState) {
            return ListView.builder(
              itemCount: fileTemplates.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                StepTemplateFile stepTemplateFile = fileTemplates[index];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(stepTemplateFile?.name ?? "")),
                              Visibility(
                                visible: stepTemplateFile.isRequired == true &&
                                    !widget.isReadonly == true,
                                child: Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: !(stepTemplateFile?.uploadedFile?.iD !=
                                        0 &&
                                    stepTemplateFile?.uploadedFile?.isSigned ==
                                        true),
                                child: InkWell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 35,
                                        width: 35,
                                        child: Icon(isNullOrEmpty(
                                                stepTemplateFile?.uploadedFile
                                                    ?.uploadedFileName)
                                            ? Icons.add_circle_outline_rounded
                                            : Icons.remove_circle_outline)),
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      if (isNullOrEmpty(stepTemplateFile
                                          ?.uploadedFile?.uploadedFileName)) {
                                        UploadModel file = await FileUtils
                                            .instance
                                            .uploadFileFromSdcard(context);
                                        if (file != null) {
                                          stepTemplateFile.uploadedFile =
                                              UploadedFile(
                                                  uploadedFileName:
                                                      file.fileName,
                                                  uploadedFilePath:
                                                      file.filePath);
                                          setState(() {});
                                        } else {
                                          // showErrorToast("Tải file thất bại.");
                                        }
                                      } else {
                                        showConfirmDialog(context,
                                            "Bạn có muốn xóa file này?", () {
                                          stepTemplateFile.uploadedFile = null;
                                          setState(() {});
                                        });
                                      }
                                    }),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    String path = stepTemplateFile
                                        .uploadedFile.uploadedFilePath;
                                    FileUtils.instance.downloadFileAndOpen(
                                        stepTemplateFile
                                            .uploadedFile.uploadedFileName,
                                        path,
                                        context);
                                  },
                                  child: Text(
                                    stepTemplateFile
                                            ?.uploadedFile?.uploadedFileName ??
                                        "",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: stepTemplateFile?.path != null,
                      child: InkWell(
                        onTap: () async {
                          FocusScopeNode focus = FocusScope.of(context);
                          focus.unfocus();
                          if (stepTemplateFile?.path == null) return;
                          // String root = await SharedPreferencesClass.get(
                          //     SharedPreferencesClass.ROOT_KEY);
                          String filePath = stepTemplateFile.path;
                          String fileName = stepTemplateFile.name;
                          FileUtils.instance
                              .downloadFileAndOpen(fileName, filePath, context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 16),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.download_outlined,
                                color: Colors.grey,
                              ),
                              Text("Tải mẫu")
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              border: Border.all(color: getColor("#F2F2F2"))),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      );
    }
    return Container();
  }

  Widget _buildRowAttachFiles(RegisterCreateModel registerCreateModel) {
    return Column(children: [
      Container(
        width: double.infinity,
        color: getColor("#F2F2F2"),
        padding: EdgeInsets.all(_padding),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "File đính kèm",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Visibility(
              visible: widget.isReadonly == false,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: getColor("#787878")),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Text("Đính kèm khác"),
                ),
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  var result =
                      await FileUtils.instance.uploadFileFromSdcard(context);
                  if (result != null) {
                    if (registerCreateModel != null) {
                      _infoWorkFollowRepository.addAttachFile(result);
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: registerCreateModel?.attachedFiles?.length ?? 0,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        FileUtils.instance.downloadFileAndOpen(
                            registerCreateModel?.attachedFiles[index]
                                    ?.getFileName() ??
                                "",
                            registerCreateModel?.attachedFiles[index]?.path,
                            context);
                      },
                      child: Text(
                        registerCreateModel?.attachedFiles[index]
                                ?.getFileName() ??
                            "",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        registerCreateModel?.isEnableAttachSignFile == true,
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        registerCreateModel?.attachedFiles[index].isSignFile =
                            !registerCreateModel
                                ?.attachedFiles[index].isSignFile;
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Trình ký",
                            textAlign: TextAlign.end,
                          ),
                          Container(
                            height: 25,
                            margin: EdgeInsets.only(left: 8),
                            width: 25,
                            child: Checkbox(
                              value: registerCreateModel
                                      ?.attachedFiles[index].isSignFile ==
                                  true,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 16,
                        )),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      ConfirmDialogFunction confirmDialogFunction =
                          ConfirmDialogFunction(
                        context: context,
                        content: "Bạn có muốn xóa file này không?",
                        onAccept: () {
                          _infoWorkFollowRepository.removeAttachFile(index);
                        },
                      );
                      confirmDialogFunction.showConfirmDialog();
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
      Divider(
        height: 2,
        thickness: 2,
        color: getColor("#E7E7E7"),
      )
    ]);
  }
}

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
