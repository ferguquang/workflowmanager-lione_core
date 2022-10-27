import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/borrowPayDocument/model/event/event_load_purposes_pie_chart.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_statistic_response.dart';

import '../../../main.dart';

class StatisticBorrowDocumentsRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<ReportPurposes> listPurposes = [];
  List<ReportAmounts> listAmounts = [];

  Future<bool> getStatisticBorrow() async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    final response = await apiCaller.postFormData(AppUrl.getStatistic, params);

    var getStatisticResponse = StatisticDocBorrowResponse.fromJson(response);
    if (getStatisticResponse.isSuccess()) {
      listPurposes.clear();
      listAmounts.clear();
      listPurposes.addAll(getStatisticResponse.data.reportPurposes);
      listAmounts.addAll(getStatisticResponse.data.reportAmounts);

      EventLoadPurposesPieChart event =
          EventLoadPurposesPieChart(listPurposes: listPurposes);
      eventBus.fire(event);

      notifyListeners();
    }
    /*else {
      ToastMessage.show(getStatisticResponse.messages, ToastStyle.error);
    }*/
  }
}
