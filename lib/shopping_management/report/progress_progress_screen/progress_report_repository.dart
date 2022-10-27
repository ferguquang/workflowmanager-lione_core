import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/progress_report_params.dart';
import 'package:workflow_manager/shopping_management/request/progress_report_po_by_requisition.dart';
import 'package:workflow_manager/shopping_management/response/progress_report_pr_response.dart';
import 'package:workflow_manager/shopping_management/response/progress_report_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class ProgressReportRepository extends ChangeNotifier {
  ProgressReportModel progressReportModel;
  ProgressReportParams params = ProgressReportParams();
  int sortType;
  int skip;
  int take = 10;
  RefreshController refreshController;
  bool isGeneral;

  List<SearchObject> contracts;
  List<SearchObject> requisitions;

  _loadData() async {
    params.skip = skip;
    params.take = take;
    var response = await ApiCaller.instance.postFormData(
        AppUrl.qlmsProgressReport, params.getParams(),
        isLoading: skip == 1);
    ProgressReportResponse progressReportResponse =
        ProgressReportResponse.fromJson(response);
    if (progressReportResponse.status == 1) {
      if (skip == 1) {
        progressReportModel = progressReportResponse.data;
        sort(-1);
      } else {
        progressReportModel.report.addAll(progressReportResponse.data.report);
        progressReportModel.totalRecord =
            progressReportResponse.data.totalRecord;
        progressReportModel.searchParam =
            progressReportResponse.data.searchParam;
        if (sortType != -1) {
          sort(sortType);
        }
      }
      contracts = progressReportModel.searchParam.contracts;
      requisitions = progressReportModel.searchParam.requisitions;
      notifyListeners();
      skip++;
    } else {
      showErrorToast(progressReportResponse.messages);
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
    if (progressReportModel != null) {
      if (progressReportModel.totalRecord < take) return;
    }
    if (skip != null) {
      this.skip = skip;
    }
    _loadData();
  }
  getPRByProject(int projectId) async {
    var json = await ApiCaller.instance
        .get(AppUrl.qlmsGetRequisitionsByProjectRp, params: {"ID": projectId});
    ProgressReportPRResponse response = ProgressReportPRResponse.fromJson(json);
    if (response.isSuccess()) {
      progressReportModel.searchParam.requisitions = response.data.requisitions;
    }
  }

  getByPR(int prId) async {
    var json = await ApiCaller.instance
        .get(AppUrl.qlmsGetContractsByRequisition, params: {"ID": prId});
    ProgressReportPOByRequisitionResponse response =
        ProgressReportPOByRequisitionResponse.fromJson(json);
    if (response.isSuccess()) {
      progressReportModel.searchParam.contracts = response.data.contracts;
    }
  }

  sort(int type, {bool isNeedNotify = true}) {
    sortType = type;
    if (type != -1) {
      progressReportModel.report.sort((a, b) =>
          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
          a.project.toLowerCase().compareTo(b.project.toLowerCase()));
    }
    if (isNeedNotify == true) notifyListeners();
  }
}
