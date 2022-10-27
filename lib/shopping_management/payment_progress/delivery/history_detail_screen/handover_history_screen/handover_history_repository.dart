import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_list_response.dart';
import 'package:workflow_manager/shopping_management/response/handover_history_response.dart';

import 'handover_history_screen.dart';

class HandoverHistoryRepository extends ChangeNotifier {
  ContentShoppingModel deliveryItem;

  List<ContentShoppingModel> fixItems = [];
  HandoverHistoryModel handoverHistoryModel;

  loadData(int id) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsDeliveryProgressHistory, {"ID": id});
    HandoverHistoryResponse response = HandoverHistoryResponse.fromJson(json);
    if (response.isSuccess()) {
      handoverHistoryModel = response.data;
      setFixItems();
      notifyListeners();
    }
  }

  setFixItems() {
    fixItems = [];
    var data = handoverHistoryModel?.commodity;
    ContentShoppingModel nameItem, importDateItem, qTYItem, unitItem, dataItem;
    nameItem = ContentShoppingModel(
        title: "Tên hàng hóa", value: data?.name ?? "", isNextPage: false);
    importDateItem = ContentShoppingModel(
        title: "Ngày về dự kiến",
        value: replaceDateToMobileFormat(data?.importDate),
        isNextPage: false);
    qTYItem = ContentShoppingModel(
        title: "Số lượng", value: data?.qTY?.toInt() ?? "0", isNextPage: false);
    unitItem = ContentShoppingModel(
        title: "Đơn vị tính", value: data?.unit ?? "", isNextPage: false);
    fixItems.add(nameItem);
    fixItems.add(importDateItem);
    fixItems.add(qTYItem);
    fixItems.add(unitItem);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
