import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/shared_search_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';

class ShareSearchScreenRepository extends ChangeNotifier {
  String apiLink;
  Map<String, dynamic> params;
  ApiCaller apiCaller = ApiCaller.instance;
  List<SharedSearchModel> sharedSearchData = new List();
  int page = 1;
  int _pageSize = 20;

  SharedSearchRequest request = SharedSearchRequest();

  ShareSearchScreenRepository(this.apiLink, {this.params});

  Future<void> getByName(String name) async {
    this.request.pageIndex = page;
    this.request.pageSize = _pageSize;
    if (isNotNullOrEmpty(name)) this.request.search_name = name;
    Map<String, dynamic> params = this.request.getParams();
    if (this.params != null) params.addAll(this.params);
    final response =
        await apiCaller.get(apiLink, params: params, isLoading: false);
    SharedSearchReponse userResponse = SharedSearchReponse.fromJson(response);

    if (userResponse.isSuccess()) {
      if (this.page == 1) {
        this.sharedSearchData = userResponse.data;
      } else {
        this.sharedSearchData.addAll(userResponse.data);
      }
      this.page++;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(userResponse.messages, ToastStyle.error);
    }*/
  }
}
