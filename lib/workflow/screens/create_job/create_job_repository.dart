import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/workflow/models/params/create_job_request.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_create_job_request.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_edit_request.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_create_job_respone.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_edit_respone.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';

class CreateJobRepository extends ChangeNotifier {
  // tạo công việc
  List<Priorities> prioritiesList = List<Priorities>();
  Priorities priorities = Priorities();
  SharedSearchModel jobGroups = SharedSearchModel();
  SharedSearchModel groupJobCol = SharedSearchModel();
  SharedSearchModel jobRecipient = SharedSearchModel();
  List<SharedSearchModel> supervisor = [];
  List<SharedSearchModel> coordinator = [];

  //sửa công việc
  GetDataForEditModel modelEdit = GetDataForEditModel();
  ListStatus status = ListStatus();

  String messageError;

  // tạo công việc
  Future<int> getCreateJob(CreateJobRequest request) async {
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getCreateJob, request.getParams());
    final BaseResponse createJobModel = BaseResponse.fromJson(response);
    if (createJobModel.isSuccess()) {
      ToastMessage.show('Tạo công việc thành công', ToastStyle.success);
      return 1;
    } else {
      // ToastMessage.show(getResponseMessage(response), ToastStyle.error);
      return 0;
      notifyListeners();
    }
  }

  // api create lần đầu tiên vào
  Future<bool> getDataForCreateJob(GetDataForCreateJobRequest request) async {
    var reponse = await ApiCaller.instance
        .get(AppUrl.getDataForCreateJob, params: request.getParams());
    final GetDataForCreateJobResponse getDataForCreateJobResponse =
        GetDataForCreateJobResponse.fromJson(reponse);
    if (getDataForCreateJobResponse.isSuccess()) {
      prioritiesList = getDataForCreateJobResponse.data.priorities;
      if (getDataForCreateJobResponse.data.jobGroups != null) {
        jobGroups = getDataForCreateJobResponse.data.jobGroups;
      }
      if (getDataForCreateJobResponse.data.groupJobCol != null) {
        groupJobCol = getDataForCreateJobResponse.data.groupJobCol;
      }
      notifyListeners();
      return true;
    } else {
      // ToastMessage.show(getDataForCreateJobResponse.messages, ToastStyle.error);
      messageError = getDataForCreateJobResponse.messages;
      notifyListeners();
      return false;
    }
  }

  // sửa công việc
  Future<bool> getDataForEdit(GetDataForEditRequest request) async {
    var response = await ApiCaller.instance
        .get(AppUrl.getDataForEdit, params: request.getParams());
    final GetDataForEditResponse getDataForEditResponse =
        GetDataForEditResponse.fromJson(response);
    if (getDataForEditResponse.isSuccess()) {
      modelEdit = getDataForEditResponse.data;
      prioritiesList = getDataForEditResponse.data.priorities;

      // mức độ
      for (int i = 0; i < prioritiesList.length; i++) {
        if (prioritiesList[i].key == getDataForEditResponse.data.job.priority) {
          priorities = prioritiesList[i];
          break;
        }
      }

      // nhóm công việc
      jobGroups.iD = modelEdit.job?.iDGroupJob;
      jobGroups.name = modelEdit.jobGroupName;

      // cột kanban
      if (modelEdit.groupJobCol != null) {
        groupJobCol.iD = modelEdit.groupJobCol?.iD;
        groupJobCol.name = modelEdit.groupJobCol?.colTitle;
      }

      // người giao việc
      if (modelEdit.jobSupervisors != null) {
        supervisor = modelEdit.jobSupervisors;
      } else {
        supervisor = [];
      }

      // người phối hợp
      if (modelEdit.jobCombination != null) {
        coordinator = modelEdit.jobCombination;
      } else {
        coordinator = [];
      }

      // người nhận việc
      if (modelEdit.jobExecutors != null) {
        // jobRecipient.iD = modelEdit.jobExecutors.iD;
        // jobRecipient.name = modelEdit.jobExecutors.name;
        jobRecipient = modelEdit.jobExecutors;
      } else {
        jobRecipient.name = '--';
      }

      status = modelEdit.currentStatus;
      notifyListeners();
      return true;
    } else {
      // ToastMessage.show(getDataForEditResponse.messages, ToastStyle.error);
      return false;
    }
  }

  // lưu công việc
  Future<int> getSaveDetailJob(CreateJobRequest request) async {
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getSaveDetailJob, request.getParams());
    final BaseResponse editJobModel = BaseResponse.fromJson(response);
    if (editJobModel.isSuccess()) {
      ToastMessage.show('Chỉnh sửa công việc thành công', ToastStyle.success);
      return 1;
    } else {
      // ToastMessage.show(getResponseMessage(response), ToastStyle.error);
      // notifyListeners();
      return 0;
    }
  }
}
