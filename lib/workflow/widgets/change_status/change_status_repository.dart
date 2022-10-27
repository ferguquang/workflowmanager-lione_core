import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/widgets/change_status/change_updefined_state_reponse.dart';

class ChangeStatusRepository extends ChangeNotifier {
  UserItem userItem;

  changeUser(UserItem userItem) {
    this.userItem = userItem;
    notifyListeners();
  }

  Future<ChangeUndefinedStatusModel> changeUndefinedStatus(
      int jobId, String endDate, int iDExecutor) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = jobId;
    params["EndDate"] = endDate;
    params["IDExecutor"] = iDExecutor;
    var reponse = await ApiCaller.instance
        .postFormData(AppUrl.getChangeUndefinedStatus, params);
    ChangeUndefinedStatusResponse valueResponse =
        ChangeUndefinedStatusResponse.fromJson(reponse);
    if (valueResponse.isSuccess()) {
      return valueResponse.data;
    } else {
      // ToastMessage.show(valueResponse.messages, ToastStyle.error);
      return null;
    }
  }
}
