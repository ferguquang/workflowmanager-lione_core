import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/detail_management_request.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_contract_response.dart';

import '../../../../../../../main.dart';

class DetailContractRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  ContractDetail contractDetail;

  // detail
  Future<bool> getContractDetail(int id, bool isOnlyView) async {
    DetailManagementRequest request = DetailManagementRequest();
    request.id = id;

    final response = await apiCaller.postFormData(
        isOnlyView
            ? AppUrl.getGuestPlaceContractDetail
            : AppUrl.getContractDetail,
        request.getParams(),
        isLoading: true);

    DetailContractResponse baseResponse =
        DetailContractResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      contractDetail = baseResponse.data?.contractDetail;
      notifyListeners();
      eventBus.fire(GetDataContractDetailEventBus(contractDetail));
    }
    /* else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }
}
