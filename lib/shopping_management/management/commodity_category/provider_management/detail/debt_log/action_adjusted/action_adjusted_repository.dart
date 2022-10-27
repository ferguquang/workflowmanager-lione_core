import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/provider_request.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class ActionAdjustedRepository with ChangeNotifier {
  List<ContentShoppingModel> list = [];

  void addList(DataProviderUpdateDebtLog model) {
    list.add(ContentShoppingModel(
        key: "DebtAmount",
        title: "Số nợ hiện tại",
        value: "${model.debtAmount}",
        isMoney: true,
        isNextPage: false));
    list.add(ContentShoppingModel(
        key: "PaidAmount", title: "Số tiền thanh toán", isMoney: true));
    list.add(ContentShoppingModel(
        key: "RemainAmount",
        title: "Số nợ điều chỉnh",
        isNextPage: false,
        isMoney: true));
  }

  Future<void> getDataProviderUpdateDebtLog(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsProviderUpdateDebtLog, params);
    ProviderUpdateDebtLogResponse response = ProviderUpdateDebtLogResponse.fromJson(json);
    if (response.isSuccess()) {
      addList(response.data);
      notifyListeners();
    }
  }

  void calculate(List<ContentShoppingModel> list, String paidAmountString) {
    if (paidAmountString.isEmpty) {
      paidAmountString = "0";
    }
    double debtAmount = double.parse(list[0].value);
    double paidAmount = double.parse(paidAmountString);
    double remainAmount = debtAmount - paidAmount;
    list[1].value = "$paidAmount";
    list[2].value = "$remainAmount";
    notifyListeners();
  }

  Future<List<ProviderDebts>> getProviderChangeDebt(List<ContentShoppingModel> list, id) async {
    ProviderChangeDebtLogRequest request = ProviderChangeDebtLogRequest();
    request.list = list;
    request.id = id;
    // ProviderChangeDebtLogResponse
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsProviderChangeDebtLog, request.getParams());
    ProviderChangeDebtLogResponse response = ProviderChangeDebtLogResponse.fromJson(json);
    // ToastMessage.show(response.messages, response.status == 1 ? ToastStyle.success : ToastStyle.error);
    if (response.isSuccess()) {
      return response.data.providerDebts;
    } else {
      return null;
    }
  }
}