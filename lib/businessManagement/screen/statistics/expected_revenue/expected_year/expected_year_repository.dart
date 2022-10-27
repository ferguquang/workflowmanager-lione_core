import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/expected_month_response.dart';
import 'package:workflow_manager/businessManagement/model/response/expected_quarter_response.dart';
import 'package:workflow_manager/businessManagement/model/response/expected_year_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

import '../../../../../main.dart';
import 'expected_year_screen.dart';

class ExpectedYearRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<ProjectQuaterChartInfos> listDataChart;
  SearchParam searchParam;

  Future<bool> getExpectedYear(int statusTab, OverViewRequest request) async {
    if (statusTab == ExpectedYearScreen.TAB_EXPECTED_REVENUE) {
      final response = await apiCaller.postFormData(
          AppUrl.getExpectedYear, request.getParams(),
          isLoading: true);
      var baseResponse = ExpectedYearResponse.fromJson(response);
      if (baseResponse.isSuccess()) {
        listDataChart = baseResponse.data.expectedYearBarChartInfos;
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
    } else if (statusTab == ExpectedYearScreen.TAB_EXPECTED_QUARTER) {
      final response = await apiCaller.postFormData(
          AppUrl.getExpectedQuarter, request.getParams(),
          isLoading: true);
      var baseResponse = ExpectedQuarterResponse.fromJson(response);
      if (baseResponse.isSuccess()) {
        listDataChart = baseResponse.data.expectedYearBarChartInfos;
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
    } else {
      final response = await apiCaller.postFormData(
          AppUrl.getExpectedMonth, request.getParams(),
          isLoading: true);
      var baseResponse = ExpectedMonthResponse.fromJson(response);
      if (baseResponse.isSuccess()) {
        listDataChart = baseResponse.data.expectedYearBarChartInfos;
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
}
