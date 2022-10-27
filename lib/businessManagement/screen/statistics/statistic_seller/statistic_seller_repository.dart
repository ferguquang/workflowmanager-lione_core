import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/statistic_seller_response.dart';

import '../../../../main.dart';

class StatisticSellerRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<int> years;
  List<SellerInfos> listSeller = [];
  int pageSize = 10;

  Future<bool> getTopSeller(OverViewRequest request) async {
    request.pageSize = pageSize;

    final response = await apiCaller.postFormData(
        AppUrl.getTopSeller, request.getParams(),
        isLoading: true);

    var baseResponse = StatisticSellerResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      if (request.pageIndex == 1) {
        years = baseResponse.data.searchParam.years;
        listSeller = baseResponse.data.sellerInfos;
      } else {
        listSeller.addAll(baseResponse.data.sellerInfos);
      }

      notifyListeners();
      // không có lọc, truyền null để ẩn icon
      eventBus.fire(GetListDataFilterStatisticEventBus());
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }
}
