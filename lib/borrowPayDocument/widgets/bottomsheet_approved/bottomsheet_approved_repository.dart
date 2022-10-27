import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/borrowPayDocument/model/event_bus_borrow_pay_document.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/borrow_approved_request.dart';
import 'package:workflow_manager/main.dart';

class BottomSheetApprovedRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  Future<bool> getBorrowOption(
      String link, BorrowApprovedRequest request) async {
    final response = await apiCaller.postFormData(link, request.getParams());
    var baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      eventBus.fire(GetDataBorrowApprovedEvent(true));
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      // return true;
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }*/
    return baseResponse.status == 1 ? true : false;
  }
}
