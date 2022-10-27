import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/price_prefer_params.dart';
import 'package:workflow_manager/shopping_management/response/price_prefer_response.dart';

class PricePreferRepository extends ChangeNotifier {
  PricePreferModel pricePreferModels;
  PricePreferParams params = PricePreferParams();

  Future<bool> choice() async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsSavePriceReferProvider, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    if (baseResponse.status == 1) {
      showSuccessToast("Cập nhật thành công");
      return true;
    } else {
      showErrorToast(baseResponse.messages);
    }
    return false;
  }

  add(List<PriceRefers> news) {
    pricePreferModels.priceRefers.addAll(news);
    notifyListeners();
  }

  loadData(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsPriceReferProvider, params);
    PricePreferResponse response = PricePreferResponse.fromJson(json);
    if (response.status == 1) {
      pricePreferModels = response.data;
      notifyListeners();
    } else {
      showErrorToast(response.messages);
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
