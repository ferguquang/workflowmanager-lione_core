import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/workflow/models/response/get_pdf_path_response.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';
import 'package:workflow_manager/workflow/screens/details/view_list_files/view_item_file.dart';

import 'add_file_response.dart';
import 'attach_files_screen.dart';
import 'file_response.dart';

class AttachFilesProvider extends ChangeNotifier {
  List<FileModel> files = [];

  setFiles(List<FileModel> files) {
    if (files == null) {
      files = [];
      return;
    }
    this.files = files;
    notifyListeners();
  }

  uploadFile(
      BuildContext context, int id, AttachFileType attachFileType) async {
    var file = await FileUtils.instance.uploadFileFromSdcard(context);
    if (file.uploadStatus == UploadStatus.upload_success) {
      Map<String, dynamic> params = Map();
      params["FileName"] = file.fileName;
      params["FilePath"] = file.filePath;
      String url;
      switch (attachFileType) {
        case AttachFileType.task_detail:
          {
            params["IDJob"] = id;
            url = AppUrl.getAddFile;
            break;
          }
        case AttachFileType.group_job_detail:
          {
            params["IDGroupJob"] = id;
            url = AppUrl.getGroupTaskAddFile;
            break;
          }
      }
      var response = await ApiCaller.instance.postFormData(url, params);
      AddFileResponse addFileResponse = AddFileResponse.fromJson(response);
      if (addFileResponse.isSuccess(isDontShowErrorMessage: true)) {
        files.add(addFileResponse.data);
        notifyListeners();
      } else {
        ToastMessage.show("Upload file không thành công", ToastStyle.error);
      }
    } else {
      if (file.uploadStatus == UploadStatus.upload_failure)
        ToastMessage.show("Upload file không thành công", ToastStyle.error);
    }
  }

  addFileToLocal(BuildContext context) async {
    var file = await FileUtils.instance.uploadFileFromSdcard(context);
    if (file.uploadStatus == UploadStatus.upload_success) {
      FileModel fileModel = FileModel();
      fileModel.name = file.fileName;
      fileModel.path = file.filePath;
      fileModel.canDelete = true;
      if (files == null) files = [];
      files.add(fileModel);
      notifyListeners();
    } else if (file.uploadStatus == UploadStatus.upload_failure) {
      ToastMessage.show("Upload file không thành công", ToastStyle.error);
    }
  }

  getPdfPath(List<ViewItemFile> files) async {
    if (isNullOrEmpty(files)) return;
    String allPath = "[${files.map((e) => "\"${e.url}\"").toList().join(",")}]";
    String fileNames =
        "[${files.map((e) => "\"${e.title}\"").toList().join(",")}]";
    var response = await ApiCaller.instance.postFormData(
        AppUrl.homeChangeViewFile,
        {"FilePaths": allPath, "FileNames": fileNames});
    GetPdfPathResponse fileResponse = GetPdfPathResponse.fromJson(response);
    if (fileResponse.isSuccess(isDontShowErrorMessage: true)) {
      List<Files> changedFiles = fileResponse.data.files;
      files.forEach((element) {
        for (Files file in changedFiles) {
          if (file.filePath.toLowerCase() == element.url.toLowerCase()) {
            element.viewUrl = file.filePathChange;
            element.html = file.content;
            break;
          }
        }
      });
    }
  }

  loadById(int id, AttachFileType attachFileType) async {
    Map<String, dynamic> params = Map();
    String url;
    switch (attachFileType) {
      case AttachFileType.task_detail:
        {
          params["IDJob"] = id;
          url = AppUrl.getGetListFile;
          break;
        }
      case AttachFileType.group_job_detail:
        {
          params["IDGroupJob"] = id;
          url = AppUrl.getGroupTaskGetListFile;
          break;
        }
    }

    var response = await ApiCaller.instance.get(url, params: params);
    FileResponse fileResponse = FileResponse.fromJson(response);
    if (fileResponse.isSuccess()) {
      if (isNotNullOrEmpty(fileResponse.data))
        files = fileResponse.data;
      else {
        files = [];
      }
      notifyListeners();
    }
    /*else {
      ToastMessage.show(fileResponse.messages, ToastStyle.error);
    }*/
  }

  delete(int id, AttachFileType attachFileType) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    String url;
    switch (attachFileType) {
      case AttachFileType.task_detail:
        {
          url = AppUrl.getDeleteFile;
          break;
        }
      case AttachFileType.group_job_detail:
        {
          url = AppUrl.getGroupTaskDeleteFile;
          break;
        }
    }
    var response = await ApiCaller.instance.delete(url, params);
    // if (response["Status"] == 1) {
    //   removeFile(id);
    // } else {
    //   ToastMessage.show("Có lỗi khi kết nối đến server.", ToastStyle.error);
    // }
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess(isDontShowErrorMessage: true)) {
      removeFile(id);
      notifyListeners();
    } else {
      ToastMessage.show("Có lỗi khi kết nối đến server.", ToastStyle.error);
    }
  }

  removeFile(int id) {
    for (FileModel file in files) {
      if (file.iD == id) {
        files.remove(file);
        break;
      }
    }
    notifyListeners();
  }

  removeIndexFile(int index) {
    files.removeAt(index);
    notifyListeners();
  }
}
