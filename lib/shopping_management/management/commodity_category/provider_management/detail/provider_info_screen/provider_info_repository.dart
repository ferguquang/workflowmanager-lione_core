import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/provider_info_screen/provider_info_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/provider_request.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class ProviderInfoRepository with ChangeNotifier {
  ProviderDetail providerDetail;
  List<ContentShoppingModel> list = [];

  void addList({int type, ProviderDetail providerDetail}) {
    list.add(ContentShoppingModel(
        key: "CODE",
        title: "Mã nhà cung cấp",
        isRequire: type != ProviderInfoScreen.TYPE_DETAIL,
        value: providerDetail != null ? providerDetail.code : ""));
    list.add(ContentShoppingModel(
        key: "NAME",
        title: "Tên nhà cung cấp",
        isRequire: type != ProviderInfoScreen.TYPE_DETAIL,
        value: providerDetail != null ? providerDetail.name : ""));
    list.add(ContentShoppingModel(
        key: "ABBREVIATION",
        title: "Tên viết tắt",
        isRequire: type != ProviderInfoScreen.TYPE_DETAIL,
        value: providerDetail != null ? providerDetail.abbreviation : ""));
    list.add(ContentShoppingModel(
        key: "REGION",
        title: "Vùng miền",
        isRequire: type != ProviderInfoScreen.TYPE_DETAIL,
        value:
            providerDetail != null ? _valueRegion(providerDetail.region) : ""));
    list.add(ContentShoppingModel(
        key: "COUNTRY",
        title: "Quốc gia",
        value: providerDetail != null ? providerDetail.nation.name : ""));
    list.add(ContentShoppingModel(
        key: "ADDRESS",
        title: "Địa chỉ",
        value: providerDetail != null ? providerDetail.address : ""));
    list.add(ContentShoppingModel(
        key: "CONTACT",
        title: "Người liên hệ",
        value: providerDetail != null ? providerDetail.personContact : ""));
    list.add(ContentShoppingModel(
        key: "PHONE",
        title: "Số điện thoại người liên hệ",
        value: providerDetail != null ? providerDetail.phoneContact : ""));
    list.add(ContentShoppingModel(
        key: "EMAIL",
        title: "Email",
        value: providerDetail != null ? providerDetail.email : ""));
    list.add(ContentShoppingModel(
        key: "TAXCODE",
        title: "Mã số thuế",
        value: providerDetail != null ? providerDetail.taxCode : ""));
    list.add(ContentShoppingModel(
        key: "CATEGORY",
        title: "Danh mục hàng hóa",
        value:
            providerDetail != null ? providerDetail.commodityCategorys : ""));

    if (type == ProviderInfoScreen.TYPE_DETAIL) {
      list.forEach((element) {
        element.isNextPage = false;
      });
    }

    notifyListeners();
  }

  String _valueRegion(List<CategoryItem> region) {
    String valueRegion = region
        .map((e) => "${e.name}")
        .toList()
        .toString();
    return valueRegion.replaceAll("[", "").replaceAll("]", "");
  }

  Future<void> getDetailProvider(id, {int type}) async {
    ProviderDetailRequest request = ProviderDetailRequest();
    request.id = id;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsProviderDetail, request.getParams());
    ProviderDetailResponse response = ProviderDetailResponse.fromJson(json);
    if (response.status == 1) {
      providerDetail = response.data.provider;
      addList(
        type: type,
        providerDetail: providerDetail
      );
      // notifyListeners();
    }
  }
}