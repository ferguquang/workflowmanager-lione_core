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

class ProviderVoteRepository with ChangeNotifier {
  DataProviderVotes dataProviderVotes = DataProviderVotes();
  int skip = 1;
  int _take = 10;
  ProviderVoteIndexRequest request = ProviderVoteIndexRequest();

  void pullToRefreshData() {
    dataProviderVotes.providerVotes?.clear();
    skip = 1;
  }

  Future<void> getProviderVote() async {
    request.skip = skip;
    request.take = _take;
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsProviderVoteIndex, request.getParams());
    ProviderVoteIndexResponse response =
        ProviderVoteIndexResponse.fromJson(json);
    if (response.status == 1) {
      dataProviderVotes.isCreate = response.data.isCreate;
      dataProviderVotes.totalRecord = response.data.totalRecord;
      dataProviderVotes.searchParam = response.data.searchParam;
      if (this.skip == 1) {
        dataProviderVotes.providerVotes = response.data.providerVotes;
      } else {
        dataProviderVotes.providerVotes
            .addAll(response.data.providerVotes.toList());
      }
      skip++;
      notifyListeners();
    }
  }

  String getUrl({int id, bool isDetail = false}) {
    if (isDetail) {
      return AppUrl.qlmsProviderVoteDetail;
    } else {
      return id == null
          ? AppUrl.qlmsProviderVoteCreate
          : AppUrl.qlmsProviderVoteUpdate;
    }
  }

  Future<List<ContentShoppingModel>> renderDetail(
      {int id, bool isDetail = false}) async {
    Map<String, dynamic> params = Map();
    if (id != null) {
      params["ID"] = id;
    }
    String url = getUrl(id: id, isDetail: isDetail);
    var json = await ApiCaller.instance.postFormData(url, params);
    RenderCreateUpdateProviderVoteResponse response =
        RenderCreateUpdateProviderVoteResponse.fromJson(json);
    if (response.status == 1) {
      // data = response.data;
      // addList(response.data);
      return addList(response.data);
    }
  }

  List<ContentShoppingModel> addList(DataRenderCreateUpdateProviderVote model) {
    List<ContentShoppingModel> list = [];
    String valueProject = model.providerVote.project
        .map((e) => "${e.name}")
        .toList()
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "");

    String valueProjectID = model.providerVote.project
        .map((e) => "${e.iD}")
        .toList()
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "");
    if (valueProjectID == "0") {
      valueProject = "";
    }
    list.add(ContentShoppingModel(
      key: "IDProject",
      title: "Dự án",
      isDropDown: true,
      dropDownData: model != null ? model.projects : [],
      value: model.providerVote != null ? valueProject : "",
      // idValue: model != null ? model.iDManufactur : "",
      // selected: [selectedManufacture]
    ));

    list.add(ContentShoppingModel(
      key: "IDProvider",
      title: "Mã nhà cung cấp",
      isDropDown: true,
      isRequire: true,
      dropDownData: model != null ? model.providers : [],
      value: model.providerVote != null ? model.providerVote.code.code : "",
    ));
    list.add(ContentShoppingModel(
      key: "IDManufactur",
      title: "Tên nhà cung cấp",
      isDropDown: true,
      isRequire: true,
      isNextPage: false,
      value: model.providerVote.name
    ));
    list.add(ContentShoppingModel(key: "PricePoint", title: "Giá", isNumeric: true, value: model != null ? model.providerVote.pricePoint : ""));
    list.add(ContentShoppingModel(key: "PaymentPoint", title: "Điều kiện thanh toán", isNumeric: true, value: model != null ? model.providerVote.paymentPoint : ""));
    list.add(ContentShoppingModel(key: "DeliveryPoint", title: "Tiến độ giao hàng", isNumeric: true, value: model != null ? model.providerVote.deliveryPoint : ""));
    list.add(ContentShoppingModel(key: "QualityPoint", title: "Chất lượng giao hàng", isNumeric: true, value: model != null ? model.providerVote.qualityPoint : ""));
    list.add(ContentShoppingModel(key: "CoordinatePoint", title: "Phối hợp", isNumeric: true, value: model != null ? model.providerVote.coordinatePoint : ""));
    list.add(ContentShoppingModel(key: "", title: "Tổng điểm", isNextPage: false, value: model != null ? model.providerVote.totalPoint : ""));
    list.add(ContentShoppingModel(key: "Buyer", title: "Nhân viên mua hàng", value: model != null ? model.providerVote.buyer : ""));
    list.add(ContentShoppingModel(key: "", title: "Thời gian lập", isNextPage: false, value: model != null ? model.providerVote.created : ""));
    list.add(ContentShoppingModel(key: "Note", title: "Ghi chú", value: model != null ? model.providerVote.note : ""));

    list.forEach((element) {
      element.isNextPage = false;
    });
    return list;
  }

  Future<void> removeItem(ProviderVotes item) async {
    Map<String, dynamic> params = Map();
    params["ID"] = item.iD;
    var json = await ApiCaller.instance.delete(AppUrl.qlmsProviderVoteRemove, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    if (responseMessage.isSuccess()) {
      this.dataProviderVotes.providerVotes.removeWhere((element) => element.iD == item.iD);
      notifyListeners();
    }
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  List<ContentShoppingModel> addFilter() {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(
        key: "Provider",
        title: "Mã hoặc tên nhà cung cấp",
        value: isNotNullOrEmpty(request.provider) ? request.provider : ""));
    list.add(ContentShoppingModel(
        key: "Contract",
        title: "Tên hoặc mã dự án",
        value: isNotNullOrEmpty(request.contract) ? request.contract : ""));
    String valueDept = "";
    List<CategorySearchParams> deptSelected = [];
    if (isNotNullOrEmpty(request.idCategorys) &&
        request.idCategorys != "null") {
      List<String> stringList = request.idCategorys.split(',');
      for (int i = 0; i < stringList.length; i++) {
        String idCategory = stringList[i];
        for (int j = 0;
            j < dataProviderVotes.searchParam.categorys.length;
            j++) {
          String id = "${dataProviderVotes.searchParam.categorys[j].iD}";
          if (idCategory == (id)) {
            deptSelected.add(dataProviderVotes.searchParam.categorys[j]);
          }
        }
      }
    }
    list.add(ContentShoppingModel(
        key: "IDCategorys",
        title: "Danh mục hàng hóa",
        isDropDown: true,
        selected: deptSelected,
        isSingleChoice: false,
        dropDownData: dataProviderVotes.searchParam.categorys,
        idValue: isNotNullOrEmpty(request.idCategorys) &&
                request.idCategorys != "null"
            ? request.idCategorys
            : "",
        getTitle: (status) => status.name,
        value: valueDept));
    return list;
  }
}
