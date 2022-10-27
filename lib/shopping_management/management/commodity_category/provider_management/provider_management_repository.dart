import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/provider_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class ProviderManagementRepository with ChangeNotifier {
  ProviderIndexRequest request = ProviderIndexRequest();
  DataProviderIndex dataProviderIndex = DataProviderIndex();
  int skip = 1;
  int _take = 10;

  void pullToRefreshData() {
    dataProviderIndex.providers?.clear();
    skip = 1;
  }

  Future<DataCommodityCreate> renderCreateProvider() async {
    Map<String, dynamic> params = Map();
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsProviderCreate, params);
    CommodityCreateResponse response = CommodityCreateResponse.fromJson(json);
    if (response.status == 1) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<int> createUpdateProvider(
      List<ContentShoppingModel> result, ProviderDetail model) async {
    ProviderCreateRequest request = ProviderCreateRequest();
    request.list = result;
    if (model != null) {
      request.id = model.iD;
    }
    var json = await ApiCaller.instance.postFormData(
        model == null ? AppUrl.qlmsProviderSave : AppUrl.qlmsProviderChange,
        request.getParams());
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    responseMessage.isSuccess();
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  Future<void> getProviderIndex() async {
    request.skip = skip;
    request.take = _take;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsProviderIndex, request.getParams());
    ProviderIndexResponse response = ProviderIndexResponse.fromJson(json);
    if (response.status == 1) {
      dataProviderIndex.isCreate = response.data.isCreate;
      dataProviderIndex.totalRecord = response.data.totalRecord;
      dataProviderIndex.searchParam = response.data.searchParam;
      if (this.skip == 1) {
        dataProviderIndex.providers = response.data.providers;
      } else {
        dataProviderIndex.providers.addAll(response.data.providers.toList());
      }
      skip++;
      notifyListeners();
    }
  }

  Future<ProviderDetail> getProviderUpdate(ProvidersIndex itemUpdate) async {
    ProviderDetailRequest request = ProviderDetailRequest();
    request.id = itemUpdate.iD;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsProviderDetail, request.getParams());
    ProviderDetailResponse response = ProviderDetailResponse.fromJson(json);
    if (response.status == 1) {
      return response.data.provider;
    }

    return null;
  }

  Future<void> removeItem(ProvidersIndex item) async {
    Map<String, dynamic> params = Map();
    params["ID"] = item.iD;
    var json =
        await ApiCaller.instance.delete(AppUrl.qlmsProviderRemove, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    if (responseMessage.isSuccess()) {
      this
          .dataProviderIndex
          .providers
          .removeWhere((element) => element.iD == item.iD);
      notifyListeners();
    }
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  List<ContentShoppingModel> addFilter() {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(
        title: "Mã hoặc tên nhà cung cấp",
        value: isNotNullOrEmpty(request.codeName) ? request.codeName : ""));
    list.add(ContentShoppingModel(
        title: "Tên viết tắt",
        value: isNotNullOrEmpty(request.abbreviation)
            ? request.abbreviation
            : ""));

    String valueRegion = "";
    List<CategorySearchParams> regionSelected = [];
    if (isNotNullOrEmpty(request.region) && request.region != "null") {
      List<String> stringList = request.region.split(',');
      for (int i = 0; i < stringList.length; i++) {
        String idCategory = stringList[i];
        for (int j = 0; j < dataProviderIndex.searchParam.regions.length; j++) {
          String id = "${dataProviderIndex.searchParam.regions[j].iD}";
          if (idCategory == (id)) {
            regionSelected.add(dataProviderIndex.searchParam.regions[j]);
          }
        }
      }
    }
    list.add(ContentShoppingModel(
        title: "Vùng miền",
        isDropDown: true,
        selected: regionSelected,
        isSingleChoice: false,
        dropDownData: dataProviderIndex.searchParam.regions,
        idValue: isNotNullOrEmpty(request.region) && request.region != "null"
            ? request.region
            : "",
        getTitle: (status) => status.name,
        value: valueRegion));

    CategorySearchParams nationSelected;
    String valueNation = "";
    if (request.nation != null) {
      dataProviderIndex.searchParam.nations.forEach((element) {
        if ("${element.iD}" == request.nation) {
          valueNation = element.name;
          nationSelected = element;
          return;
        }
      });
    }
    list.add(ContentShoppingModel(
        title: "Quốc gia",
        isDropDown: true,
        selected: nationSelected != null ? [nationSelected] : [],
        isSingleChoice: true,
        dropDownData: dataProviderIndex.searchParam.nations,
        idValue: isNotNullOrEmpty(request.nation) ? request.nation : "",
        getTitle: (status) => status.name,
        value: valueNation));

    CategorySearchParams categorySelected;
    String valueDept = "";
    if (request.idCategorys != null) {
      dataProviderIndex.searchParam.categorys.forEach((element) {
        if ("${element.iD}" == request.idCategorys) {
          valueDept = element.name;
          categorySelected = element;
          return;
        }
      });
    }
    list.add(ContentShoppingModel(
        title: "Danh mục hàng hoá",
        isDropDown: true,
        selected: categorySelected != null ? [categorySelected] : [],
        isSingleChoice: true,
        dropDownData: dataProviderIndex.searchParam.categorys,
        idValue:
            isNotNullOrEmpty(request.idCategorys) ? request.idCategorys : "",
        getTitle: (status) => status.name,
        value: valueDept));

    return list;
  }
}