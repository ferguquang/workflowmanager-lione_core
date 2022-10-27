import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_detail_main/group_job_detail_response.dart';

class GroupJobDetailsScreenProvider extends ChangeNotifier {
  GroupJobDetailModel groupDetailModel;

  loadById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDGroupJob"] = id;

    var response = await ApiCaller.instance
        .get(AppUrl.getGroupTaskGetDataForEdit, params: params);
    GroupJobDetailReponse tasksResponse =
        GroupJobDetailReponse.fromJson(response);
    if (tasksResponse.isSuccess()) {
      groupDetailModel = tasksResponse.data;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(tasksResponse.messages, ToastStyle.error);
    }*/
  }
}
