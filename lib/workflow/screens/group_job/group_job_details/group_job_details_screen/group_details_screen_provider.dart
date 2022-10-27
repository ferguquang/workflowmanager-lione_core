import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/response/pair_reponse.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_detail_main/group_job_detail_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/change_group_job_status_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/get_group_job_status_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/change_group_job_status_response.dart';

class GroupDetailsHeadProvider extends ChangeNotifier {
  GroupJobDetailModel groupDetailModel;

  GroupDetailsHeadProvider(this.groupDetailModel) {}

  changeTaskDetailModel(GroupJobDetailModel groupDetailModel) {
    this.groupDetailModel = groupDetailModel;
    notifyListeners();
  }

  changeTotalMember(int totalMember) {
    if (groupDetailModel != null) {
      groupDetailModel.totalMember = totalMember;
      notifyListeners();
    }
  }

  Future<List<Pair>> loadStatus(int currentStatus) async {
    GetGroupJobStatusRequest request = GetGroupJobStatusRequest();
    request.statusId = currentStatus;
    var response = await ApiCaller.instance.get(
        AppUrl.getGroupTaskGetListStatusChange,
        params: request.getParams());
    PairResponse statusResponse = PairResponse.fromJson(response);
    if (statusResponse.isSuccess()) {
      return statusResponse.data;
    } else {
      // ToastMessage.show(statusResponse.messages, ToastStyle.error);
      return null;
    }
  }

  Future<bool> changeStatus(int currentStatus, int idGroupJob) async {
    ChangeGroupJobStatusRequest request = ChangeGroupJobStatusRequest();
    request.statusId = currentStatus;
    request.idGroupJob = idGroupJob;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getGroupTaskChangeStatus, request.getParams());
    ChangeGroupJobStatusReponse statusResponse =
        ChangeGroupJobStatusReponse.fromJson(response);
    if (statusResponse.isSuccess() && statusResponse.data != null) {
      groupDetailModel.currentStatus = statusResponse.data;
      notifyListeners();
      return true;
    } else {
      // ToastMessage.show(statusResponse.messages, ToastStyle.error);
      return false;
    }
  }

  changeTotalFile(int totalFile) {
    if (groupDetailModel != null) {
      groupDetailModel.totalFile = totalFile;
      notifyListeners();
    }
  }
}
