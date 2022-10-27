import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/manager_serial_params.dart';
import 'package:workflow_manager/shopping_management/response/manager_serial_list_reponse.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class ManagerSerialListRepository extends ChangeNotifier {
  int sortType = -1;
  ManagerSerialListModel managerSerialListModel;
  ManagerSerialParams params = ManagerSerialParams();
  int skip;
  int take = 10;
  RefreshController refreshController;

  _loadData() async {
    params.skip = skip;
    params.take = take;
    var response = await ApiCaller.instance.postFormData(
        AppUrl.qlmsSerialIndex, params.getParams(),
        isLoading: skip == 1);
    ManagerSerialListResponse managerSerialListResponse =
        ManagerSerialListResponse.fromJson(response);
    if (managerSerialListResponse.status == 1) {
      if (skip == 1) {
        managerSerialListModel = managerSerialListResponse.data;
        sort(-1);
      } else {
        managerSerialListModel.serials
            .addAll(managerSerialListResponse.data.serials);
        managerSerialListModel.totalRecord =
            managerSerialListResponse.data.totalRecord;
        sort(sortType, isNeedNotify: false);
      }
      notifyListeners();
      skip++;
    } else {
      showErrorToast(managerSerialListResponse.messages);
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

  loadMore({int pageIndex}) {
    if (managerSerialListModel != null) {
      if (managerSerialListModel.totalRecord < take) {
        refreshController.loadComplete();
        return;
      }
    }
    if (pageIndex != null) {
      this.skip = pageIndex;
    }
    _loadData();
  }

  sort(int type, {bool isNeedNotify = true}) {
    sortType = type;
    if (type != -1) {
      managerSerialListModel.serials.sort((a, b) =>
          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
          a.project.toLowerCase().compareTo(b.project.toLowerCase()));
    }
    if (isNeedNotify == true) notifyListeners();
  }

  Future<bool> delete(int id) async {
    var json =
        await ApiCaller.instance.delete(AppUrl.qlmsSerialRemove, {"ID": id});
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
