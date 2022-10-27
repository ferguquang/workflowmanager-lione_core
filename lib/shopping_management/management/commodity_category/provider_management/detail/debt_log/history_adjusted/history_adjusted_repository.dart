import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class HistoryAdjustedRepository with ChangeNotifier {
  DataProviderViewDebtLog data;

  Future<void> getProviderViewDebtLog(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsProviderViewDebtLog, params);
    ProviderViewDebtLogResponse response = ProviderViewDebtLogResponse.fromJson(json);
    if (response.status == 1) {
      data = response.data;
      notifyListeners();
    }
  }
}