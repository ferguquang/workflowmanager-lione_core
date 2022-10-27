import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/workflow/models/response/task_detail_response.dart';

class TaskDetailsScreenProvider extends ChangeNotifier {
  TaskDetailModel taskDetailModel;
  bool isSuccess = true;
  String messageError = "";

  loadById(int id, int typeTask) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = id;
    params["ViewType"] = typeTask;

    var response = await ApiCaller.instance
        .postFormData(AppUrl.getTaskInfo, params, isLoading: true);
    TaskDetailsResponse tasksResponse = TaskDetailsResponse.fromJson(response);
    if (tasksResponse.isSuccess()) {
      taskDetailModel = tasksResponse.data;
      isSuccess = true;
    } else {
      isSuccess = false;
      String text = tasksResponse.messages;
      messageError = text;
      // ToastMessage.show(text, ToastStyle.error);
    }

    notifyListeners();
  }

  Future<bool> deleteJobById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = id;
    var response = await ApiCaller.instance.delete(AppUrl.getDeleteJob, params);
    // if (response["Status"] == 1) {
    //   ToastMessage.show("Xoá công việc thành công", ToastStyle.success);
    //   notifyListeners();
    //   return true;
    // } else {
    //   ToastMessage.show(getResponseMessage(response), ToastStyle.error);
    //   return false;
    // }
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      ToastMessage.show("Xóa công việc thành công", ToastStyle.success);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
