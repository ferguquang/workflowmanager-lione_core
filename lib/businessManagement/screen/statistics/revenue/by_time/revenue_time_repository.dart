import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/model/response/revenue_time_response.dart';

import '../../../../../main.dart';

class RevenueTimeRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataRevenueTime dataRevenueTime;
  List<ColorNotes> listDotActual;
  SearchParam searchParam;
  List<ProjectQuaterChartInfos> listDataChart = []; // list chart

  Future<bool> getByTheTimeReport(
      int statusTab, OverViewRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getByTheTimeReport, request.getParams());
    var baseResponse = RevenueTimeResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      dataRevenueTime = baseResponse.data;
      listDotActual = baseResponse.data.colorNotes[0].percentNotes;
      listDataChart.clear();
      dataRevenueTime.timeReport.forEach((element) {
        listDataChart.add(
            new ProjectQuaterChartInfos(isHeader: true, year: element?.label));
        element?.times?.forEach((element1) {
          // element1?.year = element?.label;
          element1?.lable = '${element1?.lable} (${element?.label})';
          listDataChart.add(element1);
        });
        // listDataChart.addAll(element?.times);
      });

      if (searchParam == null) {
        // truyền cho lọc của thống kê
        searchParam = baseResponse.data.searchParam;
        eventBus.fire(GetListDataFilterStatisticEventBus(
            numberTabFilter: statusTab, searchParam: searchParam));
      }

      notifyListeners();
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }
}
