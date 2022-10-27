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

class ReportProcedureRepository extends ChangeNotifier {

  ApiCaller apiCaller = ApiCaller.instance;

  SearchProcedureModel searchProcedureModel = SearchProcedureModel();

  ReportProcedureRequest reportProcedureRequest = ReportProcedureRequest();

  ReportProcedureData reportProcedureData;

  List<FilterYear> _getArrayYear() {
    List<FilterYear> listYears = List();
    int yearNow = getCurrentYear();

    FilterYear year3 = FilterYear();
    year3.name =  "${yearNow - 3}";
    listYears.add(year3);

    FilterYear year2 = FilterYear();
    year2.name =  "${yearNow - 2}";
    listYears.add(year2);

    FilterYear year1 = FilterYear();
    year1.name =  "${yearNow - 1}";
    listYears.add(year1);

    FilterYear year = FilterYear();
    year.name =  "${yearNow}";
    listYears.add(year);

    return listYears;
  }

  getDefaultParams() {
    int yearNow = getCurrentYear();
    reportProcedureRequest.startDate = "01/01/${yearNow}";
    reportProcedureRequest.endDate = "31/12/${yearNow}";
    var year = FilterYear();
    year.name = yearNow.toString();
    reportProcedureRequest.filterYear = year;
  }

  String getStartDate() {
    int yearNow = getCurrentYear();
    return "01/01/${yearNow}";
  }

  String getEndDate() {
    int yearNow = getCurrentYear();
    return "31/12/${yearNow}";
  }

  Future<bool> getReportProcedure() async {
    final responseJSON = await apiCaller.postFormData(AppUrl.reportProcedure, reportProcedureRequest.getParams());
    ReportProcedureResponse response = ReportProcedureResponse.fromJson(responseJSON);
    searchProcedureModel.listYears = _getArrayYear();
    if(response.status == 1) {
      reportProcedureData = response.data;
      AppStore.reportProcedureData = reportProcedureData;
      notifyListeners();
      return true;
    } else {
      ToastMessage.show(response.messages, ToastStyle.error);
      notifyListeners();
      return false;
    }
  }
}