import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/storage/models/events/bottom_sheet_action_event.dart';
import 'package:workflow_manager/storage/models/params/bottom_sheet_action_request.dart';
import 'package:workflow_manager/storage/models/response/change_file_response.dart';
import 'package:workflow_manager/storage/models/response/stg_file_change_response.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';

import '../../../main.dart';

class BottomSheetActionRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  int errorCode;

  Future<bool> changeName(
      int id, String name, String password, int idParent) async {
    if (isNullOrEmpty(name)) {
      ToastMessage.show('Tên không được để trống', ToastStyle.error);
      return false;
    }
    StgChangeFilesRequest requestStgChange = StgChangeFilesRequest();
    requestStgChange.id = id;
    requestStgChange.name = name;
    requestStgChange.accessSafePassword = password;
    requestStgChange.parent = idParent;

    final response = await apiCaller.postFormData(
        AppUrl.getStorageChange(), requestStgChange.getParams());
    StgFileChangeResponse _storageChangeResponse =
        StgFileChangeResponse.fromJson(response);
    if (_storageChangeResponse.isSuccess(isShowSuccessMessage: true)) {
      // ToastMessage.show(_storageChangeResponse.messages, ToastStyle.success);
      eventBus.fire(ActionStorageSuccessEvent());
      return true;
    } else {
      errorCode = _storageChangeResponse.errorCode;
      // ToastMessage.show(_storageChangeResponse.messages, ToastStyle.error);
      return false;
    }
  }

  Future<void> getPinDoc(String id, bool isPin) async {
    PinDocFilesRequest requestPinDoc = PinDocFilesRequest();
    requestPinDoc.id = id;
    requestPinDoc.isPin = isPin;

    final response = await apiCaller.postFormData(
        AppUrl.getStoragePinDoc(), requestPinDoc.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus.fire(ActionStorageSuccessEvent());
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }

  Future<int> getDeletesListFile(String id, String password) async {
    DeleteFilesRequest requestDelete = DeleteFilesRequest();
    requestDelete.id = id;
    requestDelete.password = password;

    final response = await apiCaller.postFormData(
        AppUrl.getStorageDeletes(), requestDelete.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus.fire(ActionStorageSuccessEvent());
      return null;
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return 1002;
    }*/
    return 1002;
  }

  Future<void> getSetPassWord(
      int id, String password, String currentPassword) async {
    SetPasswordFilesRequest requestSetPassWord = SetPasswordFilesRequest();
    requestSetPassWord.id = id;
    requestSetPassWord.currentPassword = currentPassword;

    requestSetPassWord.password = password;

    final response = await apiCaller.postFormData(
        AppUrl.getStorageSavePassword(), requestSetPassWord.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus.fire(ActionStorageSuccessEvent());
    }
    /* else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }

  Future<void> getDeletePassWord(int id, String password) async {
    DeletePasswordFilesRequest requestDeletePassWord =
        DeletePasswordFilesRequest();
    requestDeletePassWord.id = id;
    requestDeletePassWord.password = password;

    final response = await apiCaller.postFormData(
        AppUrl.getStorageDeletePassword(), requestDeletePassWord.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus.fire(ActionStorageSuccessEvent());
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }

  Future<int> getAuthenPassWord(int id, String password) async {
    AuthenPassWordFilesRequest requestAuthenPassWord =
        AuthenPassWordFilesRequest();
    requestAuthenPassWord.id = id;
    requestAuthenPassWord.password = password;

    final response = await apiCaller.postFormData(
        AppUrl.getStorageAuthenPassword(), requestAuthenPassWord.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    // if (baseResponse.status == 1) {
    //   return 1;
    // } else {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.error);
    //   return 0;
    // }
    baseResponse.isSuccess();
    return baseResponse.status == 1 ? 1 : 0;
  }

  // Thực hiện thay đổi file
  Future<String> uploadOtherFile(BuildContext context, int id,
      {String passWord, String pathFile}) async {
    UploadModel file;
    if (isNotNullOrEmpty(pathFile)) {
      file = await FileUtils.instance.uploadFileWithPath(pathFile);
    } else {
      file = await FileUtils.instance.uploadFileFromSdcard(context);
    }
    if (file == null) {
      return null;
    }
    loadingDialog.show();
    if (file.uploadStatus == UploadStatus.upload_success) {
      Map<String, dynamic> params = Map();
      params["Path"] = file.filePath;
      params["FIleName"] = file.fileName;
      params["ID"] = id;
      if (passWord != null) {
        params["AccessSafePassword"] = passWord;
      }
      var response = await ApiCaller.instance
          .postFormData(AppUrl.getStorageChangeFile(), params);
      ChangeFileResponse baseResponse = ChangeFileResponse.fromJson(response);
      if (baseResponse.isSuccess()) {
        loadingDialog.hide();
        ToastMessage.show("Thay thế file thành công", ToastStyle.success);
        eventBus.fire(ActionStorageSuccessEvent());
        notifyListeners();
        return file.filePathRoot;
      } else {
        loadingDialog.hide();
        // ToastMessage.show(baseResponse.messages, ToastStyle.error);
        errorCode = baseResponse.errorCode;
        return file.filePathRoot;
      }
    } else {
      loadingDialog.hide();
      return null;
    }
  }
}
