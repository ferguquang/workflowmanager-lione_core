import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/expected_plan_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

import '../../../../../main.dart';

class ExpectedPlanRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  SearchParam searchParam;
  DataExpectedPlan dataExpectedPlan;

  Future<bool> getExpectedPlan(int statusTab, OverViewRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getExpectedPlan, request.getParams());

    var baseResponse = ExpectedPlanResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      dataExpectedPlan = baseResponse.data;
      notifyListeners();
      if (searchParam == null) {
        // truyền cho lọc của thống kê
        searchParam = baseResponse.data.searchParam;
        eventBus.fire(GetListDataFilterStatisticEventBus(
            numberTabFilter: statusTab, searchParam: searchParam));
      }
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }
}
