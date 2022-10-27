import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/manufacture_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/shopping_management/response/manufacture_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class ManufactureRepository with ChangeNotifier {
  ManufactureIndexRequest request = ManufactureIndexRequest();
  DataManufacturIndex dataManufacturIndex = DataManufacturIndex();
  int skip = 1;
  int _take = 10;

  void pullToRefreshData() {
    dataManufacturIndex.manufacturs?.clear();
    skip = 1;
  }

  Future<void> getManufactureIndex() async {
    request.skip = skip;
    request.take = _take;
    var json = await ApiCaller.instance.postFormData(AppUrl.qlmsManufacturIndex, request.getParams());
    ManufacturIndexResponse response = ManufacturIndexResponse.fromJson(json);
    if (response.status == 1) {
      dataManufacturIndex.isCreate = response.data.isCreate;
      dataManufacturIndex.totalRecord = response.data.totalRecord;
      if (this.skip == 1) {
        dataManufacturIndex.manufacturs = response.data.manufacturs;
      } else {
        dataManufacturIndex.manufacturs.addAll(response.data.manufacturs.toList());
      }
      skip++;
      notifyListeners();
    }
  }

  List<ContentShoppingModel> addList({bool isUpdate, ManufacturRender model, List<CategorySearchParams> categories}) {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(
        key: "Code",
        title: "Mã hãng",
        isRequire: true,
        value: model != null ? model.code : ""));
    list.add(ContentShoppingModel(
        key: "Name",
        title: "Tên hãng",
        isRequire: true,
        value: model != null ? model.name : ""));

    String categoryString = "";
    String categoryID = "";
    List<CategorySearchParams> categoriesSelected = [];
    if (model != null && isNotNullOrEmpty(model.categories)) {
      categoryString = model.categories
          .map((e) => "${e.name}")
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      categoryID = model.categories
          .map((e) => "${e.iD}")
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");

      for (int i = 0; i < categories.length; i++) {
        for (int j = 0; j < model.categories.length; j++) {
          if (categories[i].iD == model.categories[j].iD) {
            categoriesSelected.add(categories[i]);
          }
        }
      }
    }
    list.add(ContentShoppingModel(
        key: "IDCategories",
        title: "Danh mục hàng hóa",
        isDropDown: true,
        isRequire: true,
        selected: categoriesSelected,
        dropDownData: categories,
        idValue: categoryID,
        value: model != null ? categoryString : "",
        getTitle: (status) => status.name,
        isSingleChoice: false));
    list.add(ContentShoppingModel(
        key: "Place",
        title: "Địa chỉ",
        value: model != null ? model.place : ""));
    list.add(ContentShoppingModel(
        key: "Contact",
        title: "Người liên hệ",
        value: model != null ? model.contact : ""));
    list.add(ContentShoppingModel(
        key: "Email", title: "Email", value: model != null ? model.email : ""));
    list.add(ContentShoppingModel(
        key: "Phone",
        title: "Số điện thoại người liên hệ",
        isNumeric: true,
        value: model != null ? model.phone : ""));

    return list;
  }

  // void updateItem(ContentShoppingModel item) {
  //   list[list.indexWhere((element) => element.key == item.key)] = item;
  //   notifyListeners();
  // }

  Future<DataManufactureRender> renderForm({bool isUpdate = false, int id}) async {
    Map<String, dynamic> params = Map();
    if (isUpdate) {
      params["ID"] = id;
    }
    var json = await ApiCaller.instance.postFormData(isUpdate ? AppUrl.qlmsManufacturUpdate : AppUrl.qlmsManufacturCreate, params);
    ManufacturRenderResponse response = ManufacturRenderResponse.fromJson(json);
    if (response.status == 1) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<int> createUpdateManufacture(bool isUpdate, List<ContentShoppingModel> result, {int id}) async {
    CreateUpdateManufactureRequest request = CreateUpdateManufactureRequest();
    request.list = result;
    if (isUpdate) {
      request.id = id;
    }
    var json = await ApiCaller.instance.postFormData(isUpdate ? AppUrl.qlmsManufacturChange : AppUrl.qlmsManufacturSave, request.getParams());
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    responseMessage.isSuccess();
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  Future<void> removeItem(Manufacturs item) async {
    Map<String, dynamic> params = Map();
    params["ID"] = item.iD;
    var json =
        await ApiCaller.instance.delete(AppUrl.qlmsManufacturRemove, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    if (responseMessage.isSuccess()) {
      this
          .dataManufacturIndex
          .manufacturs
          .removeWhere((element) => element.iD == item.iD);
      notifyListeners();
    }
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    // return responseMessage.status;
  }

  List<ContentShoppingModel> renderDetail(Manufacturs item) {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(
        key: "Code", title: "Mã hãng", isRequire: true, value: item.code));
    list.add(ContentShoppingModel(
        key: "Name", title: "Tên hãng", isRequire: true, value: item.name));
    list.add(ContentShoppingModel(
        key: "IDCategories",
        title: "Danh mục hàng hóa",
        isRequire: true,
        value: item.categorys,
        getTitle: (status) => status.name,
        isSingleChoice: false));
    list.add(ContentShoppingModel(
        key: "Place", title: "Địa chỉ", value: item.place));
    list.add(ContentShoppingModel(
        key: "Contact", title: "Người liên hệ", value: item.contact));
    list.add(
        ContentShoppingModel(key: "Email", title: "Email", value: item.email));
    list.add(ContentShoppingModel(
        key: "Phone",
        title: "Số điện thoại người liên hệ",
        isNumeric: true,
        value: item.phone));

    list.forEach((element) {
      element.isNextPage = false;
    });
    return list;
  }
}