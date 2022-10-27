import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/params/create_group_request.dart';
import 'package:workflow_manager/workflow/models/params/edit_group_request.dart';
import 'package:workflow_manager/workflow/models/params/group_task_request.dart';
import 'package:workflow_manager/workflow/models/response/data_new_group_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_edit_respone.dart';
import 'package:workflow_manager/workflow/models/response/list_group_task_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/get_group_job_status_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_job_member_response.dart';

// besiness của màn hình Nhóm công việc
class GroupTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  int pageIndex = 1;
  int _pageSize = 10;
  List<GroupTask> list = [];
  int totalJobGroup;

  // List<StatusGroup> status = [];
  List<StatusGroup> statusFilter = [];
  GroupTaskRequest groupTaskRequest = GroupTaskRequest();
  NewGroupData newGroupData = NewGroupData();
  bool isShowFunction = false;
  bool canCreateAndDeleteGroupJob = false;

  bool getShowFunction() {
    return isShowFunction;
  }

  void pullToRefreshData() {
    pageIndex = 1;
  }

  Future<ListStatus> getDefaultStatus() async {
    return newGroupData.listStatus?.firstWhere((element) => element.key == 1);
  }

  Future<void> deleteGroupTask(
      String idGroupJobs, List<GroupTask> listSelected) async {
    DeleteGroupTaskRequest deleteGroupTaskRequest = DeleteGroupTaskRequest();
    deleteGroupTaskRequest.idGroupJobs = idGroupJobs;
    final responseJSON = await apiCaller.delete(
        AppUrl.deleteGroupTask, deleteGroupTaskRequest.getParams());
    DeleteGroupResponse response = DeleteGroupResponse.fromJson(responseJSON);
    ToastMessage.show(getResponseMessage(responseJSON),
        response.status == 1 ? ToastStyle.success : ToastStyle.error);
    pullToRefreshData();
    getListGroup();
  }

  Future<void> changeStatusForList(String ids, int status) async {
    ChangeStatusRequest changeStatusRequest = ChangeStatusRequest();
    changeStatusRequest.idGroupJobs = ids;
    changeStatusRequest.status = status;
    Map<String, dynamic> params = Map<String, dynamic>();
    params = changeStatusRequest.getParams();
    final responseJSON =
        await apiCaller.postFormData(AppUrl.changeStatusForList, params);
    DeleteGroupResponse response = DeleteGroupResponse.fromJson(responseJSON);

    ToastMessage.show(getResponseMessage(responseJSON),
        response.status == 1 ? ToastStyle.success : ToastStyle.error);

    pullToRefreshData();
    getListGroup();
  }

  Future<void> updateShowFunction(bool isShow) async {
    isShowFunction = isShow;
    for (int i = 0; i < list.length; i++) {
      list[i].isShowFunction = isShow;
      list[i].isSelected = false;
    }
    notifyListeners();
  }

  Future<void> updateSelected(GroupTask groupTask, int position) {
    groupTask.isSelected = !groupTask.isSelected;
    list[list.indexWhere((element) => element.iD == groupTask.iD)] = groupTask;
    notifyListeners();
  }

  Future<void> updateList(List<GroupTask> listUpdate) {
    this.list.clear();
    this.list = listUpdate;
    notifyListeners();
  }

  Future<void> getListGroup() async {
    groupTaskRequest.pageIndex = pageIndex;
    groupTaskRequest.pageSize = _pageSize;
    final responseJSON = await apiCaller.postFormData(
        AppUrl.getListGroupTask, groupTaskRequest.getParams(),
        isLoading: pageIndex == 1);
    ListGroupTaskResponse response =
        ListGroupTaskResponse.fromJson(responseJSON);
    totalJobGroup = response.data.totalJobGroup;
    if (response.isSuccess()) {
      canCreateAndDeleteGroupJob = response.data.canCreateAndDeleteGroupJob;
      eventBus.fire(GetRoleForGroupList(canCreateAndDeleteGroupJob));
      if (this.pageIndex == 1) {
        this.list = response.data.result;
      } else {
        this.list.addAll(response.data.result);
      }
      pageIndex++;
      notifyListeners();
    }
  }

  // AppUrl.getGroupTaskGetListStatusChange
  Future<void> getListStatusChange(int status) async {
    GetGroupJobStatusRequest request = GetGroupJobStatusRequest();
    request.statusId = status;
    var responseJSON = await ApiCaller.instance.get(
        AppUrl.getGroupTaskGetListStatusChange,
        params: request.getParams());
    ChangeStatusListResponse response =
        ChangeStatusListResponse.fromJson(responseJSON);
    statusFilter = response.data;
    notifyListeners();
  }

  // Future<void> getStatusGroupTask() async {
  //   final responseJSON = await apiCaller.get(AppUrl.getTaskStatus, params: Map<String, dynamic>());
  //   StatusGroupResponse response = StatusGroupResponse.fromJson(responseJSON);
  //   await SharedPreferencesClass.save(SharedPreferencesClass.LIST_STATUS_GROUP, responseJSON.toString());
  //   if (response.status == 1) {
  //     status = response.data;
  //     notifyListeners();
  //   }
  // }

  // get data for new group screen
  Future<void> getDataNewGroup() async {
    final responseJSON = await apiCaller.get(AppUrl.getDataForNewGroup,
        params: Map<String, dynamic>());
    DataNewGroupResponse response = DataNewGroupResponse.fromJson(responseJSON);
    if (response.isSuccess()) {
      newGroupData = response.data;
      notifyListeners();
    }
  }

  // Lấy mảng id của member
  String getListIdMember(List<GroupJobMemberModel> arrayMember) {
    String arrayId = "";
    arrayMember.forEach((element) {
      if (arrayId.length == 0) {
        arrayId = "\'${element.iDUser}\'";
      } else {
        arrayId += "\'${element.iDUser}\'";
      }
    });
    return "[$arrayId]";
  }

  // Lấy mảng role của member
  String getListRoleMember(List<GroupJobMemberModel> arrayMember) {
    String arrayRole = "";
    arrayMember.forEach((element) {
      if (arrayRole.length == 0) {
        arrayRole = "\'${element.role}\'";
      } else {
        arrayRole += "\'${element.role}\'";
      }
    });
    return "[$arrayRole]";
  }

  // create new group
  Future<bool> createNewGroup(CreateGroupRequest request) async {
    final responseJSON = await apiCaller.postFormData(
        AppUrl.createNewGroup, request.getParams());
    BaseResponse createGroupResponse = BaseResponse.fromJson(responseJSON);
    if (createGroupResponse.isSuccess(isShowSuccessMessage: true)) {
      ToastMessage.show("Tạo nhóm công việc thành công", ToastStyle.success);
      notifyListeners();
      return true;
    } else {
      // ToastMessage.show(getResponseMessage(responseJSON), ToastStyle.error);
      notifyListeners();
      return false;
    }
  }

  // edit group
  Future<bool> editGroup(EditGroupRequest request) async {
    final responseJSON =
        await apiCaller.postFormData(AppUrl.editGroup, request.getParams());
    BaseResponse createGroupResponse = BaseResponse.fromJson(responseJSON);
    if (createGroupResponse.isSuccess(isShowSuccessMessage: true)) {
      ToastMessage.show(
          "Chỉnh sửa nhóm công việc thành công", ToastStyle.success);
      notifyListeners();
      return true;
    } else {
      // ToastMessage.show(createGroupResponse.messages, ToastStyle.error);
      notifyListeners();
      return false;
    }
  }

  // api trạng thái khi nhấn vào nhóm công việc
  List<StatusGroup> status = [];
  Future<void> getStatusGroupTask() async {
    final responseJSON = await apiCaller.get(AppUrl.getTaskStatus,
        params: Map<String, dynamic>(), isLoading: true);
    StatusGroupResponse response = StatusGroupResponse.fromJson(responseJSON);
    // await SharedPreferencesClass.save(SharedPreferencesClass.LIST_STATUS_GROUP_KEY, responseJSON.toString());
    if (response.isSuccess()) {
      status = response.data;
      notifyListeners();
    }
  }
}

class GetRoleForGroupList {
  bool canCreateAndDeleteGroupJob;

  GetRoleForGroupList(this.canCreateAndDeleteGroupJob);
}
