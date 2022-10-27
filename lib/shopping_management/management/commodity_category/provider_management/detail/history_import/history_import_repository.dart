import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/shopping_management/response/provider_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class HistoryImportRepository with ChangeNotifier {
  DataProviderDetailDebtLog data;

  Future<void> getProviderDetailDebtLog(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsProviderDetailDebtLog, params);
    ProviderDetailDebtLogResponse response = ProviderDetailDebtLogResponse.fromJson(json);
    if (response.status == 1) {
      data = response.data;
      notifyListeners();
    }
  }
}