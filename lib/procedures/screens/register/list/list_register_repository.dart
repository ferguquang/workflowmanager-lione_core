import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/params/list_register_request.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/models/response/search_procedure_model.dart';
import 'package:workflow_manager/procedures/screens/register/list/list_register_screen.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class ListRegisterRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  int pageIndex = 1;
  int _pageSize = 10;

  ListRegisterRequest registerRequest = ListRegisterRequest();

  List<ServiceRecords> serviceRecords = List();

  DataListRegister dataListRegister;

  SearchProcedureModel searchProcedureModel = SearchProcedureModel();

  void pullToRefreshData() {
    pageIndex = 1;
  }

  Future<void> getListRegister() async {
    // tạm thời comment vào
    registerRequest.pageIndex = pageIndex;
    registerRequest.pageSize = _pageSize;
    final responseJSON = await apiCaller.postFormData(
        AppUrl.listRegister, registerRequest.getParams(),
        isLoading: pageIndex == 1);
    ListRegisterResponse registerResponse =
        ListRegisterResponse.fromJson(responseJSON);
    if (registerResponse.status == 1) {
      dataListRegister = registerResponse.data;
      if (this.pageIndex == 1) {
        this.searchProcedureModel.listStates =
            registerResponse.data.filterStates;
        this.searchProcedureModel.listTypeResolves =
            registerResponse.data.typeResolves;
        this.searchProcedureModel.listServices = registerResponse.data.services;
        this.searchProcedureModel.listPriorities =
            registerResponse.data.filterPriorities;
        this.searchProcedureModel.listStatusRecords =
            registerResponse.data.filterStatusRecords;
        this.serviceRecords.clear();
      }
      this.serviceRecords.addAll(registerResponse.data.serviceRecords);
      pageIndex++;
      notifyListeners();

      // event để truyền lấy số bản ghi của từng tab
      eventBus.fire(dataListRegister);
    } else {
      ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }

  Future<int> removeItem(ServiceRecords model) async {
    RegisterRemoveRequest request = RegisterRemoveRequest();
    request.id = model.iD;
    var response = await apiCaller.postFormData(
        AppUrl.registerRemove, request.getParams());
    ResponseMessage responseMessage = ResponseMessage.fromJson(response);
    if (responseMessage.status == 1) {
      // this.serviceRecords.removeWhere((element) => element.iD == model.iD);
      notifyListeners();
    }
    ToastMessage.show(responseMessage.messages,
        responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  Future<void> registerRating(ServiceRecords model, int type) async {
    RegisterRatingRequest request = RegisterRatingRequest();
    request.idServiceRecord = model.iD;
    final responseJSON = await apiCaller.postFormData(
        AppUrl.registerRating, request.getParams());
    ResponseMessage responseMessage = ResponseMessage.fromJson(responseJSON);
    if (responseMessage.status == 1) {
      model.favourite.isFavourite = !model.favourite.isFavourite;
      serviceRecords[serviceRecords
          .indexWhere((element) => element.iD == model.iD)] = model;

      if (type == ListRegisterScreen.TYPE_STAR) {
        if (!model.favourite.isFavourite) {
          this.serviceRecords.removeWhere((element) => element.iD == model.iD);
        }
      }

      notifyListeners();
    }
    ToastMessage.show(responseMessage.messages,
        responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
  }

  String getCountTask(int state) {
    String sizeValue = "";
    if (dataListRegister == null) {
      return "hồ sơ";
    }
    switch (state) {
      case 0:
        {
          sizeValue = "${dataListRegister.recordTotal}";
          break;
        }
      case 1:
        {
          sizeValue = "${dataListRegister.recordTotalPending}";
          break;
        }
      case 2:
        {
          sizeValue = "${dataListRegister.recordTotalProcessing}";
          break;
        }
      case 3:
        {
          sizeValue = "${dataListRegister.recordTotalProcessed}";
          break;
        }
      case 4:
        {
          sizeValue = "${dataListRegister.recordTotalRejected}";
          break;
        }
      case 5:
        {
          sizeValue = "${dataListRegister.recordTotalCancel}";
          break;
        }
      case 6:
        {
          sizeValue = "${dataListRegister.recordTotalResented}";
          break;
        }
      case 7:
        {
          sizeValue = "${dataListRegister.recordTotalStar}";
          break;
        }
    }
    return "$sizeValue hồ sơ";
  }
}
