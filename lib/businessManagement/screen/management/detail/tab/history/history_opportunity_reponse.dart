import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/request/history_detail_management_request.dart';
import 'package:workflow_manager/businessManagement/model/response/history_opportunity_response.dart';

class HistoryOpportunityRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataHistoryOpportunity dataHistoryOpportunity = DataHistoryOpportunity();
  List<Histories> listHistories = [];
  int pageIndex = 1;

  Future<bool> getDetailHistories(
      int id, int sort, bool isOpportunityAndContract) async {
    HistoryDetailManagementRequest request = HistoryDetailManagementRequest();
    request.id = id;
    request.sort = sort;
    request.pageIndex = pageIndex;
    // cơ hội: true, hợp đồng false
    final response = await apiCaller.postFormData(
        isOpportunityAndContract
            ? AppUrl.getDetailHistories
            : AppUrl.getContractHistories,
        request.getParams(),
        isLoading: true);

    var baseResponse = HistoryOpportunityResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      dataHistoryOpportunity = baseResponse.data;
      if (pageIndex == 1) {
        listHistories = dataHistoryOpportunity?.histories;
      } else {
        listHistories.addAll(dataHistoryOpportunity?.histories);
      }
      pageIndex++;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }
}
