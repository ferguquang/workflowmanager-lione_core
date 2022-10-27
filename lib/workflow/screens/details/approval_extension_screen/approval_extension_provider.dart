import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/workflow/models/params/reject_task_request.dart';
import 'package:workflow_manager/workflow/models/response/task_detail_response.dart';
import 'package:workflow_manager/workflow/models/response/value_response.dart';

import 'entension_history_response.dart';
import 'job_extension_reponse.dart';

class ApprovalExtensionProvider extends ChangeNotifier {
  List<ExtensionHistoryModel> extensionHistoryModels = [];
  JobExtension jobExtension;

  loadById(int taskId) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = taskId;
    var response = await ApiCaller.instance
        .get(AppUrl.getGetHistoryExtension, params: params);
    ExtensionHistoryResponse tasksResponse =
        ExtensionHistoryResponse.fromJson(response);
    if (tasksResponse.isSuccess()) {
      extensionHistoryModels = tasksResponse.data;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(tasksResponse.messages, ToastStyle.error);
    }*/
  }

  addExtension(int taskId, String newDeadLine, String reason) async {
    Map<String, dynamic> params = Map();
    params["Deadline"] = newDeadLine;
    params["IDJob"] = taskId;
    params["Reason"] = reason;
    var response =
        await ApiCaller.instance.postFormData(AppUrl.getAddExtension, params);
    ChangeExtensionResponse tasksResponse =
        ChangeExtensionResponse.fromJson(response);
    ToastMessage.show(tasksResponse.messages,
        tasksResponse.status == 1 ? ToastStyle.success : ToastStyle.error);

    if (tasksResponse.isSuccess()) {
      jobExtension = tasksResponse.data;
      notifyListeners();
      return jobExtension;
    }
    /*else {
    }*/
    return null;
  }

  approve(int taskId, String newDeadLine, int idExtension) async {
    Map<String, dynamic> params = Map();
    params["NewDeadline"] = newDeadLine;
    params["IDJob"] = taskId;
    params["ID"] = idExtension;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getApproveExtension, params);
    ValueResponse tasksResponse = ValueResponse.fromJson(response);
    if (tasksResponse.isSuccess()) {
      notifyListeners();
      return true;
    }
    /*else {
      ToastMessage.show(tasksResponse.messages, ToastStyle.error);
    }*/
    return false;
  }

  reject(int taskId, int idExtension) async {
    RejectTaskRequest rejectTaskRequest = RejectTaskRequest();
    rejectTaskRequest.idJob = taskId;
    rejectTaskRequest.idExtension = idExtension;

    var response = await ApiCaller.instance
        .postFormData(AppUrl.getRejectExtension, rejectTaskRequest.getParams());
    ValueResponse tasksResponse = ValueResponse.fromJson(response);
    if (tasksResponse.isSuccess()) {
      notifyListeners();
      return true;
    }
    /*else {
      ToastMessage.show(tasksResponse.messages, ToastStyle.error);
    }*/
    return false;
  }
}
