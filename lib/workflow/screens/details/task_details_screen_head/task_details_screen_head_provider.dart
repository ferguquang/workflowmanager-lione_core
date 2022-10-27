import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/models/response/task_detail_response.dart';
import 'package:workflow_manager/workflow/models/response/value_response.dart';
import 'package:workflow_manager/workflow/screens/details/task_details_screen_head/task_details_screen_head.dart';

import '../back_detail_data.dart';

class TaskDetailsHeadProvider extends ChangeNotifier {
  TaskDetailModel taskDetailModel;
  int taskType;
  ExtensionState extensionState = ExtensionState.None;
  bool isExtensionCompleted = false;
  bool canChangeExecuter() {
    if (taskDetailModel == null) return false;
    List<int> list = [1, 6, 7];
    return !list.contains(taskDetailModel.job.status);
  }

  TaskDetailsHeadProvider(this.taskDetailModel, this.taskType) {
    _changeExtensionState();
  }

  changeTaskDetailModel(TaskDetailModel taskDetailModel) {
    this.taskDetailModel = taskDetailModel;
    _changeExtensionState();
    notifyListeners();
  }

  changeWhenBack(BackDetailData data) {
    if (data == null) return;
    if (data.totalAttachFiles != null)
      taskDetailModel.totalJobFile = data.totalAttachFiles;
    if (data.totalSubJob != null)
      taskDetailModel.totalChildrenJob = data.totalSubJob;
    if (data.totalTodo != null) taskDetailModel.totalJobDetail = data.totalTodo;
    if (data.jobExtension != null)
      taskDetailModel.jobExtension = data.jobExtension;
    if (data.isReject == true) {
      taskDetailModel.jobExtension.status = 3;
    }
    if (data.isApproval == true) {
      taskDetailModel.jobExtension.status = 2;
    }
    if (data.newTransferJobId != null) {
      taskDetailModel.job.iD = data.newTransferJobId;
    }
    if (data.newExcuteId != null) {
      taskDetailModel.job.iDExecutor = data.newExcuteId;
    }
    if (data.statusItem != null) {
      taskDetailModel.jobStatus.value = data.statusItem.value;
      taskDetailModel.jobStatus.key = data.statusItem.key;
      taskDetailModel.jobStatus.color = data.statusItem.color;
    }
    if (data.ratings != null) {
      taskDetailModel.job.rating = data.ratings;
    }
    _changeExtensionState();
    notifyListeners();
  }

  changeStatus(StatusItem statusItem) {
    if (statusItem != null) {
      taskDetailModel.jobStatus.value = statusItem.value;
      taskDetailModel.jobStatus.key = statusItem.key;
      taskDetailModel.jobStatus.color = statusItem.color;
    }
    notifyListeners();
  }

  changeRating(double ratings) {
    if (ratings != null) {
      taskDetailModel.job.rating = ratings;
      notifyListeners();
    }
  }

  _changeExtensionState() {
    if (taskDetailModel.jobExtension.status == 2 ||
        taskDetailModel.jobExtension.status == 3) {
      extensionState = ExtensionState.None;
      return;
    }
    if (taskType == 1) {
      extensionState = taskDetailModel.jobExtension.iD == 0
          ? ExtensionState.Add
          : ExtensionState.Waiting;
    } else if (taskType == 2) {
      extensionState = taskDetailModel.jobExtension.iD == 0
          ? ExtensionState.None
          : ExtensionState.Approve;
    } else {
      extensionState = ExtensionState.None;
    }
  }

  Future<bool> updateProgress(int taskId, int percent) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = taskId;
    params["Value"] = percent;
    var response =
        await ApiCaller.instance.postFormData(AppUrl.getChangePercent, params);
    ValueResponse<bool> progressResponse =
        ValueResponse<bool>.fromJson(response);
    if (progressResponse.isSuccess() && progressResponse.data) {
      taskDetailModel.job.percentCompleted = percent.toDouble();
      notifyListeners();
      return true;
    }
    /*else {
      ToastMessage.show(progressResponse.messages, ToastStyle.error);
    }*/
    return false;
  }

  // Thay đổi người giám sát, người phối hợp
  // type = true: Người giám sát,
  // type = false: Người phối hợp,
  Future<bool> changeJobCoExcuteAndSupervisors(
      int taskID, bool type, List<String> listMembers) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = taskID;
    if (type) {
      params["IDSupervisor"] = listMembers;
    } else {
      params["IDCoExecute"] = listMembers;
    }
    var response = await ApiCaller.instance
        .postFormData(AppUrl.changeJobCoExcuterAndSupervisors, params);
    print("responseeee: ${response}");
    ValueResponse<bool> progressResponse =
        ValueResponse<bool>.fromJson(response);
    if (progressResponse.isSuccess() && progressResponse.data) {
      notifyListeners();
      ToastMessage.show(progressResponse.messages, ToastStyle.success);
      return true;
    }
    /*else {
      ToastMessage.show(progressResponse.messages, ToastStyle.error);
    }*/
    return false;
  }
}
