import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/search_group_user_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';

class SearchGroupUserRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  int page = 1;
  int _pageSize = 20;
  SearchGroupUserRequest request = SearchGroupUserRequest();
  List<SharedSearchModel> data = [];

  Future<void> getUserByName(
      String name, int iDGroupJob, int iDDept, List<int> userList) async {
    this.request.pageIndex = page;
    this.request.pageSize = _pageSize;
    if (isNotNullOrEmpty(name)) this.request.search_name = name;
    request.userList = userList;
    request.iDDept = iDDept;
    final response = await apiCaller.get(
        AppUrl.getGroupTaskGetListUserByDeptAPI,
        params: this.request.getParams(),
        isLoading: page == 1);
    SharedSearchReponse deptResponse = SharedSearchReponse.fromJson(response);

    if (deptResponse.isSuccess()) {
      if (this.page == 1) {
        this.data = deptResponse.data;
      } else {
        this.data.addAll(deptResponse.data);
      }
      this.page++;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(deptResponse.messages, ToastStyle.error);
    }*/
  }
}
