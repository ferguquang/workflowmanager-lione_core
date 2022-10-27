import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/borrowPayDocument/model/event_bus_borrow_pay_document.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/borrow_removes_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_detail_response.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_index_response.dart';
import 'package:workflow_manager/main.dart';

class DetailBorrowDocumentRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  StgDocBorrows dataDetail;

  Future<bool> getBorrowDetail(int id) async {
    BorrowRemovesRequest request = BorrowRemovesRequest();
    request.iD = id.toString();
    final response = await apiCaller.postFormData(
        AppUrl.getBorrowDetail, request.getParams());
    var baseResponse = BorrowDetailResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      dataDetail = baseResponse.data.stgDocBorrow;

      String root = await SharedPreferencesClass.getRoot();
      if (isNotNullOrEmpty(dataDetail?.borrower) &&
          isNotNullOrEmpty(dataDetail?.borrower?.avatar))
        dataDetail?.borrower?.avatar = root + dataDetail?.borrower?.avatar;
      if (isNotNullOrEmpty(dataDetail?.approver) &&
          isNotNullOrEmpty(dataDetail?.approver?.avatar))
        dataDetail?.approver?.avatar = root + dataDetail?.approver?.avatar;
      if (isNotNullOrEmpty(dataDetail?.archiver) &&
          isNotNullOrEmpty(dataDetail?.archiver?.avatar))
        dataDetail?.archiver?.avatar = root + dataDetail?.archiver?.avatar;
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      notifyListeners();
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }

  Future<bool> getBorrowOptionDelete(int iD) async {
    BorrowRemovesRequest request = BorrowRemovesRequest();
    request.iD = iD.toString();
    final response = await apiCaller.postFormData(
        AppUrl.getBorrowRemove, request.getParams());
    var baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      // truyền sang class list_borrow_document_screen.dart
      eventBus.fire(GetDataBorrowDeleteEvent(true, iD));
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
