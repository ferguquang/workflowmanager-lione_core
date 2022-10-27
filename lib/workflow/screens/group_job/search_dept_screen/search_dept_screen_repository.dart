import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/search_dept_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_dept_response.dart';

class SearchDeptScreenRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<GroupDeptModel> deptData = new List();

  int page = 1;
  int _pageSize = 20;

  SearchDeptRequest request = SearchDeptRequest();

  Future<void> getDeptName(String name) async {
    this.request.pageIndex = page;
    this.request.pageSize = _pageSize;
    if (isNotNullOrEmpty(name)) this.request.search_name = name;

    final response = await apiCaller.get(AppUrl.getGroupTaskGetListDeptAPI,
        params: this.request.getParams(), isLoading: page == 1);
    GroupDeptReponse deptResponse = GroupDeptReponse.fromJson(response);

    if (deptResponse.isSuccess()) {
      if (this.page == 1) {
        this.deptData = deptResponse.data;
      } else {
        this.deptData.addAll(deptResponse.data);
      }
      this.page++;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(deptResponse.messages, ToastStyle.error);
    }*/
  }
}
