import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class DebtLogRepository with ChangeNotifier {
  DataProviderDetailDebt data;

  Future<void> getProviderDetailDebt(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsProviderDetailDebt, params);
    ProviderDetailDebtResponse response = ProviderDetailDebtResponse.fromJson(json);
    if (response.status == 1) {
      data = response.data;
      notifyListeners();
    }
  }

  void updateData(List<ProviderDebts> list) {
    data.providerDebts = list;
    notifyListeners();
  }
}