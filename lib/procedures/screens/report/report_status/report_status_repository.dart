import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/procedures/models/params/list_report_state_request.dart';
import 'package:workflow_manager/procedures/models/response/export_resolve_response.dart';
import 'package:workflow_manager/procedures/models/response/list_report_state_response.dart';
import 'package:workflow_manager/procedures/models/response/search_procedure_model.dart';

class ReportStatusRepository extends ChangeNotifier {

  ApiCaller apiCaller = ApiCaller.instance;

  int pageIndex = 1;
  int _pageSize = 10;

  int rowCount = 0;

  SearchProcedureModel searchProcedureModel = SearchProcedureModel();

  List<RecordReport> listRecordReports = List();

  ListReportStatusRequest reportStatusRequest = ListReportStatusRequest();

  ExportResolveData exportResolveData;

  void pullToRefreshData() {
    pageIndex = 1;
  }

  getDefaultParams() {
    int yearNow = getCurrentYear();
    String monthNow = getCurrentMonth();
    reportStatusRequest.startDate = "01/${monthNow}/${yearNow}";
    reportStatusRequest.endDate = "31/${monthNow}/${yearNow}";
  }

  String getStartDate() {
    int yearNow = getCurrentYear();
    String monthNow = getCurrentMonth();
    return "01/${monthNow}/${yearNow}";
  }

  String getEndDate() {
    int yearNow = getCurrentYear();
    String monthNow = getCurrentMonth();
    return "31/${monthNow}/${yearNow}";
  }

  Future<bool> exportResolveStatusExcel() async {
    final responseJSON = await apiCaller.postFormData(AppUrl.exportResolveStatusExcel, reportStatusRequest.getParams());
    ExportResolveResponse exportResolveResponse = ExportResolveResponse.fromJson(responseJSON);
    if(exportResolveResponse.status == 1) {
      exportResolveData = exportResolveResponse.data;
      return true;
    } else {
      ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      return false;
    }
  }

  Future<void> getListStatusReport() async {
    reportStatusRequest.pageIndex = pageIndex;
    reportStatusRequest.pageSize = _pageSize;

    final responseJSON = await apiCaller.postFormData(AppUrl.listReportState, reportStatusRequest.getParams(), isLoading: pageIndex == 1);
    ListReportStateResponse listReportStateResponse = ListReportStateResponse.fromJson(responseJSON);
    if(listReportStateResponse.status == 1) {
      if (this.pageIndex == 1) {
        rowCount = listReportStateResponse.data.rowCount;
        this.searchProcedureModel.listStates = listReportStateResponse.data.filterStates;
        this.searchProcedureModel.listTypeResolves = listReportStateResponse.data.listTypeResolves;
        this.searchProcedureModel.listServices = listReportStateResponse.data.services;
        this.searchProcedureModel.listDepts = listReportStateResponse.data.listDepts;
        this.searchProcedureModel.listUserRegisters = listReportStateResponse.data.listUserRegisters;
        this.listRecordReports.clear();
      }
      this.listRecordReports.addAll(listReportStateResponse.data.recordReports);
      pageIndex++;
      notifyListeners();
    } else {
      ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }
}