import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/imodule_response.dart';

import '../../main.dart';

class BusinessManagementRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  DataIModule iModule;

  // quyền hiển thị
  Future<bool> getIModule() async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    final response = await apiCaller.postFormData(AppUrl.getIModule, params);

    var getIModuleResponse = IModuleResponse.fromJson(response);

    if (getIModuleResponse.isSuccess()) {
      iModule = getIModuleResponse.data;
      eventBus.fire(GetDataIsOnlyViewEventBus(isOnlyView: iModule.isKhach));
      notifyListeners();
    }
    /*else {
      ToastMessage.show(getIModuleResponse.messages, ToastStyle.error);
    }*/
  }
}
