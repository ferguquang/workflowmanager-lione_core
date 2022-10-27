import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/restore_contract_response.dart';

class ContractOpportunityRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  ProjectDetailModel projectDetailModel;

  // xóa
  Future<bool> getContractTrash(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;

    final response = await apiCaller
        .postFormData(AppUrl.getContractTrash, params, isLoading: true);

    var baseResponse = BaseResponse.fromJson(response);

    // if (baseResponse.isSuccess()) {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   notifyListeners();
    // return true;
    // }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }*/
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? true : false;
  }

  // xóa vĩnh viễn
  Future<bool> getContractRemove(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;

    final response = await apiCaller.delete(AppUrl.getContractRemove, params,
        isLoading: true);

    var baseResponse = BaseResponse.fromJson(response);

    // if (baseResponse.isSuccess()) {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   notifyListeners();
    // return true;
    // }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }*/
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? true : false;
  }

  // khôi phục
  Future<Contracts> getContractRestore(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;

    final response = await apiCaller
        .postFormData(AppUrl.getContractRestore, params, isLoading: true);

    RestoreContractResponse baseResponse =
        RestoreContractResponse.fromJson(response);

    // if (baseResponse.status == 1) {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   notifyListeners();
    //   return baseResponse.data.contract;
    // } else {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.error);
    //   return null;
    // }
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? baseResponse.data.contract : null;
  }
}
