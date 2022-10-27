import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_list_group_job_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_response.dart';

class ListStatisticGroupTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<DataGroupJobItem> listGroupJob = [];

  int pageSize = 10;
  int pageIndex = 1;

  void pullToRefreshData() {
    this.pageIndex = 1;
  }

  Future<void> getDataForListGroupJob() async {
    GetDataForListGroupJobRequest _request = GetDataForListGroupJobRequest();
    _request.pageIndex = this.pageIndex;
    _request.pageSize = this.pageSize;

    final response = await apiCaller.get(AppUrl.getDataForListGroupJob,
        params: _request.getParams());
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
}
