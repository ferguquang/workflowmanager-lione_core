import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';
import 'package:workflow_manager/workflow/models/response/get_list_job_group_response.dart';

class FilterStatisticRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  int _pageSize = 10, pageIndex = 1;

  ListDataChart pieChart = new ListDataChart();
  List<ListDataChartLine> listDataChartLine = [];
  PerformanceJobGroupAPI performanceJobGroupData = new PerformanceJobGroupAPI();
  String performanceRank = "";

  Future<void> getDataGroupJobReport(String searchName) async {
    GetListJobGroupRequest _request = GetListJobGroupRequest();
    _request.searchName = searchName;
    _request.pageSize = this._pageSize;
    _request.pageIndex = this.pageIndex;

    final response = await apiCaller.get(AppUrl.getListJobGroup,
        params: _request.getParams());
    GetListJobGroupResponse _reportResponse =
        GetListJobGroupResponse.fromJson(response);
    if (_reportResponse.isSuccess()) {
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }
}

class GetListJobGroupRequest {
  String searchName;
  int pageIndex;
  int pageSize;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();

    params["SearchName"] = this.searchName;
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = this.pageSize;

    return params;
  }
}
