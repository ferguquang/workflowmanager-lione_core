import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

import '../../../../../main.dart';

class OverViewRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataOverView dataOverView;
  SearchParam searchParam;
  List<ColorNotes> colorNotes;

  Future<bool> getProjecTreportIndex(
      int statusTab, OverViewRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getProjecTreportIndex, request.getParams(),
        isLoading: true);
    var baseResponse = OverViewResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      dataOverView = baseResponse.data;
      colorNotes = baseResponse.data.colorNotes[0].percentNotes;
      notifyListeners();

      // dành cho tab là Tổng quan - theo kế hoạch
      eventBus.fire(GetListDataOverviewEventBus(dataOverView, colorNotes));

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
