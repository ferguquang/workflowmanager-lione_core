import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/create_update_commodity_category_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_category_response.dart';

class CreateUpdateCommodityRepository with ChangeNotifier {
  Categories itemUpdate;

  Future<void> commodityCategoryUpdate(Categories model) async {
    Map<String, dynamic> params = Map();
    params["ID"] = model.iD;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsCommodityCategoryUpdate, params);
    CommodityCategorySaveResponse response = CommodityCategorySaveResponse.fromJson(json);
    itemUpdate = response.data.category;
    notifyListeners();
  }

  Future<Categories> commodityCategorySave(code, name) async {
    CommodityCategorySaveRequest request = CommodityCategorySaveRequest();
    request.code = code;
    request.name = name;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsCommodityCategorySave, request.getParams());
    CommodityCategorySaveResponse response = CommodityCategorySaveResponse.fromJson(json);
    response.isSuccess();
    // ToastMessage.show(response.messages, response.status == 1 ? ToastStyle.success : ToastStyle.error);

    return response.data.category;
  }

  Future<Categories> qlmsCommodityCategoryChange(id, code, name) async {
    CommodityCategoryChangeRequest request = CommodityCategoryChangeRequest();
    request.code = code;
    request.name = name;
    request.id = id;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsCommodityCategoryChange, request.getParams());
    CommodityCategorySaveResponse response = CommodityCategorySaveResponse.fromJson(json);
    response.isSuccess();
    // ToastMessage.show(response.messages, response.status == 1 ? ToastStyle.success : ToastStyle.error);
    return response.data.category;
  }
}