import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/delivery_list_request.dart';
import 'package:workflow_manager/shopping_management/response/delivery_list_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_pr_response.dart';
import 'package:workflow_manager/shopping_management/response/get_contract_by_requisition_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class DeliveryListRepository extends ChangeNotifier {
  DeliveryListModel deliveryListModel;
  DeliveryListRequest params = DeliveryListRequest();
  int sortType;
  int skip;
  int take = 10;
  RefreshController refreshController;
  bool isSearching = false;
  List<Contracts> root = [];
  List<SearchContract> contracts;
  List<Requisitions> requisitions;

  _loadData() async {
    params.skip = skip;
    params.take = take;
    var response = await ApiCaller.instance.postFormData(
        AppUrl.qlmsDeliveryIndex, params.getParams(),
        isLoading: skip == 1);
    DeliveryListResponse deliveryListResponse =
        DeliveryListResponse.fromJson(response);
    if (deliveryListResponse.status == 1) {
      if (skip == 1) {
        deliveryListModel = deliveryListResponse.data;
        root.addAll(deliveryListModel.contracts);
        sort(-1);
      } else {
        deliveryListModel.contracts.addAll(deliveryListResponse.data.contracts);
        root.addAll(deliveryListResponse.data.contracts);
        deliveryListModel.totalRecord = deliveryListResponse.data.totalRecord;
        deliveryListModel.searchParam = deliveryListResponse.data.searchParam;
        if (sortType != -1) {
          sort(sortType);
        }
      }
      contracts = deliveryListResponse.data.searchParam.contracts;
      requisitions = deliveryListResponse.data.searchParam.requisitions;
      notifyListeners();
      skip++;
    } else {
      showErrorToast(deliveryListResponse.messages);
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
    if (deliveryListModel != null) {
      if (deliveryListModel.totalRecord < take) return;
    }
    if (skip != null) {
      this.skip = skip;
    }
    _loadData();
  }

  sort(int type, {bool isNeedNotify = true}) {
    sortType = type;
    if (type != -1) {
      deliveryListModel.contracts.sort((a, b) =>
          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
          a.project.toLowerCase().compareTo(b.project.toLowerCase()));
    }
    if (isNeedNotify == true) notifyListeners();
  }

  toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) search("");
    notifyListeners();
  }

  getPRByProject(int projectId) async {
    var json = await ApiCaller.instance.get(
        AppUrl.qlmsGetRequisitionsByProjectContract,
        params: {"ID": projectId});
    DeliveryPRResponse response = DeliveryPRResponse.fromJson(json);
    if (response.isSuccess()) {
      deliveryListModel.searchParam.requisitions = response.data.requisitions;
    }
  }

  getByPR(String prId) async {
    var json = await ApiCaller.instance
        .get(AppUrl.qlmsGetContractsByReqDelivery, params: {"ID": prId});
    GetContractByRequisitionResponse response =
        GetContractByRequisitionResponse.fromJson(json);
    if (response.isSuccess()) {
      deliveryListModel.searchParam.contracts = response.data.contracts;
    }
  }

  search(String text) {
    text = text.toLowerCase();
    deliveryListModel.contracts = root
        .where((element) => element.project.toLowerCase().contains(text))
        .toList();
    notifyListeners();
  }
}
