import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/request/commodity_category_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_category_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class CommodityCategoryRepository with ChangeNotifier {
  CommodityCategoryRequest request = CommodityCategoryRequest();
  DataCommodityCategory dataCommodityCategory = DataCommodityCategory();

  int skip = 1;
  int _take = 10;

  void pullToRefreshData() {
    skip = 1;
  }

  Future<void> getCommodityCategoryIndex() async {
    request.skip = skip;
    request.take = _take;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsCommodityCategoryIndex, request.getParams(), isLoading: skip == 1);
    CommodityCategoryIndexResponse response = CommodityCategoryIndexResponse.fromJson(json);
    if (response.isSuccess()) {
      dataCommodityCategory.isCreate = response.data.isCreate;
      dataCommodityCategory.totalRecord = response.data.totalRecord;
      if (this.skip == 1) {
        dataCommodityCategory.categories = response.data.categories;
      } else {
        dataCommodityCategory.categories.addAll(response.data.categories.toList());
      }
      skip++;
      notifyListeners();
    }
  }

  void updateList(List<Categories> list) {
    dataCommodityCategory.categories = list;
    notifyListeners();
  }

  Future<void> addItemCommodity(Categories item) async {
    dataCommodityCategory.categories.insert(0, item);
    notifyListeners();
  }

  void updateItem(Categories item) {
    dataCommodityCategory.categories[dataCommodityCategory.categories.indexWhere((element) => element.iD == item.iD)] = item;
    notifyListeners();
  }

  Future<int> deleteCommodityCategory(Categories itemDelete) async {
    Map<String, dynamic> params = Map();
    params["ID"] = itemDelete.iD;
    var json = await ApiCaller.instance.delete(AppUrl.qlmsCommodityCategoryDelete, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    if (responseMessage.isSuccess()) {
      this.dataCommodityCategory.categories.removeWhere((element) => element.iD == itemDelete.iD);
      notifyListeners();
    }
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }
}