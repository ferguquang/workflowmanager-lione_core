import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/params/get_List_task_group_request.dart';
import 'package:workflow_manager/workflow/models/params/group_add_column_request.dart';
import 'package:workflow_manager/workflow/models/params/group_delete_column_request.dart';
import 'package:workflow_manager/workflow/models/params/group_edit_column_request.dart';
import 'package:workflow_manager/workflow/models/params/list_tab_group_request.dart';
import 'package:workflow_manager/workflow/models/response/filter_column_group_response.dart';
import 'package:workflow_manager/workflow/models/response/group_add_column_response.dart';
import 'package:workflow_manager/workflow/models/response/group_edit_column_reponse.dart';
import 'package:workflow_manager/workflow/models/response/list_column_group_response.dart';
import 'package:workflow_manager/workflow/models/response/list_task_group_response.dart';
import 'package:workflow_manager/workflow/models/response/list_task_model_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/list_column_group_tab_screen.dart';

// besiness của màn hình các cột của Nhóm công việc
class ColumnGroupRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  int page = 1;
  int _pageSize = 10;
  int totalCount = 0;
  List<Tab> tabItem = List();

  List<TabItemGroup> arrayItemTabGroup = List();

  List<TaskIndexItem> arrayTaskGroup = new List<TaskIndexItem>();

  FilterColumnGroupData filterColumnGroupData = FilterColumnGroupData();

  GetListColumnGroupRequest request = GetListColumnGroupRequest();

  // lấy danh sách tab của cột
  Future<void> getListTabColumnGroup(GetListTabGroupRequest request) async {
    final response =
        await apiCaller.get(AppUrl.getColumnGroup, params: request.getParams());
    ListColumnGroupResponse listColumnGroupResponse =
        ListColumnGroupResponse.fromJson(response);
    if (listColumnGroupResponse.isSuccess()) {
      arrayItemTabGroup = listColumnGroupResponse?.arrayItemTabGroup;
      tabItem = [];
      arrayItemTabGroup.forEach((element) {
        tabItem.add(Tab(
          text: element.colTitle,
        ));
      });
      notifyListeners();
    } else {
      // ToastMessage.show(listColumnGroupResponse.messages, ToastStyle.error);
      notifyListeners();
    }
  }

  Future<void> addColumn(String title, int iDGroupJob) async {
    GroupAddColumnRequest addColumnRequest = GroupAddColumnRequest();
    addColumnRequest.iDGroupJob = iDGroupJob;
    addColumnRequest.title = title;
    final response = await apiCaller.postFormData(
        AppUrl.getGroupTaskAddColumn, addColumnRequest.getParams());
    GroupAddColumnResponse addColumnResponse =
        GroupAddColumnResponse.fromJson(response);
    if (addColumnResponse.isSuccess()) {
      GetListTabGroupRequest getListTabGroupRequest = GetListTabGroupRequest();
      getListTabGroupRequest.idGroupJob = iDGroupJob;
      getListTabColumnGroup(getListTabGroupRequest);
    }
    /*else {
      ToastMessage.show(addColumnResponse.messages, ToastStyle.error);
    }*/
  }

  Future<void> editColumn(String title, int iDGroupJob, int idColumn) async {
    GroupEditColumnRequest editColumnRequest = GroupEditColumnRequest();
    editColumnRequest.iDGroupJob = iDGroupJob;
    editColumnRequest.title = title;
    editColumnRequest.iDColumn = idColumn;
    final response = await apiCaller.postFormData(
        AppUrl.getGroupTaskChangeTitle, editColumnRequest.getParams());
    GroupEditColumnResponse editColumnResponse =
        GroupEditColumnResponse.fromJson(response);
    if (editColumnResponse.isSuccess()) {
      GetListTabGroupRequest getListTabGroupRequest = GetListTabGroupRequest();
      getListTabGroupRequest.idGroupJob = iDGroupJob;
      getListTabColumnGroup(getListTabGroupRequest);
    }
    /*else {
      ToastMessage.show(editColumnResponse.messages, ToastStyle.error);
    }*/
  }

  Future<void> deleteColumn(int idColumn, int iDGroupJob) async {
    GroupDeleteColumnRequest deleteColumnRequest = GroupDeleteColumnRequest();
    deleteColumnRequest.iDGroupJob = iDGroupJob;
    deleteColumnRequest.iDColumn = idColumn;
    final response = await apiCaller.delete(
        AppUrl.getGroupTaskDeleteColumn, deleteColumnRequest.getParams());
    // if (response["Status"] == 1) {
    //   GetListTabGroupRequest getListTabGroupRequest = GetListTabGroupRequest();
    //   getListTabGroupRequest.idGroupJob = iDGroupJob;
    //   getListTabColumnGroup(getListTabGroupRequest);
    //   ToastMessage.show(getResponseMessage(response), ToastStyle.success);
    // } else {
    //   ToastMessage.show(getResponseMessage(response), ToastStyle.error);
    // }
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess()) {
      GetListTabGroupRequest getListTabGroupRequest = GetListTabGroupRequest();
      getListTabGroupRequest.idGroupJob = iDGroupJob;
      getListTabColumnGroup(getListTabGroupRequest);
      ToastMessage.show(getResponseMessage(response), ToastStyle.success);
    }
  }

  void pullToRefreshData() {
    page = 1;
  }

  // lấy danh sách công việc trong cột
  Future<void> getListColumnGroup() async {
    request.pageIndex = page;
    request.pageSize = _pageSize;
    final response = await apiCaller.postFormData(
        AppUrl.getListColumnGroup, request.getParams(),
        isLoading: page == 1);
    ListTaskGroupResponse tasksResponse =
        ListTaskGroupResponse.fromJson(response);
    if (tasksResponse.isSuccess()) {
      if (this.page == 1) {
        this.arrayTaskGroup = tasksResponse.data.arrayTaskGroup;
      } else {
        this.arrayTaskGroup.addAll(tasksResponse.data.arrayTaskGroup);
      }
      if (isNotNullOrEmpty(arrayTaskGroup) && arrayTaskGroup.length > 0) {
        page++;
      }
      eventBus.fire(GetRoleEventBus(tasksResponse.data.role));
      notifyListeners();
    } else {
      // ToastMessage.show(tasksResponse.messages, ToastStyle.error);
      notifyListeners();
    }
  }

  // lấy dữ liệu màn hình lọc
  Future<void> getListFilterColumn() async {
    final response = await apiCaller.get(AppUrl.getDataFilterColumnGroup,
        isLoading: true, params: Map<String, dynamic>());
    FilterColumnGroupResponse filterColumnGroupResponse =
        FilterColumnGroupResponse.fromJson(response);
    if (filterColumnGroupResponse.isSuccess()) {
      this.filterColumnGroupData = filterColumnGroupResponse.data;
      notifyListeners();
    } else {
      // ToastMessage.show(filterColumnGroupResponse.messages, ToastStyle.error);
      notifyListeners();
    }
  }
}
