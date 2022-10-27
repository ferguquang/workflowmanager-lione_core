import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/add_new_provider_params.dart';

class AddNewProviderRepository extends ChangeNotifier {
  AddNewProviderParams params = AddNewProviderParams();

  Future<bool> create() async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsProviderSave, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    if (baseResponse.status != 1) {
      showErrorToast(baseResponse.messages);
    }
    return baseResponse.status == 1;
  }

  Future<bool> save() async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsProviderChange, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    if (baseResponse.status != 1) {
      showErrorToast(baseResponse.messages);
    }
    return baseResponse.status == 1;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
