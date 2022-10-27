import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/borrowPayDocument/model/event_bus_borrow_pay_document.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/borrow_index_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/borrow_removes_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_index_response.dart';
import 'package:workflow_manager/main.dart';

class ListBorrowDocumentRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<StgDocBorrows> stgDocBorrows;
  List<StgDocBorrows> searchedData = [];
  int skip = 1;
  BorrowIndexRequest request;
  bool isShowButtonBorrow = false;
  List<int> listCount = [];

  // api danh sách
  Future<bool> getBorrowIndex(BorrowIndexRequest request) async {
    this.request = request;
    request.skip = skip;
    final response = await apiCaller.postFormData(
        AppUrl.getBorrowIndex, request.getParams(),
        isLoading: skip == 1);

    var borrowSearchResponse = BorrowIndexResponse.fromJson(response);

    if (borrowSearchResponse.isSuccess()) {
      stgDocBorrows = borrowSearchResponse.data.stgDocBorrows;
      if (this.skip == 1) {
        searchedData = stgDocBorrows;

        // đi đến class tab_borrow_pay_document_screen.dart
        listCount.clear();
        listCount.add(borrowSearchResponse.data.totalPending);
        listCount.add(borrowSearchResponse.data.totalApproved);
        listCount.add(borrowSearchResponse.data.totalRejected);
        listCount.add(borrowSearchResponse.data.totalApprovedExpried);
        listCount.add(borrowSearchResponse.data.totalBorrowed);
        listCount.add(borrowSearchResponse.data.totalBorrowedExpried);
        listCount.add(borrowSearchResponse.data.totalDisabled);
        listCount.add(borrowSearchResponse.data.totalClosed);
        eventBus.fire(GetDataBorrowIndexEvent(listCount));

        isShowButtonBorrow = borrowSearchResponse.data.isShowButtonBorrow;
      } else {
        this.searchedData.addAll(stgDocBorrows);
      }
      skip++;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(borrowSearchResponse.messages, ToastStyle.error);
    }*/
  }

  void pullToRefreshData() {
    skip = 1;
  }

  // api xóa nhiều
  Future<bool> getBorrowRemoves() async {
    List<String> listStringID = [];
    int numberDelete = 0;
    stgDocBorrows.forEach((element) {
      if (element.isSelected) {
        if (!element.isBorrowDelete) numberDelete++;
        listStringID.add(element.iD.toString());
      }
    });
    if (numberDelete > 0) {
      ToastMessage.show('Có $numberDelete phiếu đăng ký không có quyền xóa',
          ToastStyle.error);
      return false;
    }
    String idListString =
        FileUtils.instance.getListStringConvertString(listStringID);

    BorrowRemovesRequest request = BorrowRemovesRequest();
    request.iD = idListString;

    final response = await apiCaller.postFormData(
        AppUrl.getBorrowRemoves, request.getParams());

    var baseResponse = BaseResponse.fromJson(response);

    // if (baseResponse.status == 1) {
    baseResponse.isSuccess();
    return baseResponse.status == 1 ? true : false;
    // } else {
    //   ToastMessage.show(baseResponse.messages, ToastStyle.error);
    //   return false;
    // }
  }

  // xóa bỏ check khi chọn xóa nhiều
  getCheckFalseListOriginal() {
    stgDocBorrows.forEach((element) {
      /*if (element.isSelected) */ element.isSelected = false;
    });
  }

  // tìm kiếm danh sách
  getSearchIndex(String textSearch) async {
    if (isNotNullOrEmpty(textSearch)) {
      var text = removeDiacritics(textSearch).toLowerCase();
      searchedData = stgDocBorrows
          .where((element) =>
              removeDiacritics(element.name).toLowerCase().contains(text))
          .toList();
    } else {
      pullToRefreshData();
      getBorrowIndex(request);
    }
  }
}
