import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/params/list_work_follow_request.dart';
import 'package:workflow_manager/procedures/models/response/RegisterServiceResponse.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';

class ListWorkFollowRepository extends ChangeNotifier {
  List<RegisterServices> registerServices = [];
  ListWorkFollowRequest loadDataRequest = ListWorkFollowRequest();
  String startDate = "Từ ngày", endDate = "Đến ngày";
  int featureType;
  String searchName = "";
  int pageIndex = 1;
  int pageTotal;
  WaitNextAction<String> _waitNextAction;

  ListWorkFollowRepository() {
    _waitNextAction =
        WaitNextAction(searchOnline, duration: Duration(seconds: 1));
  }

  setStartDate(String startDate) {
    if (startDate == null)
      this.startDate = "Từ ngày";
    else {
      this.startDate = startDate;
    }
    notifyListeners();
  }

  setEndDate(String endDate) {
    if (endDate == null)
      this.endDate = "Đến ngày";
    else {
      this.endDate = endDate;
    }
    notifyListeners();
  }

  _loadData() async {
    loadDataRequest.startDate =
        isNotNullOrEmpty(startDate) && startDate.contains(RegExp(r"\d"))
            ? startDate.replaceAll("/", "-")
            : null;
    loadDataRequest.endDate =
        isNotNullOrEmpty(endDate) && endDate.contains(RegExp(r"\d"))
            ? endDate.replaceAll("/", "-")
            : null;
    loadDataRequest.featureType = featureType;
    loadDataRequest.pageIndex = pageIndex;
    loadDataRequest.term = searchName ?? "";
    final response = await ApiCaller.instance.postFormData(
        AppUrl.getQTTTRegisterServices, loadDataRequest.getParams(), isLoading: false);
    RegisterServiceResponse registerTypeResponse =
        RegisterServiceResponse.fromJson(response);
    if (registerTypeResponse.status == 1) {
      if (pageIndex == 1) {
        registerServices = registerTypeResponse.data.services;
      } else {
        registerServices.addAll(registerTypeResponse.data.services);
      }
      pageTotal = registerTypeResponse.data.pageTotal;
      notifyListeners();
    } else {
      showErrorToast(registerTypeResponse.messages);
    }
  }

  void changeFeature(int idService, int index) async {
    ListWorkFollowRequest request = ListWorkFollowRequest();
    request.idService = idService;
    final response = await ApiCaller.instance.postFormData(
        AppUrl.getQTTTRegisterChangeFeatured, request.getChangeFeatureParams());
    if (response["Status"] == 1) {
      registerServices[index].isFeatured = !registerServices[index].isFeatured;
      notifyListeners();
    } else {
      showErrorToast(getResponseMessage(response));
    }
  }

  bool isFirst = true;

  onTextChanged(String name) {
    if (searchName == name) return;
    searchName = name;
    _waitNextAction.action(name);
  }

  searchOnline(String name) {
    refreshData();
  }

  refreshData() async {
    pageIndex = 1;
    await _loadData();
    pageIndex++;
  }

  loadMore() async {
    if (pageTotal < pageIndex) {
      return;
    }
    await _loadData();
    pageIndex++;
  }
}
