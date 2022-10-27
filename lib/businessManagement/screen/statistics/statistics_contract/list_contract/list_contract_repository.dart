import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/model/response/top_contract_response.dart';

import '../../../../../main.dart';

class ListContractRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  SearchParam searchParam;
  int pageSize = 10;
  List<ContractInfos> contractInfos;

  Future<bool> getContractListAll(
      int statusTab, OverViewRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getContractListAll, request.getParams());
    request.pageSize = 10;

    var baseResponse = TopContractResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      if (request.pageIndex == 1) {
        contractInfos = baseResponse.data.contractInfos;
      } else {
        this.contractInfos.addAll(baseResponse.data.contractInfos);
      }
      request.pageIndex++;

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
