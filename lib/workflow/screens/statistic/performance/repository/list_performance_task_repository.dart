import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/get_list_user_performance_report_request.dart';
import 'package:workflow_manager/workflow/models/response/get_list_user_performance_report_response.dart';

class ListPerformanceTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<DataUserReportItem> listUser = [];

  Future<void> getDataForListGroupJob() async {
    GetListUserPerformanceReportRequest _request =
        GetListUserPerformanceReportRequest();

    final response = await apiCaller.get(AppUrl.getListUserPerformanceReport,
        params: _request.getParams());
    GetListUserPerformanceReportResponse _listResponse =
        GetListUserPerformanceReportResponse.fromJson(response);
    if (_listResponse.isSuccess()) {
      this.listUser = _listResponse.data;
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }
}
