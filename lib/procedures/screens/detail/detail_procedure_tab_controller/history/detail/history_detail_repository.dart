import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/procedures/models/params/detail_procedure_request.dart';
import 'package:workflow_manager/procedures/models/response/info_step_history_response.dart';

class HistoryDetailRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataInfoStepHistory _dataInfoStepHistory;

  DataInfoStepHistory get dataInfoStepHistory => _dataInfoStepHistory;

  Future<int> infoStepHistory(InfoStepHistoryRequest request) async {
    var response = await apiCaller.postFormData(
        AppUrl.registerInfoStepHistory, request.getParams());
    InfoStepHistoryResponse infoStepHistoryResponse =
        InfoStepHistoryResponse.fromJson(response);
    if (infoStepHistoryResponse.status == 1) {
      _dataInfoStepHistory = infoStepHistoryResponse.data;
      notifyListeners();
    } else {
      showErrorToast(infoStepHistoryResponse.messages);
    }
    return infoStepHistoryResponse.status;
  }
}
