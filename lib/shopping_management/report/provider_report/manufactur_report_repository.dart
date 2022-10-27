import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/delivery_list_request.dart';
import 'package:workflow_manager/shopping_management/request/general_report_params.dart';
import 'package:workflow_manager/shopping_management/request/manufactur_report_request.dart';
import 'package:workflow_manager/shopping_management/request/manufacture_request.dart';
import 'package:workflow_manager/shopping_management/request/progress_report_params.dart';
import 'package:workflow_manager/shopping_management/response/delivery_list_response.dart';
import 'package:workflow_manager/shopping_management/response/general_report_response.dart';
import 'package:workflow_manager/shopping_management/response/manufactur_report_response.dart';
import 'package:workflow_manager/shopping_management/response/manufacture_response.dart';
import 'package:workflow_manager/shopping_management/response/progress_report_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class ManufacturReportRepository extends ChangeNotifier {
  ManufacturReportModel manufacturReportModel;
  ManufacturReportParams params = ManufacturReportParams();
  int sortType;
  int skip;
  int take = 20;
  RefreshController refreshController;
  bool isGeneral;

  _loadData() async {
    params.skip = skip;
    params.take = take;
    var response = await ApiCaller.instance.postFormData(
        AppUrl.qlmsManufacturReport, params.getParams(),
        isLoading: skip == 1);
    ManufacturReportResponse progressReportResponse =
        ManufacturReportResponse.fromJson(response);
    if (progressReportResponse.status == 1) {
      if (skip == 1) {
        manufacturReportModel = progressReportResponse.data;
        sort(-1);
      } else {
        manufacturReportModel.report.addAll(progressReportResponse.data.report);
        manufacturReportModel.totalRecord =
            progressReportResponse.data.totalRecord;
        manufacturReportModel.manufacturs =
            progressReportResponse.data.manufacturs;
        if (sortType != -1) {
          sort(sortType);
        }
      }
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
    if (manufacturReportModel != null) {
      if (manufacturReportModel.totalRecord < take) return;
    }
    if (skip != null) {
      this.skip = skip;
    }
    _loadData();
  }

  sort(int type, {bool isNeedNotify = true}) {
    sortType = type;
    if (type != -1) {
      manufacturReportModel.report.sort((a, b) =>
          (type == SortNameBottomSheet.SORT_A_Z ? 1 : -1) *
          a.manufactur.toLowerCase().compareTo(b.manufactur.toLowerCase()));
    }
    if (isNeedNotify == true) notifyListeners();
  }
}
