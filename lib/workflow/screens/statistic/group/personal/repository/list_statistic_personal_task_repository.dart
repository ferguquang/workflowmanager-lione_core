import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_list_group_job_personal_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_personal_response.dart';

class ListStatisticPersonalTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<DataGroupJobPersonal> dataGroupJobs;

  Future<void> getDataForListGroupJob(int idJobGroup) async {
    GetDataGroupJobPersonalRequest _request = GetDataGroupJobPersonalRequest();
    _request.idJobGroup = idJobGroup;

    final response = await apiCaller.get(AppUrl.getDataForListGroupJobPesonal,
        params: _request.getParams());
    GetDataForListGroupJobPesonalResponse _listResponse =
        GetDataForListGroupJobPesonalResponse.fromJson(response);
    if (_listResponse.isSuccess()) {
      this.dataGroupJobs = _listResponse.data;
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }
}
