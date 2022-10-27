import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/delivery_list_request.dart';
import 'package:workflow_manager/shopping_management/request/general_report_params.dart';
import 'package:workflow_manager/shopping_management/response/delivery_list_response.dart';
import 'package:workflow_manager/shopping_management/response/general_report_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class GeneralReportRepository extends ChangeNotifier {
  GeneralReportModel generalReportModel;
  GeneralReportParams params = GeneralReportParams();
  int sortType;
  int skip;
  int take = 10;
  RefreshController refreshController;
  bool isGeneral;

  _loadData() async {
    params.skip = skip;
    params.take = take;
    var response = await ApiCaller.instance.postFormData(
        isGeneral ? AppUrl.qlmsGeneralReport : AppUrl.qlmsDetailReport,
        params.getParams(),
        isLoading: skip == 1);
    GeneralReportResponse generalReportResponse =
        GeneralReportResponse.fromJson(response);
    if (generalReportResponse.status == 1) {
      if (skip == 1) {
        generalReportModel = generalReportResponse.data;
        sort(-1);
      } else {
        generalReportModel.report.addAll(generalReportResponse.data.report);
        generalReportModel.totalRecord = generalReportResponse.data.totalRecord;
        generalReportModel.searchParam = generalReportResponse.data.searchParam;
        if (sortType != -1) {
          sort(sortType);
        }
      }
      notifyListeners();
      skip++;
    } else {
      showErrorToast(generalReportResponse.messages);
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
    if (generalReportModel != null) {
      if (generalReportModel.totalRecord < take) {
        if (refreshController.isRefresh)
          refreshController.refreshCompleted();
        else if (refreshController.isLoading) {
          refreshController.loadComplete();
        }
        return;
      }
    }
    if (skip != null) {
      this.skip = skip;
    }
    _loadData();
  }

  sort(int type, {bool isNeedNotify = true}) {
    sortType = type;
    if (type != -1) {
      generalReportModel.report.sort((a, b) =>
          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
          a.projectName.toLowerCase().compareTo(b.projectName.toLowerCase()));
    }
    if (isNeedNotify == true) notifyListeners();
  }
}
