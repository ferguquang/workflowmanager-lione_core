import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/bonus_top_personal_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

import '../../../../../main.dart';

class BonusTopPersonalRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataTopPersonal dataTopPersonal;
  SearchParam searchParam;

  Future<bool> getBonusDept(int statusTab, OverViewRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getBonusSeller, request.getParams(),
        isLoading: true);
    var baseResponse = BonusTopPersonalResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      dataTopPersonal = baseResponse.data;
      notifyListeners();

      if (searchParam == null) {
        // truyền cho lọc của thống kê
        searchParam = baseResponse.data.searchParam;
        eventBus.fire(GetListDataFilterStatisticEventBus(
            numberTabFilter: statusTab, searchParam: searchParam));
      }
    }
    /* else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }
}
