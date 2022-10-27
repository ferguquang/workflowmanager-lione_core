import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/group_add_member_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_dept_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_job_member_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_member_reponse.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_user_reponse.dart';

class AddMemberRepository extends ChangeNotifier {
  GroupUserModel groupUserModel;
  GroupDeptModel dept;
  ApiCaller apiCaller = ApiCaller.instance;
  int role = 2;

  changeRole(int role) {
    this.role = role;
    notifyListeners();
  }

  changeDept(GroupDeptModel dept) {
    this.dept = dept;
    notifyListeners();
  }

  changeUser(GroupUserModel groupUserModel) {
    this.groupUserModel = groupUserModel;
    notifyListeners();
  }

  getUserById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDEmp"] = id;
    var response = await ApiCaller.instance
        .get(AppUrl.getGroupTaskGetInfoUserAPI, params: params);
    GroupUserReponse groupUserReponse = GroupUserReponse.fromJson(response);
    if (groupUserReponse.isSuccess()) {
      groupUserModel = groupUserReponse.data;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(groupUserReponse.messages, ToastStyle.error);
    }*/
  }

  getMemberById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDEmp"] = id;
    var response = await ApiCaller.instance
        .get(AppUrl.getGroupTaskGetInfoUserAPI, params: params);
    GroupUserReponse groupUserReponse = GroupUserReponse.fromJson(response);
    if (groupUserReponse.isSuccess()) {
      groupUserModel = groupUserReponse.data;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(groupUserReponse.messages, ToastStyle.error);
    }*/
  }

  Future<GroupJobMemberModel> addMember(
      int groupId, int idMember, int role) async {
    GroupAddMemberRequest request = GroupAddMemberRequest();
    request.memberId = idMember;
    request.groupJobId = groupId;
    request.role = role;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getGroupTaskAddMember, request.getParams());
    GroupMemberReponse groupMemberReponse =
        GroupMemberReponse.fromJson(response);
    if (groupMemberReponse.isSuccess()) {
      notifyListeners();
      return groupMemberReponse.data;
    } else {
      // ToastMessage.show(groupMemberReponse.messages, ToastStyle.error);
      return null;
    }
  }
}
