import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/request/choose_provider_params.dart';
import 'package:workflow_manager/shopping_management/response/choose_provider_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class ChooseProviderRepository extends ChangeNotifier {
  int take = 10;
  int pageIndex = 1;
  ChooseProvider chooseProvider;
  RefreshController refreshController;
  ChooseProviderParams params = ChooseProviderParams();
  bool isBrowse;
  List<Requisitions> checkedList = [];
  int sortType = -1;

  _loadData() async {
    params.pageIndex = pageIndex;
    params.take = take;
    String api = isBrowse
        ? AppUrl.qlmsConfirmProviderIndex
        : AppUrl.qlmsChooseProviderIndex;
    var response = await ApiCaller.instance
        .postFormData(api, params.getParams(), isLoading: pageIndex == 1);
    ChooseProviderResponse chooseProviderResponse =
        ChooseProviderResponse.fromJson(response);
    if (chooseProviderResponse.status == 1) {
      if (pageIndex == 1) {
        chooseProvider = chooseProviderResponse.data;
        checkedList = [];
        sort(-1);
      } else {
        chooseProvider.requisitions
            .addAll(chooseProviderResponse.data.requisitions);
        chooseProvider.totalRecord = chooseProviderResponse.data.totalRecord;
        chooseProvider.searchParam = chooseProviderResponse.data.searchParam;
        if (sortType != -1) {
          sort(sortType);
        }
      }
      notifyListeners();
      pageIndex++;
    } else {
      showErrorToast(chooseProviderResponse.messages);
    }
    if (refreshController.isRefresh)
      refreshController.refreshCompleted();
    else if (refreshController.isLoading) {
      refreshController.loadComplete();
    }
  }

  sort(int type) {
    sortType = type;
    if (type != -1) {
      chooseProvider.requisitions.sort((a, b) =>
          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
          a.requisitionNumber
              .toLowerCase()
              .compareTo(b.requisitionNumber.toLowerCase()));
    }
    notifyListeners();
  }

  refreshData() {
    pageIndex = 1;
    _loadData();
  }

  loadMore({int pageIndex}) {
    if (chooseProvider != null) {
      if (chooseProvider.totalRecord < take) return;
    }
    if (pageIndex != null) {
      this.pageIndex = pageIndex;
    }
    _loadData();
  }

  Future<bool> approve(BuildContext context) async {
    Map<String, dynamic> params = Map();
    String sendIDs = "[" + checkedList.map((e) => e.iD).join(", ") + "]";
    // if (checkedList.length == 1) {
    //   params["IDs"] = checkedList[0].iD;
    // } else {
      params["IDs"] = sendIDs;
    // }
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsConfirmProviderMutilApproval, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    if (baseResponse.status == 1) {
      showSuccessToast(baseResponse.messages);
    } else {
      showErrorToast(baseResponse.messages);
    }
    return baseResponse.status == 1;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
