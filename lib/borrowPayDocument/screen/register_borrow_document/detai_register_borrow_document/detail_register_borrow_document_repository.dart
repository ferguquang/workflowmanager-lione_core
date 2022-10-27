import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/borrowPayDocument/model/event_bus_borrow_pay_document.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/detail_register_request.dart';

import '../../../../main.dart';

class DetailRegisterBorrowDocumentRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  Future<bool> getBorrowCreated(DetailRegisterRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getBorrowCreated, request.getParams());
    var baseResponse = BaseResponse.fromJson(response);

    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus.fire(GetDataBorrowDetailSearchEvent());
      // return true;
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }*/
    return baseResponse.status == 1 ? true : false;
  }
}
