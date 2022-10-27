import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_contract_response.dart';
import 'package:workflow_manager/businessManagement/model/response/status_stage_payment_contract_response.dart';

class StagePaymentContractRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  // xóa
  Future<bool> getContractDeletePayment(int id) async {
    Map<String, dynamic> params = Map();
    params["IDPayment"] = id;

    final response = await apiCaller
        .delete(AppUrl.getContractDeletePayment, params, isLoading: true);

    var baseResponse = BaseResponse.fromJson(response);

    // if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
    // ToastMessage.show(baseResponse.messages, ToastStyle.success);
    // notifyListeners();
    // return true;
    // }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }*/
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? true : false;
  }

  // trạng thái
  Future<ContractPayments> getContractChangePaymentStatus(
      int iDPayment, int stauts) async {
    Map<String, dynamic> params = Map();
    params["Status"] = stauts;
    params["IDPayment"] = iDPayment;

    final response = await apiCaller.postFormData(
        AppUrl.getContractChangePaymentStatus, params,
        isLoading: true);

    ContractStagePaymentResponse baseResponse =
        ContractStagePaymentResponse.fromJson(response);

    // if (baseResponse.isSuccess()) {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.success);
    //   notifyListeners();
    // return baseResponse.data?.contractPaymentStatus;
    // }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return null;
    }*/
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1
        ? baseResponse.data.contractPaymentStatus
        : null;
  }
}
