import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_list_group_job_request.dart';
import 'package:workflow_manager/workflow/models/params/get_data_group_job_report_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';

class ChartStatisticGroupTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  ListDataChart pieChart;
  List<ListDataChartLine> listDataChartLine = [];
  PerformanceJobGroupAPI performanceJobGroupData;
  double rateNumber = 0.0;
  String performanceRank = "";

  int pageSize = 200;
  int pageIndex = 1;

  List<DataGroupJobItem> listGroupJob = [];

  GetDataForListGroupJobReportRequest request =
      GetDataForListGroupJobReportRequest();

  Future<void> getDataGroupJobReport() async {
    final response = await apiCaller.get(AppUrl.getDataForListGroupJobReport,
        params: request.getParams());
    GetDataGroupJobReportResponse _reportResponse =
        GetDataGroupJobReportResponse.fromJson(response);
    if (_reportResponse.isSuccess()) {
      this.performanceRank = _reportResponse.data.performanceRank;
      this.pieChart = _reportResponse.data.listDataChart;
      this.listDataChartLine = _reportResponse.data.listDataChartLine;
      this.performanceJobGroupData =
          _reportResponse.data.performanceJobGroupAPI;
      this.rateNumber = _reportResponse.data.rate.toDouble();
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }

  Future<void> getDataForListGroupJob() async {
    GetDataForListGroupJobRequest _requestList =
        GetDataForListGroupJobRequest();
    _requestList.pageIndex = this.pageIndex;
    _requestList.pageSize = this.pageSize;
    _requestList.startDate = this.request.startDate;
    _requestList.endDate = this.request.endDate;
    _requestList.idJobGroup = this.request.idJobGroup;

    final response = await apiCaller.get(AppUrl.getDataForListGroupJob,
        params: _requestList.getParams());
    GetDataForListGroupJobResponse _listResponse =
        GetDataForListGroupJobResponse.fromJson(response);
    if (_listResponse.isSuccess()) {
      if (this.pageIndex == 1) {
        this.listGroupJob = _listResponse.data;
      } else {
        this.listGroupJob.addAll(_listResponse.data);
      }
      this.pageIndex++;
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }

  void resetFilter() {
    this.request = GetDataForListGroupJobReportRequest();
    this.pageIndex = 1;
    notifyListeners();
  }
}
