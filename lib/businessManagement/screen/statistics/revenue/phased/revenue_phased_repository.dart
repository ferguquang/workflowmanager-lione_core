import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/model/response/revenue_phased_response.dart';

import '../../../../../main.dart';

class RevenuePhasedRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataRevenuePhased dataRevenuePhased;
  List<ColorNotes> colorNotes;
  SearchParam searchParam;
  List<ProjectQuaterChartInfos> listDataChartAdministrative =
      []; // tab hành chính

  Future<bool> getDataByStateBusinessManager(
      int statusTab, OverViewRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getDataByStateBusinessManager, request.getParams());
    var baseResponse = RevenuePhasedResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      dataRevenuePhased = baseResponse.data;

      listDataChartAdministrative =
          baseResponse.data.phaseTypeCharts[0].phaseReport;

      colorNotes = baseResponse.data.colorNotes[0].percentNotes;
      notifyListeners();

      // dành doanh thu - theo giai đoạn
      eventBus.fire(GetListDataRevenueEventBus(dataRevenuePhased, colorNotes));

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
