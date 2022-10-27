import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/list_position_dept_selected_model.dart';
import 'package:workflow_manager/procedures/models/response/register_create_response.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';
import 'package:workflow_manager/procedures/models/response/user_info_response.dart';

class AssignRepository extends ChangeNotifier {
  UserInfoModel userInfoModel;
  List<User> users = [];
  List<HandlerInfo> teams = [];
  List<HandlerInfo> depts = [];
  List<ListPositionDeptSelectedModel> positionAndDepts = [];

  loadData() async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.getQTTTRegisterUserInfo, Map());
    var response = UserInfoResponse.fromJson(json);
    if (response.status == 1) {
      userInfoModel = response.data;
      for (User user in userInfoModel.userInfo.users) {
        if (isNotNullOrEmpty(user.avatar))
          user.avatar = await SharedPreferencesClass.get(
                  SharedPreferencesClass.ROOT_KEY) +
              user.avatar;
      }
      notifyListeners();
    } else {
      showErrorToast(response.messages);
    }
  }

  setUsers(List<User> users) {
    this.users = users;
    notifyListeners();
  }

  removeUser(int index) {
    users.removeAt(index);
    notifyListeners();
  }

  setDepts(List<HandlerInfo> depts) {
    this.depts = depts;
    notifyListeners();
  }

  removeDept(int index) {
    depts.removeAt(index);
    notifyListeners();
  }

  setTeams(List<HandlerInfo> teams) {
    this.teams = teams;
    notifyListeners();
  }

  setData(List<HandlerInfo> teams, List<HandlerInfo> depts, List<User> users,
      List<ListPositionDeptSelectedModel> positionAndDepts) {
    this.teams = teams;
    this.depts = depts;
    this.users = users;
    this.positionAndDepts = positionAndDepts;
    notifyListeners();
  }

  removeTeam(int index) {
    teams.removeAt(index);
    notifyListeners();
  }

  setPositionAndDepts(List<ListPositionDeptSelectedModel> positionAndDepts) {
    this.positionAndDepts = positionAndDepts;
    notifyListeners();
  }

  addPositionAndDept(ListPositionDeptSelectedModel positionAndDept) {
    if (positionAndDepts == null) positionAndDepts = [];
    positionAndDepts.add(positionAndDept);
    notifyListeners();
  }

  updatePositionAndDept(ListPositionDeptSelectedModel positionAndDept) {
    if (positionAndDepts == null) positionAndDepts = [];
    var index = positionAndDepts.indexOf(positionAndDept);
    positionAndDepts.removeAt(index);
    positionAndDepts.insert(index, positionAndDept);
    notifyListeners();
  }

  removePositionAndDept(int index) {
    positionAndDepts.removeAt(index);
    notifyListeners();
  }
}
