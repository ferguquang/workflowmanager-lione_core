import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/check_slip_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';

class CheckSlipDetailRepository extends ChangeNotifier {
  CheckSlipDetailModel checkSlipDetailModel;
  ContentShoppingModel codeRequestItem;
  List<ContentShoppingModel> fixItems = [];
  ContentShoppingModel sentCheckDateItem,
      actDeliveryDateItem,
      assigneeCheckerItem,
      deptCheckerItem,
      detailItem;

  setFixItems() {
    fixItems = [];
    var dataDeliveries = checkSlipDetailModel?.deliveriesProgressLog;

    sentCheckDateItem = ContentShoppingModel(
        title: "Ngày gửi kiểm tra",
        value: replaceDateToMobileFormat(dataDeliveries?.sentCheckDate ?? ""),
        isNextPage: false);
    actDeliveryDateItem = ContentShoppingModel(
        title: "Ngày giao",
        value: replaceDateToMobileFormat(dataDeliveries?.actDeliveryDate ?? ""),
        isNextPage: false);
    assigneeCheckerItem = ContentShoppingModel(
        title: "Người kiểm tra",
        value: dataDeliveries?.assigneeChecker ?? "",
        isNextPage: false);
    deptCheckerItem = ContentShoppingModel(
        title: "Đơn vị kiểm tra",
        value: dataDeliveries?.deptChecker ?? "",
        isNextPage: false);
    detailItem = ContentShoppingModel(
        title: "Chi tiết",
        value: isNotNullOrEmpty(
                checkSlipDetailModel?.deliveriesProgressLog?.iDServiceRecord)
            ? "Chi tiết"
            : "",
        isNextPage: isNotNullOrEmpty(
            checkSlipDetailModel?.deliveriesProgressLog?.iDServiceRecord));
    fixItems.add(sentCheckDateItem);
    fixItems.add(actDeliveryDateItem);
    fixItems.add(assigneeCheckerItem);
    fixItems.add(deptCheckerItem);
    fixItems.add(detailItem);
    notifyListeners();
  }

  loadData(int id) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsViewCheckSlip, {"ID": id});
    CheckSlipDetailResponse response = CheckSlipDetailResponse.fromJson(json);
    if (response.isSuccess()) {
      checkSlipDetailModel = response.data;
      setFixItems();
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
