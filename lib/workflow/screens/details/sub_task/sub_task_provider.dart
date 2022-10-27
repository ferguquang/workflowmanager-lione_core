import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';

import 'sub_task_model.dart';

class SubTabProvider extends ChangeNotifier {
  List<SubTaskModel> subTasks = [];

  loadById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = "$id";
    var response =
        await ApiCaller.instance.get(AppUrl.getSubJob, params: params);
    SubTaskResponse detailsResponse = SubTaskResponse.fromJson(response);
    if (detailsResponse.isSuccess(isDontShowErrorMessage: true)) {
      subTasks = detailsResponse.data;
      notifyListeners();
    } else {
      ToastMessage.show("Có lỗi khi kết nối đến server", ToastStyle.error);
    }
  }
}
