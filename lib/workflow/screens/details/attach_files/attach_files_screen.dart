import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/webview_screen.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';
import 'package:workflow_manager/workflow/screens/details/flow_chart.dart';
import 'package:workflow_manager/workflow/screens/details/view_list_files/view_item_file.dart';
import 'package:workflow_manager/workflow/screens/details/view_list_files/view_list_files.dart';

import 'attach_provider.dart';
import 'file_response.dart';

enum AttachFileType { task_detail, group_job_detail }

class AttachFilesScreen extends StatefulWidget {
  static int admin = 1;
  int id;
  int taskType;
  int role;
  bool editable = true;
  AttachFileType _attachFileType;
  List<FileModel> files;

  AttachFilesScreen(this._attachFileType,
      {this.id, this.taskType, this.role, this.files});

  @override
  State<StatefulWidget> createState() {
    return _AttachFilesScreenState();
  }
}

class _AttachFilesScreenState extends State<AttachFilesScreen> {
  AttachFilesProvider _attachFilesProvider = AttachFilesProvider();
  int currentIdUser;

  bool canDeleteFile(FileModel fileModel) {
    if (widget._attachFileType == AttachFileType.task_detail) {
      return fileModel.createdBy == currentIdUser;
    } else if (widget._attachFileType == AttachFileType.group_job_detail) {
      return fileModel.canDelete ?? true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    SharedPreferencesClass.getUser().then((value) {
      currentIdUser = value.iDUserDocPro;
    });
    if (widget.id != null)
      _attachFilesProvider.loadById(widget.id, widget._attachFileType);
    if (widget.files != null) {
      _attachFilesProvider.setFiles(widget.files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tệp đính kèm"),
          actions: [
            InkWell(
              onTap: () async {
                if (widget.id != null) {
                  _attachFilesProvider.uploadFile(
                      context, widget.id, widget._attachFileType);
                } else {
                  _attachFilesProvider.addFileToLocal(context);
                }
              },
              child: Visibility(
                  visible: widget.editable,
                  child: Container(
                    margin: EdgeInsets.all(6),
                    child: Icon(Icons.file_upload),
                  )),
            )
          ],
        ),
        body: WillPopScope(
            onWillPop: () {
              Navigator.pop(context, _attachFilesProvider.files);
              return Future.value(false);
            },
            child: ChangeNotifierProvider.value(
                value: _attachFilesProvider,
                child: Consumer(
                    builder: (context, AttachFilesProvider attachFilesProvider,
                            child) =>
                        Padding(
                            padding: EdgeInsets.all(6),
                            child: Column(children: [
                              Flexible(
                                  child: attachFilesProvider?.files?.length == 0
                                      ? EmptyScreen()
                                      : ListView.builder(
                                          itemCount: attachFilesProvider
                                                  ?.files?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: EdgeInsets.all(8),
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: "F5F6FA".toColor(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
                                                    margin: EdgeInsets.only(
                                                        right: 15),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Icon(
                                                        Icons.attach_file,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        this._showListFiles(_attachFilesProvider?.files, index);
                                                        // _downloadFile(attachFilesProvider?.files[index], context);
                                                      },
                                                      child: Text(
                                                        attachFilesProvider
                                                                ?.files[index]
                                                                ?.name ??
                                                            "",
                                                        style: TextStyle(
                                                            color: "00689D"
                                                                .toColor()),
                                                      ),
                                                    ),
                                                  ),
                                                  Opacity(
                                                    opacity: canDeleteFile(
                                                            attachFilesProvider
                                                                ?.files[index])
                                                        ? 1
                                                        : 0,
                                                    child: IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        ConfirmDialogFunction
                                                            confirmDialogFunction =
                                                            ConfirmDialogFunction(
                                                          context: context,
                                                          content:
                                                              "Bạn có muốn xóa file này không?",
                                                          onAccept: () {
                                                            if (widget.id !=
                                                                null) {
                                                              attachFilesProvider.delete(
                                                                  attachFilesProvider
                                                                      ?.files[
                                                                          index]
                                                                      ?.iD,
                                                                  widget
                                                                      ._attachFileType);
                                                            } else {
                                                              _attachFilesProvider
                                                                  .removeIndexFile(
                                                                      index);
                                                            }
                                                          },
                                                        );
                                                        confirmDialogFunction
                                                            .showConfirmDialog();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ))
                            ]))))));
  }

  _downloadFile(FileModel file, BuildContext context) async {
    FileUtils.instance.downloadFileAndOpen(file.name, file.path, context);
  }

  _showListFiles(List<FileModel> files, int index) async {
    List<ViewItemFile> listFiles = [];

    await files.forEach((file) async {
      String newPath = "";
      if (file.path.toLowerCase().contains("/storage/files/")) {
        newPath = file.path.toLowerCase().replaceAll("/storage/files/", "");
      } else {
        newPath = file.path;
      }
      String root =
          await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
      String url = '$root/storage/files/${newPath}';
      listFiles.add(ViewItemFile(
        title: file.name,
        url: url,
        isFirstPage: index == 0,
        isEndPage: index == files.length - 1,
      ));
    });
    await _attachFilesProvider.getPdfPath(listFiles);
    pushPage(
        context,
        ViewListFiles(
          listFiles: listFiles,
          index: index,
          files: files,
        ));
  }
}
