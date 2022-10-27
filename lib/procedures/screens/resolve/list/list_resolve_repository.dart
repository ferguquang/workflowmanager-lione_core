import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/params/list_register_request.dart';
import 'package:workflow_manager/procedures/models/response/check_password_signal_response.dart';
import 'package:workflow_manager/procedures/models/response/list_resolve_response.dart';
import 'package:workflow_manager/procedures/models/response/record_is_resolve_list_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/models/params/list_resolve_request.dart';
import 'package:workflow_manager/procedures/models/response/search_procedure_model.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/list_resolve_screen.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class ListResolveRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  int pageIndex = 1;
  int _pageSize = 10;

  ListResolveRequest resolveRequest = ListResolveRequest();

  List<ServiceRecords> serviceRecords = List();
  List<ServiceRecords> serviceRecordSelected = List();

  DataResolve dataListResolve;
  DataRecordIsResolveList _dataRecordIsResolveList;

  SearchProcedureModel searchProcedureModel = SearchProcedureModel();
  int state;
  void pullToRefreshData() {
    pageIndex = 1;
  }

  Future<void> getListResolve() async {
    resolveRequest.pageIndex = pageIndex;
    resolveRequest.pageSize = _pageSize;

    final responseJSON = await apiCaller.postFormData(
        AppUrl.listResolve, resolveRequest.getParams(),
        isLoading: pageIndex == 1);
    ResolveResponse resolveResponse = ResolveResponse.fromJson(responseJSON);
    dataListResolve = resolveResponse.data;

    // set root with image
    String root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
    dataListResolve?.listServiceRecords?.forEach((element) {
      element.createdBy.avatar = "$root/${element.createdBy.avatar}";
    });

    if (resolveResponse.status == 1) {
      if (this.pageIndex == 1) {
        this.searchProcedureModel.listStates = resolveResponse.data.listStates;
        this.searchProcedureModel.listTypeResolves = resolveResponse.data.listTypeResolves;
        this.searchProcedureModel.listServices = resolveResponse.data.listServices;
        this.searchProcedureModel.listPriorities = resolveResponse.data.listPriorities;
        this.searchProcedureModel.listStatusRecords =
            resolveResponse.data.listStatusRecords;
        this.searchProcedureModel.listUserRegisters = resolveResponse.data.listUserRegister;
        this.searchProcedureModel.listDepts = resolveResponse.data.listDepts;

        this.serviceRecords.clear();
      }
      this.serviceRecords.addAll(resolveResponse.data.listServiceRecords);
      pageIndex++;
      notifyListeners();
    } else {
      ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }

  Future<void> clearListServiceRecordSelected() async {
    serviceRecordSelected.clear();
    notifyListeners();
  }

  String getCountTask(int state) {
    String sizeValue = "";
    if (dataListResolve == null) {
      return "hồ sơ";
    }

    switch (state) {
      case 1:
        {
          sizeValue = "${dataListResolve.recordTotalPending}";
          break;
        }
      case 2:
        {
          sizeValue = "${dataListResolve.recordTotalProcessed}";
          break;
        }
      case 6:
        {
          sizeValue = "${dataListResolve.recordTotalResented}";
          break;
        }
      case 7:
        {
          sizeValue = "${dataListResolve.recordTotalStar}";
          break;
        }
    }
    return "$sizeValue hồ sơ";
  }

  Future<void> recordRating(ServiceRecords model, int type) async {
    RegisterRatingRequest request = RegisterRatingRequest();
    request.idServiceRecord = model.iD;
    final responseJSON = await apiCaller.postFormData(AppUrl.registerRating, request.getParams());
    ResponseMessage responseMessage = ResponseMessage.fromJson(responseJSON);
    if (responseMessage.status == 1) {


      model.favourite.isFavourite = !model.favourite.isFavourite;
      serviceRecords[serviceRecords.indexWhere((element) => element.iD == model.iD)] = model;

      if (type == ListResolveScreen.TYPE_STAR) {
        if (!model.favourite.isFavourite) {
          this.serviceRecords.removeWhere((element) => element.iD == model.iD);
        }
      }
      notifyListeners();
    }
    ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
  }


  Future<void> recordIsResolveList(id) async {
    RecordIsResolveListRequest request = RecordIsResolveListRequest();
    request.id = id;
    var response = await apiCaller.postFormData(AppUrl.recordIsResolveList, request.getParams(), isLoading: true);
    RecordIsResolveListResponse isResolveListResponse = RecordIsResolveListResponse.fromJson(response);
    if (isResolveListResponse.status == 1) {
      _dataRecordIsResolveList = isResolveListResponse.data;
      _dataRecordIsResolveList.state=state;
      eventBus.fire(_dataRecordIsResolveList);
    } else {
      ToastMessage.show(isResolveListResponse.messages, ToastStyle.error);
    }
  }

  Future<int> recordResolveList(List<ServiceRecordsResolve> list, String password) async {
    String idSelecteds = list
        .map((e) => e.iDServiceRecord)
        .toList()
        .toString();

    Map<String, dynamic> params = new Map<String, dynamic>();
    params["ID"] = idSelecteds;
    for (int i = 0; i < list.length; i++) {
      int idHoSo = list[i].iDServiceRecord;
      params["IDStep$idHoSo"] = list[i].idStep;
      params["IDSchemaCondition$idHoSo"] = list[i].idSchemaCondition;
      params["Describe$idHoSo"] = list[i].describe ?? "";
    }
    params["Pass"] = password;
    var response = await apiCaller.postFormData(AppUrl.recordResolveList, params, isLoading: true);
    ResponseMessage responseMessage = ResponseMessage.fromJson(response);
    ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  Future<bool> checkPassword(String password) async {
    Map<String, String> params = Map();
    params["Password"] = password;
    var json = await ApiCaller.instance.postFormData(AppUrl.getQTTTSignatureCheckPasswordSignature, params);
    CheckPasswordSignalResponse response =
    CheckPasswordSignalResponse.fromJson(json);
    if (response.status == 1) {
      return response.data;
    } else {
      showErrorToast(response.messages);
      return false;
    }
  }

  void itemSelected(ServiceRecords modelSelected, int position)  {
    modelSelected.isSelected = !modelSelected.isSelected;
    serviceRecords[serviceRecords.indexWhere((element) => element.iD == modelSelected.iD)] = modelSelected;
    if(!serviceRecordSelected.contains(modelSelected)) {
      serviceRecordSelected.add(modelSelected);
    } else {
      serviceRecordSelected.remove(modelSelected);
    }

    notifyListeners();
  }

  void clearData() {
    serviceRecords.clear();
    notifyListeners();
  }
}