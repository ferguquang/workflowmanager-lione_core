// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:workflow_manager/base/network/api_caller.dart';
// import 'package:workflow_manager/workflow/models/params/get_data_group_job_report_request.dart';
// import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';
// import 'package:workflow_manager/base/network/app_url.dart';
// import 'package:workflow_manager/base/ui/toast_view.dart';
//
// class ChartPerformanceTaskRepository extends ChangeNotifier {
//   ApiCaller apiCaller = ApiCaller.instance;
//
//   ListDataChart pieChart;
//   List<ListDataChartLine> listDataChartLine;
//   PerformanceJobGroupAPI performanceJobGroupData;
//   String performanceRank = "";
//
//   Future<void> getDataGroupJobReport() async {
//     GetDataForListGroupJobReportRequest _request =
//         GetDataForListGroupJobReportRequest();
//
//     final response = await apiCaller.get(AppUrl.getDataPerformanceReport,
//         params: _request.getParams());
//     GetDataGroupJobReportResponse _reportResponse =
//         GetDataGroupJobReportResponse.fromJson(response);
//     if (_reportResponse.status == 1) {
//       this.performanceRank = _reportResponse.data.performanceRank;
//       this.pieChart = _reportResponse.data.listDataChart;
//       this.listDataChartLine = _reportResponse.data.listDataChartLine;
//       this.performanceJobGroupData = _reportResponse.data.performanceJobGroupAPI;
//       notifyListeners();
//     } else {
//       ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
//       notifyListeners();
//     }
//   }
// }
