import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/value_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/group_edit_member_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/group_job_member_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/group_remove_member_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_job_member_response.dart';

class MemberRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<GroupJobMemberModel> arrayMember = List();

  setMemberList(List<GroupJobMemberModel> arrayMember) {
    if (arrayMember == null) {
      this.arrayMember = [];
      return;
    }
    this.arrayMember = arrayMember;
    notifyListeners();
  }

  Future<void> loadById(int groupId) async {
    GroupJobMemberRequest params = GroupJobMemberRequest(groupId);
    var response = await ApiCaller.instance.get(
        AppUrl.getGroupTaskGetListUserGroupJob,
        params: params.getParams());
    GroupJobMemberReponse groupJobMemberReponse =
        GroupJobMemberReponse.fromJson(response);
    if (groupJobMemberReponse.isSuccess()) {
      arrayMember = groupJobMemberReponse.data;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(groupJobMemberReponse.messages, ToastStyle.error);
    }*/
  }

  addMember(GroupJobMemberModel memberModel) {
    if (arrayMember == null) arrayMember = List();

    bool isCheck = false;
    arrayMember.forEach((element) {
      if (isNullOrEmpty(element.iDUser)) {
        if (element.iD == memberModel.iD) {
          isCheck = true;
        }
      } else {
        if (element.iDUser == memberModel.iDUser) {
          isCheck = true;
        }
      }
    });
    if (!isCheck) {
      arrayMember.add(memberModel);
      notifyListeners();
    }
  }

  Future<bool> editMember(int groupId, int idMember, int role) async {
    GroupEditMemberRequest request = GroupEditMemberRequest();
    request.memberId = idMember;
    request.groupJobId = groupId;
    request.role = role;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getGroupTaskEditMemberAPI, request.getParams());
    GroupJobMemberReponse groupUserReponse =
        GroupJobMemberReponse.fromJson(response);
    if (groupUserReponse.isSuccess() && groupUserReponse.data != null) {
      editMemberLocal(idMember, role);
      notifyListeners();
      return true;
    } else {
      // ToastMessage.show(groupUserReponse.messages, ToastStyle.error);
      return false;
    }
  }

  editMemberLocal(int idMember, int role) {
    arrayMember.forEach((element) {
      if (element.iD == idMember) {
        element.role = role;
        notifyListeners();
      }
    });
  }

  Future<bool> deleteMember(int groupId, int idMember) async {
    GroupRemoveMemberRequest request = GroupRemoveMemberRequest();
    request.memberId = idMember;
    request.groupJobId = groupId;
    var response = await ApiCaller.instance
        .delete(AppUrl.getGroupTaskDeleteMember, request.getParams());
    ValueResponse<bool> groupUserReponse =
        ValueResponse<bool>.fromJson(response);
    if (groupUserReponse.isSuccess() && groupUserReponse.data == true) {
      removeMember(idMember);
      return true;
    } else {
      // ToastMessage.show(groupUserReponse.messages, ToastStyle.error);
      return false;
    }
  }

  removeMemberLocalByUserID(int idUser) {
    arrayMember
        .removeWhere((GroupJobMemberModel member) => idUser == member.iDUser);
    notifyListeners();
  }

  removeMember(int idMember) {
    arrayMember
        .removeWhere((GroupJobMemberModel member) => idMember == member.iD);
    notifyListeners();
  }
}
