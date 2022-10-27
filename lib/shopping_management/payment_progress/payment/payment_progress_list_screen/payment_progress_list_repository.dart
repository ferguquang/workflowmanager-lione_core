import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/payment_progress_list_request.dart';
import 'package:workflow_manager/shopping_management/response/payment_progress_get_po_by_pr_response.dart';
import 'package:workflow_manager/shopping_management/response/payment_progress_get_pr_by_project_response.dart';
import 'package:workflow_manager/shopping_management/response/payment_progress_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class PaymentProgressListRepository extends ChangeNotifier {
  PaymentProgressModel paymentProgressModel;
  PaymentProgressListRequest params = PaymentProgressListRequest();
  int sortType;
  int skip;
  int take = 10;
  RefreshController refreshController;
  List<PRCodes> pRCodes;
  List<POCodes> pOCodes;

  _loadData() async {
    params.skip = skip;
    params.take = take;
    var response = await ApiCaller.instance.postFormData(
        AppUrl.qlmsPaymentProgressIndex, params.getParams(),
        isLoading: skip == 1);
    PaymentProgressResponse paymentProgressResponse =
        PaymentProgressResponse.fromJson(response);
    if (paymentProgressResponse.status == 1) {
      if (skip == 1) {
        paymentProgressModel = paymentProgressResponse.data;
        pOCodes = paymentProgressResponse.data.searchParam.pOCodes;
        pRCodes = paymentProgressResponse.data.searchParam.pRCodes;
        sort(-1);
      } else {
        paymentProgressModel.contracts
            .addAll(paymentProgressResponse.data.contracts);
        paymentProgressModel.totalRecord =
            paymentProgressResponse.data.totalRecord;
        paymentProgressModel.searchParam =
            paymentProgressResponse.data.searchParam;
        pOCodes = paymentProgressResponse.data.searchParam.pOCodes;
        pRCodes = paymentProgressResponse.data.searchParam.pRCodes;
        if (sortType != -1) {
          sort(sortType);
        }
      }
      notifyListeners();
      skip++;
    } else {
      showErrorToast(paymentProgressResponse.messages);
    }
    if (refreshController.isRefresh)
      refreshController.refreshCompleted();
    else if (refreshController.isLoading) {
      refreshController.loadComplete();
    }
  }

  refreshData() {
    skip = 1;
    _loadData();
  }

  loadMore({int skip}) {
    if (paymentProgressModel != null) {
      if (paymentProgressModel.totalRecord < take) return;
    }
    if (skip != null) {
      this.skip = skip;
    }
    _loadData();
  }

  getPRByProject(int projectId) async {
    var json = await ApiCaller.instance.postFormData(
        AppUrl.qlmsPaymentProgressChangeProject, {"ID": projectId});
    PaymentProgressGetPrByProjectResponse response =
        PaymentProgressGetPrByProjectResponse.fromJson(json);
    if (response.isSuccess()) {
      paymentProgressModel.searchParam.pRCodes = response.data.pRCodes;
      paymentProgressModel.searchParam.pOCodes = response.data.pOCodes;
    }
  }

  getByPR(String prId) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsPaymentProgressChangePRCode, {"ID": prId});
    PaymentProgressGetPoByPrResponse response =
        PaymentProgressGetPoByPrResponse.fromJson(json);
    if (response.isSuccess()) {
      paymentProgressModel.searchParam.pOCodes = response.data.pOCodes;
    }
  }

  sort(int type, {bool isNeedNotify = true}) {
    sortType = type;
    if (type != -1) {
      paymentProgressModel.contracts.sort((a, b) =>
          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
          a.project.toLowerCase().compareTo(b.project.toLowerCase()));
    }
    if (isNeedNotify == true) notifyListeners();
  }
}
