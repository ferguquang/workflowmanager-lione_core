import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/custom_text_field_validate.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/request/inport_flile_request.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/detail/tab/file/file_opportunity_repository.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/attach_provider.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

class AddFilePhaseDialog extends StatefulWidget {
  bool isCreate; // false tạo file, true là chỉnh sửa file
  List<Status> listPhaseFile;
  int idOpportunity;

  // dành cho chỉnh sửa
  Status phase;
  String fileName;
  int idFile;
  final void Function(Attachments data) onModel;

  AddFilePhaseDialog(
      {this.phase,
      this.fileName,
      this.idFile,
      this.listPhaseFile,
      this.idOpportunity,
      this.isCreate,
      this.onModel});

  @override
  _AddFilePhaseDialogState createState() => _AddFilePhaseDialogState();
}

class _AddFilePhaseDialogState extends State<AddFilePhaseDialog> {
  String title = 'Thêm mới file';
  var phaseController = TextEditingController();
  var nameController = TextEditingController();
  String fileName = '';
  String filePath = '';
  Status phase = Status();
  bool isShowViewFile = false;

  FileOpportunityRepository _repository = FileOpportunityRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.isCreate) {
      setState(() {
        if (widget.listPhaseFile.length > 0) phase = widget.listPhaseFile[0];
        phaseController.text = phase?.name;
      });
    } else {
      setState(() {
        title = 'Chỉnh sửa file';
        phase = widget.phase;
        fileName = widget.fileName;
        nameController.text = fileName;
        phaseController.text = phase?.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, FileOpportunityRepository __repository1, child) {
          return Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5)),
                      color: Colors.blue),
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Visibility(
                  visible: widget.isCreate,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: TextFieldValidate(
                      padding: EdgeInsets.only(top: 12),
                      title: 'Tên file',
                      controller: nameController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: TagLayoutWidget(
                    horizontalPadding: 0,
                    title: "Giai đoạn",
                    value: phaseController.text,
                    icon: Icons.date_range,
                    openFilterListener: () {
                      FocusScope.of(context).unfocus();
                      _getPhaseOpportunity();
                    },
                  ),
                ),
                Visibility(
                  visible: !widget.isCreate,
                  child: Padding(
                    child: Text(
                      'File tải lên:',
                      style:
                          TextStyle(color: "#555555".toColor(), fontSize: 12),
                    ),
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 16, right: 16),
                  ),
                ),
                Visibility(
                  visible: isShowViewFile,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, right: 16, left: 16),
                    child: Text(
                      fileName,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (!widget.isCreate)
                            _eventClickAddFile();
                          else
                            Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.isCreate
                                ? 'Hủy'.toUpperCase()
                                : 'Chọn file'.toUpperCase(),
                            style: TextStyle(
                                color:
                                    widget.isCreate ? Colors.grey : Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _eventClickDone();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Xong'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // click file đính kèm
  _eventClickAddFile() async {
    AttachFilesProvider attachFilesProvider = AttachFilesProvider();
    await attachFilesProvider.addFileToLocal(context);
    setState(() {
      if (attachFilesProvider.files.length > 0) {
        isShowViewFile = true;
        // do cái này chỉ chọn 1 file lên fix cứng 0
        fileName = attachFilesProvider.files[0].name;
        filePath = attachFilesProvider.files[0].path;
      }
    });
  }

  // chọn giai đoạn
  _getPhaseOpportunity() {
    List<Status> listStatus = [];
    if (phase?.iD != null) listStatus.add(phase);
    ChoiceDialog choiceDialog = ChoiceDialog<Status>(
      context,
      widget.listPhaseFile,
      title: 'Chọn giai đoạn'.toUpperCase(),
      isSingleChoice: true,
      selectedObject: listStatus,
      getTitle: (data) => data?.name,
      onAccept: (List<Status> selected) {
        if (isNotNullOrEmpty(selected)) {
          setState(() {
            Status data = selected[0];
            phase = data;
            phaseController.text = phase?.name;
          });
        }
      },
      choiceButtonText: 'Chọn giai đoạn',
    );
    choiceDialog.showChoiceDialog();
  }

  // clickdone
  _eventClickDone() async {
    // if (phase.iD == null) {
    //   ToastMessage.show('', ToastStyle.error);
    //   return;
    // }
    if (fileName.length == 0 && filePath.length == 0) {
      ToastMessage.show('File đính kèm $textNotLeftBlank', ToastStyle.error);
      return;
    }
    ImportFileRequest request = ImportFileRequest();
    request.iDPhase = phase?.iD ?? 0;

    if (!widget.isCreate) {
      request.fileNames = fileName;
      request.filePaths = filePath;
      request.projectPlanID = widget.idOpportunity;
      Attachments model = await _repository.getOpportunityImportFile(request);
      if (model != null) {
        Navigator.of(context).pop();
        widget.onModel(model);
      }
    } else {
      request.fileName = nameController.text;
      request.iD = widget.idFile;
      Attachments model = await _repository.getOpportunityFileChange(request);
      if (model != null) {
        Navigator.of(context).pop();
        widget.onModel(model);
      }
    }
  }
}
