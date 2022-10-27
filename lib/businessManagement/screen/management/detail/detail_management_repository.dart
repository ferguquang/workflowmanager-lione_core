import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/request/detail_management_request.dart';
import 'package:workflow_manager/businessManagement/model/request/status_detail_management_request.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';

class DetailManagementRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  ProjectDetailModel projectDetailModel;

  // chi tiết
  Future<bool> getDetailManagement(int id, bool isOnlyView) async {
    DetailManagementRequest request = DetailManagementRequest();
    request.id = id;

    final response = await apiCaller.postFormData(
        isOnlyView ? AppUrl.getDetailKhach : AppUrl.getDetailAdmin,
        request.getParams(),
        isLoading: true);

    var baseResponse = DetailManagementResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      projectDetailModel = baseResponse.data?.projectDetailModel;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }

  // thay đổi trạng thái
  Future<bool> getDetailChangeStatus(int id, int iDTarget) async {
    StatusDetailManagementRequest request = StatusDetailManagementRequest();
    request.id = id;
    request.iDTarget = iDTarget;

    final response = await apiCaller.postFormData(
        AppUrl.getDetailChangeStatus, request.getParams(),
        isLoading: true);

    var baseResponse = DetailManagementResponse.fromJson(response);

    // if (baseResponse.status == 1) {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   return true;
    // } else {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.error);
    //   return false;
    // }
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? true : false;
  }

  // thay đổi giai đoạn
  Future<bool> getDetailChangePhase(int id, int iDTarget) async {
    StatusDetailManagementRequest request = StatusDetailManagementRequest();
    request.id = id;
    request.iDTarget = iDTarget;

    final response = await apiCaller.postFormData(
        AppUrl.getDetailChangePhase, request.getParams(),
        isLoading: true);

    var baseResponse = DetailManagementResponse.fromJson(response);

    // if (baseResponse.status == 1) {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   return true;
    // } else {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.error);
    //   return false;
    // }
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? true : false;
  }

  // duyệt chỉnh sửa cơ hội
  Future<bool> getProjectPlanApproveEdit(int id) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['ID'] = id;

    final response = await apiCaller.postFormData(
        AppUrl.getProjectPlanApproveEdit, params,
        isLoading: true);

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

  // từ chối duyệt chỉnh sửa cơ hội
  Future<bool> getProjectPlanRejectEdit(int id) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['ID'] = id;

    final response = await apiCaller
        .postFormData(AppUrl.getProjectPlanRejectEdit, params, isLoading: true);

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
}
