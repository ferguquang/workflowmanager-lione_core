import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/get_data_group_job_report_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_detail_group_job_report_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';

class StatisticGroupDetailsRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  GetDataForListGroupJobReportRequest request =
      GetDataForListGroupJobReportRequest();

  ListDataChart pieChart;
  List<ListDataChartLine> listDataChartLine = [];
  PerformanceJobGroupAPI performanceJobGroupData;
  List<ListReportUserJobGroupManagerAPI> members = [];
  List<ListJob> listJob;
  double rateNumber = 0.0;
  String performanceRank = "";

  Future<void> getDataDetailGroupJobReport(int idJobGroup) async {
    request.idJobGroup = idJobGroup;
    final response = await apiCaller.get(AppUrl.getDataDetailGroupJobReport,
        params: request.getParams());
    GetDataDetailGroupJobReportModel _reportResponse =
        GetDataDetailGroupJobReportModel.fromJson(response);

    if (_reportResponse.isSuccess()) {
      this.performanceRank =
          _reportResponse.data.performanceChart.performanceRank;
      this.pieChart = _reportResponse.data.listDataChart;
      this.listDataChartLine = _reportResponse.data.listDataChartLine;
      this.performanceJobGroupData =
          _reportResponse.data.performanceChart.performance;
      this.rateNumber = _reportResponse.data.performanceChart.rate.toDouble();
      this.members = _reportResponse.data.listReportUserJobGroupManagerAPI;
      this.listJob = _reportResponse.data.listJob ?? [];
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }

  void resetFilter() {
    this.request = GetDataForListGroupJobReportRequest();
    notifyListeners();
  }
}
