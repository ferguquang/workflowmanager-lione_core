import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/screens/group_job/addition/response_report_index.dart';

class AdditionRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataReportIndex data;

  Future<void> getDataReport() async {
    final responseJSON = await apiCaller.get(AppUrl.getDataForIndex,
        params: Map<String, dynamic>());
    ResponseReportIndex response = ResponseReportIndex.fromJson(responseJSON);
    data = response.data;
    notifyListeners();
  }
}
