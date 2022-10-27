import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/report_shopping_request.dart';
import 'package:workflow_manager/shopping_management/response/import_report_response.dart';

class ImportReportRepository with ChangeNotifier {
  DataImportReport data = DataImportReport();
  ImportReportRequest request = ImportReportRequest();
  int skip = 1;
  int _take = 10;

  void pullToRefreshData() {
    data.report?.clear();
    skip = 1;
  }

  Future<void> getImportReport() async {
    request.skip = skip;
    request.take = _take;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsImportReport, request.getParams(), isLoading: skip == 1);
    ImportReportResponse response = ImportReportResponse.fromJson(json);
    if (response.status == 1) {
      data.totalRecord = response.data.totalRecord;
      if (skip == 1) {
        data.report = response.data.report;
      } else {
        data.report.addAll(response.data.report.toList());
      }
      skip++;
      notifyListeners();
    }
  }

  List<ContentShoppingModel> getListDetail(ImportReport itemClick) {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(title: "Mã sản phẩm", value: itemClick.codeCommodity));
    list.add(ContentShoppingModel(title: "Tên sản phẩm", value: itemClick.nameCommodity));
    list.add(ContentShoppingModel(title: "Mã PO", value: itemClick.codeContract));
    list.add(ContentShoppingModel(title: "Tên nhà cung cấp", value: itemClick.nameProvider));
    list.add(ContentShoppingModel(title: "Số lượng nhập", value: itemClick.qTY));
    list.add(ContentShoppingModel(title: "Ngày giao thực tế", value: itemClick.actDeliveryDate));
    list.add(ContentShoppingModel(title: "Tổng tiền", value: itemClick.totalAmount));
    list.add(ContentShoppingModel(title: "Tiền tệ", value: itemClick.currency));
    list.forEach((element) {
      element.isNextPage = false;
    });

    return list;
  }

  List<ContentShoppingModel> getListFilter() {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(title: "Tên nhà cung cấp", value: isNotNullOrEmpty(request.nameProvider) ? request.nameProvider : ""));
    list.add(ContentShoppingModel(title: "Tên hàng hóa", value: isNotNullOrEmpty(request.nameCommodity) ? request.nameCommodity : ""));
    list.add(ContentShoppingModel(title: "Giao hàng từ ngày", isOnlyDate: true, value: isNotNullOrEmpty(request.startDate) ? request.startDate : ""));
    list.add(ContentShoppingModel(title: "Giao hàng đến ngày", isOnlyDate: true, value: isNotNullOrEmpty(request.endDate) ? request.endDate : ""));

    return list;
  }
}