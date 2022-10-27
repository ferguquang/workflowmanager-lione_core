import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_history_detail_response.dart';

class DeliveryHistoryDetailRepository extends ChangeNotifier {
  DeliveryHistoryDetailModel deliveryHistoryDetailModel;
  List<ContentShoppingModel> fixItems = [];

  setFixItems() {
    fixItems = [];
    ContentShoppingModel nameItem = ContentShoppingModel(
        title: "Tên hàng hóa",
        value: deliveryHistoryDetailModel?.commodity?.name,
        isNextPage: false);
    ContentShoppingModel importDateItem = ContentShoppingModel(
        title: "Ngày về dự kiến",
        value: replaceDateToMobileFormat(
            deliveryHistoryDetailModel?.commodity?.importDate ?? ""),
        isNextPage: false);
    ContentShoppingModel qTYItem = ContentShoppingModel(
        title: "Số lượng",
        value: deliveryHistoryDetailModel?.commodity?.qTY?.toInt() ?? "",
        isNextPage: false);
    ContentShoppingModel unitItem = ContentShoppingModel(
        title: "Đơn vị tính",
        value: deliveryHistoryDetailModel?.commodity?.unit ?? "",
        isNextPage: false);

    fixItems.add(nameItem);
    fixItems.add(importDateItem);
    fixItems.add(qTYItem);
    fixItems.add(unitItem);
  }

  loadData(int id) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsDeliveryProgressHistory, {"ID": id});
    DeliveryHistoryDetailResponse response =
        DeliveryHistoryDetailResponse.fromJson(json);
    if (response.isSuccess()) {
      deliveryHistoryDetailModel = response.data;
      setFixItems();
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
