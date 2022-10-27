import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/list_status_request.dart';
import 'package:workflow_manager/workflow/models/params/list_task_request.dart';
import 'package:workflow_manager/workflow/models/response/change_status_response.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/models/response/list_task_model_response.dart';

class ListTaskRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  int page = 1;
  int _pageSize = 10;
  int totalCount = 0;
  GetListTaskRequest request = GetListTaskRequest();
  TaskIndexData taskData = new TaskIndexData();
  List<TaskIndexItem> arrayTask = new List<TaskIndexItem>();
  StatusData statusData = new StatusData();

  Future<void> getListTaskIndex() async {
    this.request.pageIndex = page;
    this.request.pageSize = _pageSize;
    final response = await apiCaller.postFormData(
        AppUrl.getListTask, this.request.getParams(),
        isLoading: page == 1);
    TaskIndexModelResponse tasksResponse =
        TaskIndexModelResponse.fromJson(response);

    if (tasksResponse.isSuccess()) {
      this.taskData = tasksResponse.data;
      this.totalCount = tasksResponse.data.jobCount;
      if (this.page == 1) {
        this.arrayTask = tasksResponse.data.result;
      } else {
        this.arrayTask.addAll(tasksResponse.data.result);
      }
      page++;
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }

  void pullToRefreshData() {
    page = 1;
  }

  Future<void> getListStatus(int idStatus, int viewType) async {
    GetListStatusRequest requestListStatus = GetListStatusRequest();
    requestListStatus.status = idStatus;
    requestListStatus.viewType = viewType;

    final response = await apiCaller.get(AppUrl.getListStatus,
        params: requestListStatus.getParams());
    ListStatusResponse _statusResponse = ListStatusResponse.fromJson(response);

    if (_statusResponse.isSuccess()) {
      this.statusData = _statusResponse.data;
      notifyListeners();
    } else {
      // ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }

  Future<StatusItem> changeTaskStatus(int taskID, int statusID) async {
    ChangeStatusRequest requestChangeStatus = ChangeStatusRequest();
    requestChangeStatus.status = statusID;
    requestChangeStatus.idJob = taskID;

    final response = await apiCaller.postFormData(
        AppUrl.changeJobStatus, requestChangeStatus.getParams(),
        isLoading: true);
    ChangeStatusResponse _statusResponse =
        ChangeStatusResponse.fromJson(response);

    if (_statusResponse.isSuccess()) {
      this.updateListTask(taskID, statusItem: _statusResponse.data);
      return _statusResponse.data;
    } else {
      // ToastMessage.show(_statusResponse.messages, ToastStyle.error);
      notifyListeners();
    }
    return null;
  }

  Future<void> updateListTask(int taskID, {StatusItem statusItem}) async {
    for (int i = 0; i < this.arrayTask.length; i++) {
      TaskIndexItem item = this.arrayTask[i];
      if (item.jobID == taskID) {
        this.arrayTask[i].jobStatus = statusItem;
        notifyListeners();
        break;
      }
    }
  }

  Future<void> deleteTaskInList(int taskID) async {
    this.arrayTask.removeWhere((element) => element.jobID == taskID);
    this.totalCount = this.totalCount - 1;
    notifyListeners();
  }
}
