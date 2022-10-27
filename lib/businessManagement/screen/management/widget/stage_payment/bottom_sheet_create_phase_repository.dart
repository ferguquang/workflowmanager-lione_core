import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/stage_payments_request.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_contract_response.dart';
import 'package:workflow_manager/businessManagement/model/response/status_stage_payment_contract_response.dart';

import '../../../../../main.dart';

class StagePaymentContractRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  // tạo giai đoạn
  Future<ContractPayments> getContractChangePaymentStatus(
      StagePaymentsRequest request, bool isCreate) async {
    final response = await apiCaller.postFormData(
        isCreate
            ? AppUrl.getContractSavePayment
            : AppUrl.getContractChangePayment,
        request.getParams(),
        isLoading: true);

    ContractStagePaymentResponse baseResponse =
        ContractStagePaymentResponse.fromJson(response);

    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      notifyListeners();
      eventBus.fire(GetDataContractPaymentsEventBus(
          baseResponse.data?.contractPaymentStatus, isCreate));
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }
}
