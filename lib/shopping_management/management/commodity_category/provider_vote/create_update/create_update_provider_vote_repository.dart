import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/provider_vote_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/shopping_management/response/provider_vote_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class CreateUpdateProviderVoteRepository with ChangeNotifier {
  DataRenderCreateUpdateProviderVote data;
  List<ContentShoppingModel> list = [];

  CategorySearchParams projectSelected;
  CategorySearchParams codeSelected;

  Future<DataRenderCreateUpdateProviderVote> renderCreateUpdate({int id}) async {
    Map<String, dynamic> params = Map();
    if (id != null) {
      params["ID"] = id;
    }
    var json = await ApiCaller.instance.postFormData(id == null ? AppUrl.qlmsProviderVoteCreate : AppUrl.qlmsProviderVoteUpdate, params);
    RenderCreateUpdateProviderVoteResponse response = RenderCreateUpdateProviderVoteResponse.fromJson(json);
    if (response.isSuccess()) {
      data = response.data;
      addList(data);
      notifyListeners();
    }
  }

  List<ContentShoppingModel> addList(DataRenderCreateUpdateProviderVote model) {
    String valueProject = "", valueCode = "";
    String valueProjectID = "", valueCodeID;
    if (model.providerVote != null) {
      // dự án
      valueProject = model.providerVote.project
          .map((e) => "${e.name}")
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      valueProjectID = model.providerVote.project
          .map((e) => "${e.iD}")
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      if (valueProjectID == "0") {
        valueProject = "";
      }

      for (int i = 0; i < model.providerVote.project.length; i++) {
        int idProjectSelected = model.providerVote.project[i].iD;
        for (int j = 0; j < model.projects.length; j++) {
          int idProject = model.projects[j].iD;
          if (idProjectSelected == idProject) {
            projectSelected = model.projects[j];
            break;
          }
        }
      }

      // code:
      valueCode = model.providerVote.code.code;
      valueCodeID = "${model.providerVote.code.iDProvider}";
      for (int i = 0; i < model.providers.length; i++) {
        if (model.providers[i].iD == model.providerVote.code.iDProvider) {
          codeSelected = model.providers[i];
          break;
        }
      }
    }

    list.add(ContentShoppingModel(
        key: "IDProject",
        title: "Dự án",
        isDropDown: true,
        dropDownData: /* model != null ?*/ model.projects /*: []*/,
        value: model.providerVote != null ? valueProject : "",
        idValue: model.providerVote != null ? valueProjectID : "",
        selected: projectSelected != null ? [projectSelected] : [],
        getTitle: (status) {
          return status.name;
        }));

    // if (codeSelected == null) {
    //   codeSelected.iD = 0;
    //   codeSelected.name = "Chưa xác định";
    // }
    list.add(ContentShoppingModel(
        key: "IDProvider",
        title: "Mã nhà cung cấp",
        isDropDown: true,
        isRequire: true,
        dropDownData: /*model != null ?*/ model.providers /*: []*/,
        value: model.providerVote != null ? valueCode : "",
        selected: codeSelected != null ? [codeSelected] : [],
        getTitle: (status) {
          return status.name;
        }));
    list.add(ContentShoppingModel(
        key: "IDManufactur",
        title: "Tên nhà cung cấp",
        isDropDown: true,
        isRequire: true,
        isNextPage: false,
        value: model.providerVote != null ? model.providerVote.name : ""));
    list.add(ContentShoppingModel(
        key: "PricePoint",
        title: "Giá",
        isNumeric: true,
        value:
            model.providerVote != null ? model.providerVote.pricePoint : ""));
    list.add(ContentShoppingModel(
        key: "PaymentPoint",
        title: "Điều kiện thanh toán",
        isNumeric: true,
        value:
            model.providerVote != null ? model.providerVote.paymentPoint : ""));
    list.add(ContentShoppingModel(
        key: "DeliveryPoint",
        title: "Tiến độ giao hàng",
        isNumeric: true,
        value: model.providerVote != null
            ? model.providerVote.deliveryPoint
            : ""));
    list.add(ContentShoppingModel(
        key: "QualityPoint",
        title: "Chất lượng giao hàng",
        isNumeric: true,
        value:
            model.providerVote != null ? model.providerVote.qualityPoint : ""));
    list.add(ContentShoppingModel(
        key: "CoordinatePoint",
        title: "Phối hợp",
        isNumeric: true,
        value: model.providerVote != null
            ? model.providerVote.coordinatePoint
            : ""));
    list.add(ContentShoppingModel(
        key: "",
        title: "Tổng điểm",
        isNextPage: false,
        value:
            model.providerVote != null ? model.providerVote.totalPoint : ""));
    list.add(ContentShoppingModel(
        key: "Buyer",
        title: "Nhân viên mua hàng",
        value: model.providerVote != null ? model.providerVote.buyer : ""));
    list.add(ContentShoppingModel(
        key: "",
        title: "Thời gian lập",
        isNextPage: false,
        value: model.providerVote != null ? model.providerVote.created : ""));
    list.add(ContentShoppingModel(
        key: "Note",
        title: "Ghi chú",
        value: model.providerVote != null ? model.providerVote.note : ""));

    return list;
  }

  Future<int> providerSave({int id}) async {
    ProviderVoteSaveRequest request = ProviderVoteSaveRequest();
    request.list = list;
    if (id != null) {
      request.id = id;
    }
    var json = await ApiCaller.instance.postFormData(id == null ? AppUrl.qlmsProviderVoteSave : AppUrl.qlmsProviderVoteChange, request.getParams());
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    responseMessage.isSuccess();
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  Future<void> getProviderByProject(int idProject) async {
    Map<String, dynamic> params = Map();
    params["ID"] = idProject;
    var json = await ApiCaller.instance.get(AppUrl.qlmsGetProvidersByProject, params: params);
    RenderCreateUpdateProviderVoteResponse response = RenderCreateUpdateProviderVoteResponse.fromJson(json);
    if (response.status == 1) {
      // list[1].dropDownData = response.data.providers;

      list[1].idValue = "";
      list[1].value = "";
      list[2].value = "";
      data.providers = response.data.providers;
      notifyListeners();
    }
  }

  Future<void> getNameByProvider(int idProvider) async {
    Map<String, dynamic> params = Map();
    params["ID"] = idProvider;
    var json = await ApiCaller.instance.get(AppUrl.qlmsGetNameByProvider, params: params);
    GetNameByProviderResponse response = GetNameByProviderResponse.fromJson(json);
    if (response.status == 1) {
      list[2].value = response.data.name;
      notifyListeners();
    }
  }

  void updateItem(ContentShoppingModel item) {
    list[list.indexWhere((element) => element.key == item.key)] = item;
    notifyListeners();
  }

  void calculateTotal() {
    int gia = isNotNullOrEmpty(list[3].value) ? int.parse(list[3].value.toString()) : 0;
    int dktt = isNotNullOrEmpty(list[4].value) ? int.parse(list[4].value.toString()) : 0;
    int tdgh = isNotNullOrEmpty(list[5].value) ? int.parse(list[5].value.toString()) : 0;
    int clgh = isNotNullOrEmpty(list[6].value) ? int.parse(list[6].value.toString()) : 0;
    int ph = isNotNullOrEmpty(list[7].value) ? int.parse(list[7].value.toString()) : 0;
    int total = gia + dktt + tdgh + clgh + ph;
    list[8].value = total.toString();
    notifyListeners();
  }
}