import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/commodity_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class CommodityRepository with ChangeNotifier {
  CommodityRequest request = CommodityRequest();
  DataCommodityIndex dataCommodityIndex = DataCommodityIndex();
  int skip = 1;
  int _take = 10;

  void pullToRefreshData() {
    skip = 1;
  }

  Future<void> getCommodityIndex() async {
    request.skip = skip;
    request.take = _take;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsCommodityIndex, request.getParams());
    CommodityIndexResponse response = CommodityIndexResponse.fromJson(json);
    if (response.status == 1) {
      dataCommodityIndex.isCreate = response.data.isCreate;
      dataCommodityIndex.totalRecord = response.data.totalRecord;
      dataCommodityIndex.searchParam = response.data.searchParam;
      if (this.skip == 1) {
        dataCommodityIndex.commodities = response.data.commodities;
      } else {
        dataCommodityIndex.commodities.addAll(response.data.commodities.toList());
      }
      skip++;
      notifyListeners();
    }
  }

  void updateList(List<Commodities> list) {
    dataCommodityIndex.commodities = list;
    notifyListeners();
  }

  Future<void> removeItem(Commodities item) async {
    Map<String, dynamic> params = Map();
    params["ID"] = item.iD;
    var json = await ApiCaller.instance.delete(AppUrl.qlmsCommodityDelete, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    if (responseMessage.isSuccess()) {
      this.dataCommodityIndex.commodities.removeWhere((element) => element.iD == item.iD);
      notifyListeners();
    }
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  void removeLocal(Commodities item) {
    this.dataCommodityIndex.commodities.removeWhere((element) => element.iD == item.iD);
    notifyListeners();
  }

  Future<void> addItemCommodity(Commodities item) async {
    dataCommodityIndex.commodities.insert(0, item);
    notifyListeners();
  }

  void updateItem(Commodities item) {
    dataCommodityIndex.commodities[dataCommodityIndex.commodities
        .indexWhere((element) => element.iD == item.iD)] = item;
    notifyListeners();
  }

  List<ContentShoppingModel> addFilter() {
    List<ContentShoppingModel> list = [];

    CategorySearchParams categorySelected;
    String valueDept = "";
    if (request.idCategory != null) {
      dataCommodityIndex.searchParam.categories.forEach((element) {
        if ("${element.iD}" == request.idCategory) {
          valueDept = element.name;
          categorySelected = element;
          return;
        }
      });
    }
    list.add(ContentShoppingModel(
        key: "DMHH",
        title: "Danh mục hàng hoá",
        isDropDown: true,
        selected: categorySelected != null ? [categorySelected] : [],
        isSingleChoice: true,
        dropDownData: dataCommodityIndex.searchParam.categories,
        idValue: isNotNullOrEmpty(request.idCategory) ? request.idCategory : "",
        getTitle: (status) => status.name,
        value: valueDept));
    String valueManufacture = "";
    List<CategorySearchParams> quarterSelected = [];
    if (isNotNullOrEmpty(request.idManufacturs) &&
        request.idManufacturs != "null") {
      List<String> stringList = request.idManufacturs.split(',');
      for (int i = 0; i < stringList.length; i++) {
        String idCategory = stringList[i];
        for (int j = 0;
            j < dataCommodityIndex.searchParam.manufacturs.length;
            j++) {
          String id = "${dataCommodityIndex.searchParam.manufacturs[j].iD}";
          if (idCategory == id) {
            quarterSelected.add(dataCommodityIndex.searchParam.manufacturs[j]);
          }
        }
      }
    }
    list.add(ContentShoppingModel(
        key: "HANG",
        title: "Chọn hãng",
        isDropDown: true,
        selected: quarterSelected,
        isSingleChoice: false,
        dropDownData: dataCommodityIndex.searchParam.manufacturs,
        idValue: isNotNullOrEmpty(request.idManufacturs) &&
                request.idManufacturs != "null"
            ? request.idManufacturs
            : "",
        getTitle: (status) => status.name,
        value: valueManufacture));

    list.add(ContentShoppingModel(
        key: "MAHH",
        title: "Mã hàng hóa",
        value: isNotNullOrEmpty(request.code) ? request.code : ""));
    list.add(ContentShoppingModel(
        key: "TENHH",
        title: "Tên hàng hóa",
        value: isNotNullOrEmpty(request.name) ? request.name : ""));

    return list;
  }
}