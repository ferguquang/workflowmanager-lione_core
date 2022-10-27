import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/get_data_group_job_report_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';

class ChartStatisticManagerTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  ListDataChart pieChart;
  List<ListDataChartLine> listDataChartLine;
  PerformanceJobGroupAPI performanceJobGroupData;
  double rateNumber = 0.0;
  String performanceRank = "";

  Future<void> getDataGroupJobReport(int idJobGropup) async {
    GetDataForListGroupJobReportRequest _request =
        GetDataForListGroupJobReportRequest();
    _request.idJobGroup = idJobGropup;

    final response = await apiCaller.get(AppUrl.getDataGroupJobManagerReport,
        params: _request.getParams());
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
}
