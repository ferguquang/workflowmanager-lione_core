import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_list_group_job_personal_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_manager_response.dart';

class ListStatisticManagerTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<DataMemberItem> dataMembers;

  Future<void> getDataForListGroupJob(int idJobGroup) async {
    GetDataGroupJobPersonalRequest _request = GetDataGroupJobPersonalRequest();
    _request.idJobGroup = idJobGroup;

    final response = await apiCaller.get(AppUrl.getDataForListGroupJobManager,
        params: _request.getParams());
    GetDataForListGroupJobManagerResponse _listResponse =
        GetDataForListGroupJobManagerResponse.fromJson(response);
    if (_listResponse.isSuccess()) {
      this.dataMembers = _listResponse.data;
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }
}
