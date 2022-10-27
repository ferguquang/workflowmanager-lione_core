import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_list_group_job_personal_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_personal_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';

class ListStatisticPersonalTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  ReportDataPersonal reportData;
  UserPersonal userPersonal;
  String performanceRank = "";
  double rate = 0.0;
  ListDataChart pieChart;
  List<ListDataChartLine> listDataChartLine;
  PerformanceJobGroupAPI performanceJobGroupData;

  Future<void> getDataGroupJob(int idJobGroup) async {
    GetDataGroupJobPersonalRequest _request = GetDataGroupJobPersonalRequest();
    _request.idJobGroup = idJobGroup;

    final response = await apiCaller.get(AppUrl.getDataGroupJobReportPersonal,
        params: _request.getParams());
    GetDataGroupJobReportPersonalResponse _reportResponse =
        GetDataGroupJobReportPersonalResponse.fromJson(response);
    if (_reportResponse.isSuccess()) {
      this.reportData = _reportResponse.data;
      this.userPersonal = _reportResponse.data.userPersonal;
      this.performanceRank = _reportResponse.data.performanceRank;
      this.rate = _reportResponse.data.rate;
      this.pieChart = _reportResponse.data.listDataChart;
      this.listDataChartLine = _reportResponse.data.listDataChartLine;
      this.performanceJobGroupData =
          _reportResponse.data.performanceJobGroupAPI;
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }
}
