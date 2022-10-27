import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/response/history_model.dart';

class HistoryRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<HistoryModel> _list = [];

  List<HistoryModel> get list => _list;

  Future<void> getListHistory(Map<String, dynamic> params) async {
    final responseJSON =
        await apiCaller.get(AppUrl.listHistory, params: params);
    ResponseJobHistory responseJobHistory =
        ResponseJobHistory.fromJson(responseJSON);
    if (responseJobHistory.isSuccess()) {
      _list = responseJobHistory.data;
      notifyListeners();
    }
  }
}
