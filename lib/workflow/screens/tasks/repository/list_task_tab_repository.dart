import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/custom_tab_bar_widget.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/workflow/models/params/filter_task_request.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';

class ListTaskTabRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<StatusItem> arrayStatuses = List();

  List<Tab> tabItem = List();
  String messageError;
  bool isChangeData = false;

  Future<String> getListFilterTask(int viewType) async {
    FilterTaskRequest request = FilterTaskRequest();
    request.viewType = viewType;
    request.isDeadLine = AppStore.isViewDeadLine;

    final response =
        await apiCaller.get(AppUrl.listForSearch, params: request.getParams());
    FilterTaskResponse filterTaskResponse =
        FilterTaskResponse.fromJson(response);
    if (filterTaskResponse.isSuccess(isDontShowErrorMessage: true)) {
      tabItem.clear();
      arrayStatuses = filterTaskResponse.data.statusesDeadLine;
      arrayStatuses.forEach((element) {
        tabItem.add(Tab(
            child: CustomTabBarWidget(element?.value, element?.total ?? 0)));
      });
      isChangeData = true;
      notifyListeners();
      return null;
    } else {
      // ToastMessage.show(filterTaskResponse.messages, ToastStyle.error);
      messageError = filterTaskResponse.messages;
      notifyListeners();
    }
  }
}
