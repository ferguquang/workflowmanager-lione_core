import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/borrow_search_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_search_response.dart';

class RegisterBorrowDocumentRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<StgDocs> stgDocs = [];
  DataBorrowSearch dataBorrowSearch;
  int skip = 1;
  BorrowSearchRequest request;

  Future<int> getBorrowSearch(BorrowSearchRequest request) async {
    this.request = request;
    this.request.skip = skip;
    final response = await apiCaller.postFormData(
        AppUrl.getBorrowSearch, request.getParams(),
        isLoading: skip == 1);
    BorrowSearchResponse borrowSearchResponse =
        BorrowSearchResponse.fromJson(response);
    if (borrowSearchResponse.isSuccess()) {
      dataBorrowSearch = borrowSearchResponse.data;
      if (this.skip == 1)
        stgDocs = dataBorrowSearch?.stgDocs;
      else
        stgDocs.addAll(dataBorrowSearch?.stgDocs);
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
}
