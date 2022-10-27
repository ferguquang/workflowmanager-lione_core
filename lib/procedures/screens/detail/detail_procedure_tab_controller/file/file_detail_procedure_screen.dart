import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/params/save_info_fs_request.dart';
import 'package:workflow_manager/procedures/models/response/file_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/models/response/step_template_file.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/add_file/add_file_dialog.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/all_file_attach_item.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/sign_file_item.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/step_template_file_item.dart';
import 'package:workflow_manager/procedures/screens/detail/header_detail_procedure/action/event_reload_detail_procedure.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/list_resolve_screen.dart';
import 'package:workflow_manager/procedures/widgets/pdf/signal_screen.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';
//

class FileDetailProcedureScreen extends StatefulWidget {
  DataProcedureDetail dataProcedureDetail;
  int type, state;

  FileDetailProcedureScreen(this.dataProcedureDetail, this.type, this.state);

  @override
  _FileDetailProcedureScreenState createState() => _FileDetailProcedureScreenState();
}

class _FileDetailProcedureScreenState extends State<FileDetailProcedureScreen> {
  DataProcedureDetail data;

  @override
  void initState() {
    super.initState();
    data = widget.dataProcedureDetail;
  }

  @override
  Widget build(BuildContext context) {
    data = widget.dataProcedureDetail;
    return ListView(
      shrinkWrap: true,
      children: [
        _allFileAttachLayout(
            allAttachedFiles: data.allAttachedFiles, contextt: context),
        isNotNullOrEmpty(data.currentStep) &&
                isNotNullOrEmpty(data.currentStep.stepTemplateFiles)
            ? _fileCurrentStepLayout(
                stepTemplateFiles: data.currentStep.stepTemplateFiles)
            : SizedBox(),
        isNotNullOrEmpty(data.signFiles)
            ? _signFileLayout(signFiles: data.signFiles)
            : SizedBox(),
        // _allFileAttachLayout(),
        // _fileCurrentStepLayout(),
        // _signFileLayout()
      ],
    );
  }

  Widget _allFileAttachLayout({List<AllAttachedFiles> allAttachedFiles, BuildContext contextt}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${allAttachedFiles?.length ?? 0} file đính kèm"),
                Visibility(
                  visible: widget.type == DetailProcedureScreen.TYPE_RESOLVE && widget.state == ListResolveScreen.TYPE_PENDING,
                  // visible: true,
                  child: InkWell(
                    onTap: () async {
                      List<AllAttachedFiles> listFiles = await pushPage(contextt, AddFileProcedureDialog(
                        idHoSo: data.iDServiceRecord,
                        isEnableAttachSignFile: data.isEnableAttachSignFile,
                      ));

                      setState(() {
                        data.allAttachedFiles.addAll(listFiles);
                      });
                    },
                    child: Container(
                      width: 70,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4),
                      child:
                          Text("Thêm +", style: TextStyle(color: Colors.black)), // todo code Form đăng ký hồ sơ
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(color: Colors.grey[200]),
        ),
        ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: allAttachedFiles?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return AllFileAttachItem(
              model: allAttachedFiles[index],
              onDownloadFile: (item) async {
                // String root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
                String url = "${item.path}";
                FileUtils.instance.downloadFileAndOpen(item.name, url, context, isOpenFile: false);
              },
              onViewFile: (item) async {
                // String root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
                String url = "${item.path}";
                FileUtils.instance.downloadFileAndOpen(item.name, url, context);
              },
              onDeleteFile: (item) {
                recordRemoveInfoFs(item, allAttachedFiles);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        )
      ],
    );
  }

  Widget _fileCurrentStepLayout({List<StepTemplateFile> stepTemplateFiles}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${stepTemplateFiles?.length} file hiện tại"),
                // Text("3 file hiện tại"),
              ],
            ),
          ),
          decoration: BoxDecoration(color: Colors.grey[200]),
        ),
        ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: stepTemplateFiles.length,
          itemBuilder: (BuildContext context, int index) {
            return StepTemplateFileItem(
              stepTemplateFile: stepTemplateFiles[index],
              onUploadOrDeleteFile: (StepTemplateFile item) {
                if (item.isAdd) {
                  _addStepTempleFile(item, context, index);
                } else {
                  ConfirmDialogFunction(
                      context: context,
                      content: "Bạn có muốn xóa file này không?",
                      onAccept: () {
                        _removeStepTempleFile(item, index);
                      }).showConfirmDialog();
                }
              },
              onDownloadFile: (StepTemplateFile item) {
                String url = "${item.path}";
                FileUtils.instance.downloadFileAndOpen(item.name, url, context, isOpenFile: false);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        )
      ],
    );
  }

  Widget _signFileLayout({List<FileTemplate> signFiles}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${signFiles.length} file trình ký"),
                // Text("6 file trình ký"),
              ],
            ),
          ),
          decoration: BoxDecoration(color: Colors.grey[200]),
        ),
        ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: signFiles.length,
          itemBuilder: (BuildContext context, int index) {
            return SignFileItem(
              model: signFiles[index],
              onSignFile: (FileTemplate item) async{
              await  pushPage(
                    context,
                    SignalScreen(
                        item, widget.dataProcedureDetail.iDServiceRecord, widget.dataProcedureDetail.title));
                // context.findAncestorStateOfType<DetailProcedureScreenState>().reloadDetail();
              },
              onViewFile: (FileTemplate item) {
                String url = "${item.path}";
                FileUtils.instance.downloadFileAndOpen(item.name, url, context);
              },
              onDownloadFile: (FileTemplate item) {
                String url = "${item.path}";
                FileUtils.instance.downloadFileAndOpen(item.name, url, context, isOpenFile: false);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        )
      ],
    );
  }

  Future<void> recordRemoveInfoFs(AllAttachedFiles model, List<AllAttachedFiles> allAttachedFiles) async {
    RemoveInfoFsRequest request = RemoveInfoFsRequest();
    request.id = model.iD;
    var response = await ApiCaller.instance.postFormData(AppUrl.recordRemoveInfoFs, request.getParams());
    ResponseMessage responseMessage = ResponseMessage.fromJson(response);

    setState(() {
      data.allAttachedFiles.removeWhere((element) => element.iD == model.iD);
    });

    ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
  }

  Future<void> _addStepTempleFile(StepTemplateFile item, BuildContext context, int index) async {
    var file = await FileUtils.instance.uploadFileFromSdcard(context);
    if (file != null) {
      item.uploadedFile.uploadedFileName = file.fileName;
      item.uploadedFile.uploadedFilePath = file.filePath;

      Map<String, dynamic> params = Map();
      params["ID"] = data.iDServiceRecord;
      params["FileName${item.iD}"] = file.fileName;
      params["FilePath${item.iD}"] = file.filePath;
      params["IDFileSample"] = item.iD;

      var json = await ApiCaller.instance.postFormData(AppUrl.recordSaveInfoStepFs, params);
      RecordSaveInfoStepFsResponse response = RecordSaveInfoStepFsResponse.fromJson(json);
      ToastMessage.show(response.messages, response.status == 1 ? ToastStyle.success : ToastStyle.error);
      if (response.status == 1) {
        eventBus.fire(EventReloadDetailProcedure());
      }

      setState(() {
        data.currentStep.stepTemplateFiles[index] = item;
      });
    }
  }

  Future<void> _removeStepTempleFile(StepTemplateFile item, int index) async {
    Map<String, dynamic> params = Map();
    params["ID"] = item.uploadedFile.iD;

    var json = await ApiCaller.instance.postFormData(AppUrl.recordRemoveInfoStepFs, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    if (responseMessage.status == 1) {
      eventBus.fire(EventReloadDetailProcedure());
    }

    setState(() {
      item.uploadedFile.uploadedFileName = "";
      item.uploadedFile.uploadedFilePath = "";
      data.currentStep.stepTemplateFiles[index] = item;
    });
  }
}