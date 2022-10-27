import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/contract_list_params.dart';
import 'package:workflow_manager/shopping_management/response/contract_list_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class ContractListRepository extends ChangeNotifier {
  ContractListParams params = ContractListParams();
  int take = 20;
  int pageIndex = 1;
  ContractListModel contractListModel;
  RefreshController refreshController;
  int sortType = -1;

  sort(int type, {bool isNeedNotify = true}) {
    if (type != -1) {
      contractListModel.contracts.sort((a, b) =>
          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
          a.project.toLowerCase().compareTo(b.project.toLowerCase()));
    }
    sortType = type;
    if (isNeedNotify == true) notifyListeners();
  }

  _loadData() async {
    params.pageIndex = pageIndex;
    params.take = take;
    var response = await ApiCaller.instance.postFormData(
        AppUrl.qlmsContractIndex, params.getParams(),
        isLoading: pageIndex == 1);
    ContractListResponse contractListResponse =
        ContractListResponse.fromJson(response);
    if (contractListResponse.status == 1) {
      if (pageIndex == 1) {
        contractListModel = contractListResponse.data;
        sort(-1);
      } else {
        contractListModel.contracts.addAll(contractListResponse.data.contracts);
        contractListModel.totalRecord = contractListResponse.data.totalRecord;
        contractListModel.searchParam = contractListResponse.data.searchParam;
        sort(sortType, isNeedNotify: false);
      }
      notifyListeners();
      pageIndex++;
    } else {
      showErrorToast(contractListResponse.messages);
    }
    if (refreshController.isRefresh)
      refreshController.refreshCompleted();
    else if (refreshController.isLoading) {
      refreshController.loadComplete();
    }
  }

  refreshData() {
    pageIndex = 1;
    _loadData();
  }

  loadMore({int pageIndex}) {
    if (contractListModel != null) {
      if (contractListModel.totalRecord < take) {
        refreshController.loadComplete();
        return;
      }
    }
    if (pageIndex != null) {
      this.pageIndex = pageIndex;
    }
    _loadData();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
