import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/create_management_request.dart';
import 'package:workflow_manager/businessManagement/model/request/group_customers_request.dart';
import 'package:workflow_manager/businessManagement/model/request/potential_types_request.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/potentail_type_info_response.dart';
import 'package:workflow_manager/businessManagement/model/response/selected_group_customers_response.dart';

import '../../../../main.dart';
import 'create_management_screen.dart';

class CreateManagementRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataCreateManagement dataCreate;
  DataSelectGroupCustomer dataGroupCustomer;
  DataPotentialTypeInfo dataPotentialTypeInfo;

  //id = null ? create : update
  Future<bool> getProjectPlanCreate(int id, int typeOpportunity) async {
    CreateManagementRequest request = CreateManagementRequest();
    request.id = id;

    final response = await apiCaller.postFormData(
        typeOpportunity == CreateManagementScreen.TYPE_CREATE
            ? AppUrl.getProjectPlanCreate
            : typeOpportunity == CreateManagementScreen.TYPE_EDIT
                ? AppUrl.getProjectPlanUpdate
                : AppUrl.getProjectPlanCopy,
        request.getParams(),
        isLoading: true);

    var baseResponse = CreateManagementResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      dataCreate = baseResponse.data;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }*/
  }

  // nhóm khách hàng
  Future<bool> getSelectGroupCustomer(int idCustomers) async {
    var request = SelectedGroupCustomersRequest();
    request.id = idCustomers;
    final response = await apiCaller.postFormData(
        AppUrl.getSelectCustomer, request.getParams(),
        isLoading: true);

    var baseResponse = SelectGroupCustomerResponse.fromJson(response);

    if (baseResponse.status == 1) {
      dataGroupCustomer = baseResponse.data;
      notifyListeners();
    } else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }
  }

  // Định nghĩa mức độ đánh giá
  Future<bool> getPotentialTypes(int id) async {
    var request = PotentialTypesRequest();
    request.id = id;
    final response = await apiCaller.postFormData(
        AppUrl.getPotentialTypeInfo, request.getParams(),
        isLoading: true);

    var baseResponse = PotentialTypeInfoResponse.fromJson(response);

    if (baseResponse.status == 1) {
      dataPotentialTypeInfo = baseResponse.data;
      notifyListeners();
    } else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
    }
  }

  //save
  Future<bool> getPotentialSave(
      CreateManagementRequest request, int typeOpportunity) async {
    final response = await apiCaller.postFormData(
        typeOpportunity == CreateManagementScreen.TYPE_CREATE ||
                typeOpportunity == CreateManagementScreen.TYPE_COPY
            ? AppUrl.getPotentialSave
            : AppUrl.getProjectPlanChange,
        request.getParams(),
        isLoading: true);

    var baseResponse = PotentialTypeInfoResponse.fromJson(response);

    if (baseResponse.status == 1) {
      ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus.fire(GetDataSaveEventBus(isCheckData: true));
      return true;
    } else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }
  }
}
