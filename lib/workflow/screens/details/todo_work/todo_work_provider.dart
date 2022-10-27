import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';

import 'todo_list_model.dart';
import 'todo_model.dart';

class ToDoWorkProvider extends ChangeNotifier {
  List<ToDoModel> toDoList = [];
  bool isShowEdit = false;

  ToDoWorkProvider({List<ToDoModel> toDoList}) {
    if (toDoList == null) toDoList = [];
    this.toDoList = toDoList;
  }

  hideEdit() {
    isShowEdit = false;
    notifyListeners();
  }

  showEdit() {
    isShowEdit = true;
    notifyListeners();
  }

  setToDoList(List<ToDoModel> toDoList) {
    this.toDoList = toDoList;
    notifyListeners();
  }

  completeById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDJobDetail"] = id;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getCompleteJobDetails, params);
    // if (response["Status"] == 1) {
    //   _updateId(id, true);
    //   notifyListeners();
    // } else {
    //   ToastMessage.show(getResponseMessage(response), ToastStyle.error);
    // }
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      _updateId(id, true);
      notifyListeners();
    }
  }

  add(String name, int jobId) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = jobId;
    params["TaskName"] = name;
    var response =
        await ApiCaller.instance.postFormData(AppUrl.getAddJobDetail, params);
    TodoResponse todoResponse = TodoResponse.fromJson(response);
    if (todoResponse.isSuccess()) {
      toDoList.add(todoResponse.data);
      notifyListeners();
    }
    /*else {
      ToastMessage.show(todoResponse.messages, ToastStyle.error);
    }*/
  }

  uncompleteById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDJobDetail"] = id;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.getUncompleteJobDetails, params);
    // if (response["Status"] == 1) {
    //   _updateId(id, false);
    //   notifyListeners();
    // } else {
    //   ToastMessage.show(getResponseMessage(response), ToastStyle.error);
    // }
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      _updateId(id, false);
      notifyListeners();
    }
  }

  deleteById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDJobDetail"] = id;
    var response =
        await ApiCaller.instance.delete(AppUrl.getDeleteJobDetail, params);
    // if (response["Status"] == 1) {
    //   _removeId(id);
    //   notifyListeners();
    // } else {
    //   ToastMessage.show(getResponseMessage(response), ToastStyle.error);
    // }
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      _removeId(id);
      notifyListeners();
    }
  }

  _removeId(int id) {
    for (ToDoModel todo in toDoList) {
      if (todo.iD == id) {
        toDoList.remove(todo);
        break;
      }
    }
  }

  _updateId(int id, bool isCompleted) {
    for (ToDoModel todo in toDoList) {
      if (todo.iD == id) {
        todo.isComplete = isCompleted;
        break;
      }
    }
  }

  loadById(int id) async {
    Map<String, dynamic> params = Map();
    params["IDJob"] = id;
    var response =
        await ApiCaller.instance.get(AppUrl.getJobDetails, params: params);
    TodoListResponse todoListResponse = TodoListResponse.fromJson(response);
    if (todoListResponse.isSuccess()) {
      toDoList = todoListResponse.data;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(todoListResponse.messages, ToastStyle.error);
    }*/
  }
}
