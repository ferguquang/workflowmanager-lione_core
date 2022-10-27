import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/filter_task_request.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';

class FilterTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  FilterTaskData taskData = FilterTaskData();

  // GetListTaskRequest request = GetListTaskRequest();

  Future<void> getListFilterTask(FilterTaskRequest request) async {
    final response =
        await apiCaller.get(AppUrl.listForSearch, params: request.getParams());
    FilterTaskResponse filterTaskResponse =
        FilterTaskResponse.fromJson(response);
    if (filterTaskResponse.isSuccess()) {
      this.taskData = filterTaskResponse.data;
      notifyListeners();
    } else {
      // ToastMessage.show(filterTaskResponse.messages, ToastStyle.error);
      notifyListeners();
    }
  }
}
