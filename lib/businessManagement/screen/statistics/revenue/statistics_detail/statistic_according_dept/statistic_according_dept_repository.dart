import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/model/response/statistic_detail_response.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistic_according_dept/statistic_according_dept_screen.dart';

import '../../../../../../main.dart';

class StatisticAccordingDeptRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataStatisticDetail dataStatisticDetail;
  List<SeriesDept> series = []; // dành cho girdView
  List<SeriesDept> listData = []; // dành cho listView
  SearchParam searchParam;

  Future<bool> getProjecTreportDept(
      int statusTab, OverViewRequest request) async {
    String linkApi = '';
    if (statusTab == StatisticAccordingDeptScreen.TAB_DEPT) {
      linkApi = AppUrl.getdataDetailPartMent;
    } else if (statusTab == StatisticAccordingDeptScreen.TAB_SELLER) {
      linkApi = AppUrl.getDataDetailSeller;
    } else if (statusTab == StatisticAccordingDeptScreen.TAB_AREA) {
      linkApi = AppUrl.getDataDetailRegion;
    } else {
      linkApi = AppUrl.getDataDetailCustomers;
    }

    final response = await apiCaller.postFormData(linkApi, request.getParams());
    var baseResponse = StatisticsDetailResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      dataStatisticDetail = baseResponse.data;
      listData = [];
      if (isNotNullOrEmpty(dataStatisticDetail.projectPlans)) {
        dataStatisticDetail.projectPlans.forEach((element) {
          List<SeriesDept> listDataSeries = element.series;
          if (isNotNullOrEmpty(listDataSeries) && isNullOrEmpty(series)) {
            series = element.series;
          }

          listDataSeries.forEach((element1) {
            element1.year = element.name;
            element1.idYear = element.iD;
          });

          listData.add(new SeriesDept(isHeader: true, name: element.name));
          listData.addAll(element.series);
        });
      }

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

  int getIndexProjectPlan(String idYear) {
    for (int i = 0; i < dataStatisticDetail.projectPlans.length; i++) {
      if (idYear == dataStatisticDetail.projectPlans[i].iD) {
        return i;
      }
    }
  }
}
