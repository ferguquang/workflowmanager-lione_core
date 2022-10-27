import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/requisition_shopping_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/shopping_management/response/requisition_response.dart';

class RequisitionShoppingRepository with ChangeNotifier {
  DataRequisitionIndex data = DataRequisitionIndex();
  RequisitionShoppingIndexRequest request = RequisitionShoppingIndexRequest();
  int skip = 1;
  int _take = 10;

  void pullToRefreshData() {
    data.requisitions?.clear();
    skip = 1;
  }

  Future<void> getRequisitionIndex() async {
    request.skip = skip;
    request.take = _take;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsRequisitionIndex, request.getParams(), isLoading: skip == 1);
    RequisitionIndexResponse response = RequisitionIndexResponse.fromJson(json);
    if (response.status == 1) {
      data.totalRecord = response.data.totalRecord;
      data.searchParam = response.data.searchParam;
      if (skip == 1) {
        data.requisitions = response.data.requisitions;
      } else {
        data.requisitions.addAll(response.data.requisitions.toList());
      }
      skip++;
      notifyListeners();
    }
  }

  List<ContentShoppingModel> addFilter() {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(
        key: "RequisitionNumber",
        title: "Mã PR",
        value: isNotNullOrEmpty(request.requisitionNumber)
            ? request.requisitionNumber
            : ""));
    list.add(ContentShoppingModel(
        key: "RequestBy",
        title: "Người đề nghị",
        value: isNotNullOrEmpty(request.requestBy) ? request.requestBy : ""));

    CategorySearchParams deptSelected;
    String valueDept = "";
    if (request.idDept != null) {
      data.searchParam.depts.forEach((element) {
        if ("${element.iD}" == request.idDept) {
          valueDept = element.name;
          deptSelected = element;
          return;
        }
      });
    }
    list.add(ContentShoppingModel(
        key: "IDDept",
        title: "Bộ phận đề nghị",
        isDropDown: true,
        selected: isNotNullOrEmpty(request.idDept) ? [deptSelected] : [],
        isSingleChoice: true,
        dropDownData: data.searchParam.depts,
        idValue: isNotNullOrEmpty(request.idDept) ? request.idDept : "",
        getTitle: (status) => status.name,
        value: valueDept));

    String valueStatus = "";
    List<CategorySearchParams> quarterSelected = [];
    if (isNotNullOrEmpty(request.statuisProcess) &&
        request.statuisProcess != "null") {
      List<String> stringList = request.statuisProcess.split(',');
      for (int i = 0; i < stringList.length; i++) {
        String idCategory = stringList[i];
        for (int j = 0; j < data.searchParam.requisitionStatus.length; j++) {
          String id = "${data.searchParam.requisitionStatus[j].iD}";
          if (idCategory == (id)) {
            quarterSelected.add(data.searchParam.requisitionStatus[j]);
          }
        }
      }
    }
    list.add(ContentShoppingModel(
        key: "StatusProcess",
        title: "Trạng thái",
        isDropDown: true,
        selected: quarterSelected,
        isSingleChoice: false,
        dropDownData: data.searchParam.requisitionStatus,
        idValue: isNotNullOrEmpty(request.statuisProcess) &&
                request.statuisProcess != "null"
            ? request.statuisProcess
            : "",
        getTitle: (status) => status.name,
        value: valueStatus));

    return list;
  }
}