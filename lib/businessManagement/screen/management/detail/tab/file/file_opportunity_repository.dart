import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/request/inport_flile_request.dart';
import 'package:workflow_manager/businessManagement/model/response/change_file_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/import_file_response.dart';

class FileOpportunityRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  // xóa
  Future<bool> getDeleteFileOpportunity(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;

    final response =
        await apiCaller.delete(AppUrl.getDeleteFileOpportunity, params);

    var baseResponse = BaseResponse.fromJson(response);

    // if (baseResponse.status == 1) {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   notifyListeners();
    //   return true;
    // } else {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.error);
    //   return false;
    // }
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? true : false;
  }

  // thêm file
  Future<Attachments> getOpportunityImportFile(
      ImportFileRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getOpportunityImportFile, request.getParams());

    ImportFileResponse baseResponse = ImportFileResponse.fromJson(response);

    // if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
    //   Attachments data = baseResponse.data.attachments[0];
    //   // ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   notifyListeners();
    //   return data;
    // }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return null;
    }*/
    // return null;
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? baseResponse.data.attachments[0] : null;
  }

  // chỉnh sửa file
  Future<Attachments> getOpportunityFileChange(
      ImportFileRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getOpportunityFileChange, request.getParams());

    ChangeFileResponse baseResponse = ChangeFileResponse.fromJson(response);

    // if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
    //   // ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   notifyListeners();
    //   return baseResponse.data.attachment;
    // }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return null;
    }*/
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? baseResponse.data.attachment : null;
  }
}
