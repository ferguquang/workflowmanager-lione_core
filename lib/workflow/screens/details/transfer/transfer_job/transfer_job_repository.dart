import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/params/for_tranfer_user_request.dart';
import 'package:workflow_manager/workflow/models/params/transfer_rate_user_request.dart';
import 'package:workflow_manager/workflow/models/response/for_tranfer_user.dart';
import 'package:workflow_manager/workflow/models/response/transfer_and_rate_user_response.dart';
import 'package:workflow_manager/workflow/models/response/value_response.dart';

class TransferJobRepository extends ChangeNotifier {
  List<DataForTranferUserModel> dataForTranferUserModel = [];

  loadDataForTransferUser(ForTranferUserRequest request) async {
    var response = await ApiCaller.instance
        .get(AppUrl.getDataForTranferUser, params: request.getParams());
    ForTransferUserResponse forTranferUserReponse =
        ForTransferUserResponse.fromJson(response);
    if (forTranferUserReponse.isSuccess()) {
      if (isNotNullOrEmpty(forTranferUserReponse.data)) {
        dataForTranferUserModel = forTranferUserReponse.data;
        notifyListeners();
      }
    }
    /* else {
      ToastMessage.show(
          forTranferUserReponse.messages ?? "Đã xảy ra lỗi khi lấy dữ liệu",
          ToastStyle.error);
      notifyListeners();
    }*/
  }

  Future<Map<String, dynamic>> getTransferAndRateUser(
      TransferRateUserRequest request, BuildContext context) async {
    final response = await ApiCaller.instance
        .postFormData(AppUrl.getTransferAndRateUser, request.getParams());
    final TransferAndRateUserResponse transferAndRateUserResponse =
        TransferAndRateUserResponse.fromJson(response);

    if (transferAndRateUserResponse.isSuccess(
        isDontShowErrorMessage: true, isShowSuccessMessage: true)) {
      // ToastMessage.show('Chuyển giao công việc thành công', ToastStyle.success);
      notifyListeners();
      Navigator.of(context).pop(1);
    }
    /*else {
      ToastMessage.show('Không thể chuyển giao công việc', ToastStyle.error);
      notifyListeners();
    }*/
  }

  Future<int> transferUser(int jobId, int idNewExecutor, String iDOldCoExecuter,
      String iDOldSupervisor, String reason) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = jobId;
    params["IDNewExecutor"] = idNewExecutor;
    params["IDOldCoExecuter"] = iDOldCoExecuter;
    params["IDOldSupervisor"] = iDOldSupervisor;
    params["Reason"] = reason;
    var reponse =
        await ApiCaller.instance.postFormData(AppUrl.getTranferUser, params);
    ValueResponse<int> valueResponse = ValueResponse<int>.fromJson(reponse);
    if (valueResponse.isSuccess()) {
      return valueResponse.data;
    } else {
      // ToastMessage.show(valueResponse.messages, ToastStyle.error);
      return null;
    }
  }
}
