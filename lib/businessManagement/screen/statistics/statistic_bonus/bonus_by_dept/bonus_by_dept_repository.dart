import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/bonus_branch_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/model/response/statistic_bonus_response.dart';

import '../../../../../main.dart';
import 'bonus_by_dept_screen.dart';

class BonusByDeptRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<ProjectQuaterChartInfos> listChart;
  SearchParam searchParam;

  Future<bool> getBonusDept(int statusTab, OverViewRequest request) async {
    if (statusTab == BonusByDeptScreen.TAB_BONUS_DEPT) {
      final response = await apiCaller.postFormData(
          AppUrl.getBonusDept, request.getParams(),
          isLoading: true);
      StatisticBonusResponse baseResponse =
          StatisticBonusResponse.fromJson(response);
      if (baseResponse.isSuccess()) {
        listChart = baseResponse.data.bonusPBBarChartInfos;
        notifyListeners();
        if (searchParam == null) {
          // truyền cho lọc của thống kê
          eventBus.fire(GetListDataFilterStatisticEventBus(
              numberTabFilter: statusTab,
              searchParam: baseResponse.data.searchParam));
        }
      }
      /*else {
        ToastMessage.show(baseResponse.messages, ToastStyle.error);
      }*/
    } else {
      final response = await apiCaller.postFormData(
          AppUrl.getBonusBranch, request.getParams(),
          isLoading: true);
      BonusBranchResponse baseResponse = BonusBranchResponse.fromJson(response);
      if (baseResponse.isSuccess()) {
        listChart = baseResponse.data.bonusPBBarChartInfos;
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
