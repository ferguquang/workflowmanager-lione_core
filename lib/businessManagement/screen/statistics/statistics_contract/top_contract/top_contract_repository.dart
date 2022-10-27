import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/model/response/top_contract_response.dart';

import '../../../../../main.dart';

class TopContractRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  SearchParam searchParam;
  DataTopContract dataTopContract;

  Future<bool> getTopContract(int statusTab, OverViewRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getTopContract, request.getParams());

    var baseResponse = TopContractResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      dataTopContract = baseResponse.data;
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
