import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/params/report_procedure_request.dart';
import 'package:workflow_manager/procedures/models/response/report_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/models/response/search_procedure_model.dart';
import 'package:workflow_manager/shopping_management/request/report_shopping_dash_board_request.dart';
import 'package:workflow_manager/shopping_management/response/report_shopping_list_response.dart';
import 'package:workflow_manager/shopping_management/response/shopping_dashboard_response.dart';

class ReportShoppingRepository extends ChangeNotifier {

  ApiCaller apiCaller = ApiCaller.instance;

  SearchProcedureModel searchProcedureModel = SearchProcedureModel();

  ReportShoppingDashBoardRequest reportShoppingRequest =
      ReportShoppingDashBoardRequest();

  ReportShoppingDashBoardData reportShoppingDashBoardData;

  ReportShoppingListData reportShoppingListData;
  bool isViewListData = false;

  void setViewListData(bool isViewList) {
    isViewListData = isViewList;
    notifyListeners();
  }

  Future<bool> getReportShoppingDashBoard() async {
    reportShoppingRequest.isDashboard = true;
    final responseJSON = await apiCaller.postFormData(
        AppUrl.qlmsDashboard, reportShoppingRequest.getParams());
    ReportShoppingDashBoardResponse response =
        ReportShoppingDashBoardResponse.fromJson(responseJSON);
    if (response.status == 1) {
      reportShoppingDashBoardData = response.data;
      AppStore.reportShoppingData = reportShoppingDashBoardData;
      notifyListeners();
      return true;
    } else {
      ToastMessage.show(response.messages, ToastStyle.error);
      notifyListeners();
      return false;
    }
  }

  Future<void> getReportShoppingList({int iDCategory, int currentPage}) async {
    reportShoppingRequest.iDCategory = iDCategory;
    reportShoppingRequest.isDashboard = false;
    final responseJSON = await apiCaller.postFormData(currentPage == 1 ? AppUrl.qlmsReportShoppingList : AppUrl.qlmsDashboardProjectByCategory, reportShoppingRequest.getParams());
    ReportShoppingListResponse response = ReportShoppingListResponse.fromJson(responseJSON);
    if(response.status == 1) {
      reportShoppingListData = response.data;
      notifyListeners();
    } else {
      ToastMessage.show(response.messages, ToastStyle.error);
      notifyListeners();
    }
  }

  void clearData() {
    reportShoppingListData.reportTable.clear();
    notifyListeners();
  }
}