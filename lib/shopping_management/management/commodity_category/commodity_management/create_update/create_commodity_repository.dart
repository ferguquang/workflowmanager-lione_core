import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/commodity_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class CreateCommodityRepository with ChangeNotifier {
  List<ContentShoppingModel> list = [];
  DataCommodityCreateUpdate dataCommodityCreateUpdate;

  // selected:
  CategorySearchParams selectedManufacture = CategorySearchParams();
  CategorySearchParams selectedCategory = CategorySearchParams();

  void addList({bool isUpdate, CommodityCreateUpdate model}) {
    if (model != null) {
      // set giá trị dropdown cho hãng và danh mục hàng hóa:

      dataCommodityCreateUpdate.manufacturs?.forEach((element) {
        if (element.iD == model.iDManufactur) {
          selectedManufacture = element;
        }
      });

      dataCommodityCreateUpdate.categories?.forEach((element) {
        if (element.iD == model.iDCategory) {
          selectedCategory = element;
        }
      });

      // setSelectDMHH(selectedCategory);
      // setSelectHang(selectedManufacture);
    }

    list.add(ContentShoppingModel(key: "Code", title: "Mã hàng hóa", isRequire: true, isNextPage: false, value: model != null ? model.code : ""));
    list.add(ContentShoppingModel(key: "Name", title: "Tên hàng hóa", isRequire: true, value: model != null ? model.name : ""));
    list.add(ContentShoppingModel(
      key: "IDManufactur",
      title: "Chọn hãng",
      isDropDown: true,
      isRequire: true,
      value: model != null ? model.manufactur : "",
      idValue: model != null ? model.iDManufactur : "",
      selected: model != null ? [selectedManufacture] : [],
      getTitle: (status) => status.name,
    ));
    list.add(ContentShoppingModel(
      key: "IDCategory",
      title: "Danh mục hàng hóa",
      isDropDown: true,
      isRequire: true,
      value: model != null ? model.category : "",
      idValue: model != null ? model.iDCategory : "",
      getTitle: (status) => status.name,
      selected: model != null ? [selectedCategory] : []
    ));
    list.add(ContentShoppingModel(
        key: "Unit",
        title: "Đơn vị tính",
        value: model != null ? model.unit : ""));
    list.add(ContentShoppingModel(
        key: "UnitTransfer",
        title: "Đơn vị quy đổi",
        value: model != null ? model.unitTransfer : ""));
    list.add(ContentShoppingModel(
        key: "Description",
        title: "Mô tả",
        value: model != null ? model.description : ""));
    list.add(ContentShoppingModel(
        key: "Origin",
        title: "Xuất xứ",
        value: model != null ? model.origin : ""));
    list.add(ContentShoppingModel(
        key: "Warranty",
        title: "Bảo hành",
        value: model != null ? model.warranty : ""));
    list.add(ContentShoppingModel(
        key: "Receipt",
        title: "Chứng từ",
        value: model != null ? model.receipt : ""));
    String imageLength = "";
    if (model != null) {
      if (model.images != null) {
        imageLength = "${model.images?.length}";
      }
    }
    list.add(ContentShoppingModel(
        key: "HA",
        title: "Hình ảnh",
        value: model != null
            ? imageLength
            : "")); // key là truyền danh sách fileName, filePath cho nên sẽ ko sử dụng ở CommoditySaveRequest
    list.add(ContentShoppingModel(
        key: "Note", title: "Ghi chú", value: model != null ? model.note : ""));

    if (isUpdate == null) {
      list.forEach((element) {
        if (element.key != "HA") {
          element.isNextPage = false;
          element.isNextPage = false;
        }
      });
    }

    notifyListeners();
  }

  void changeFromDetailToUpdate() {
    list.forEach((element) {
      element.isNextPage = true;
      element.isNextPage = true;
    });
    notifyListeners();
  }


  void updateImageList(DataCommodityCreateUpdate data) {
    dataCommodityCreateUpdate = data;
    list[10].value = "${dataCommodityCreateUpdate.commodity.images.length}";
    notifyListeners();
  }

  void updateItem(ContentShoppingModel item) {
    list[list.indexWhere((element) => element.key == item.key)] = item;
    notifyListeners();
  }

  String getUrl({int id, bool isUpdate}) {
    if (isUpdate == null) {
      return AppUrl.qlmsCommodityDetail;
    } else if (id == null) {
      return AppUrl.qlmsCommodityCreate;
    } else {
      return AppUrl.qlmsCommodityUpdate;
    }
  }

  Future<void> renderCommodityCreateUpdate({int id, bool isUpdate}) async {
    Map<String, dynamic> params = Map();
    if (id != null) {
      params["ID"] = id;
    }
    var json = await ApiCaller.instance
        .postFormData(getUrl(id: id, isUpdate: isUpdate), params);
    CommodityCreateUpdateResponse response =
        CommodityCreateUpdateResponse.fromJson(json);
    if (response.isSuccess()) {
      dataCommodityCreateUpdate = response.data;
      addList(
          isUpdate: isUpdate,
          model: isUpdate ?? true ? response.data.commodity : null);
      notifyListeners();
    } else {
      // ToastMessage.show(response.messages, ToastStyle.error);
    }
  }

  void setSelectHang(CategorySearchParams itemSelected) {
    this.selectedManufacture = itemSelected;
    notifyListeners();
  }

  void setSelectDMHH(CategorySearchParams itemSelected) {
    this.selectedCategory = itemSelected;
    notifyListeners();
  }

  Future<Commodities> saveCommodity(List<ContentShoppingModel> list, List<ImageCommodity> imageList, {int id}) async {
    CommoditySaveRequest commoditySaveRequest = CommoditySaveRequest();
    commoditySaveRequest.list = list;
    commoditySaveRequest.imageList = imageList;
    commoditySaveRequest.id = id;

    Map<String, dynamic> params = commoditySaveRequest.getParams();
    if (params == null) {
      return null;
    }
    var json = await ApiCaller.instance.postFormData(id == null ? AppUrl.qlmsCommoditySave : AppUrl.qlmsCommodityChange, params);
    CommoditySaveResponse response = CommoditySaveResponse.fromJson(json);
    // ToastMessage.show(response.messages, response.status == 1 ? ToastStyle.success : ToastStyle.error);
    if (response.isSuccess()) {
      return response.data.commodity;
    }

    return null;
  }

  Future<Commodities> getByCategory(idCategory, id) async {
    GetCodeByCategoryRequest request = GetCodeByCategoryRequest();
    request.id = id;
    request.idCategory = idCategory;
    var json = await ApiCaller.instance.get(AppUrl.qlmsGetCommodityByCategory, params: request.getParams());
    CommoditySaveResponse response = CommoditySaveResponse.fromJson(json);
    if (response.status == 1) {
      return response.data.commodity;
    } else {
      return null;
    }
  }

  Future<int> removeItem(int id) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    var json = await ApiCaller.instance.delete(AppUrl.qlmsCommodityDelete, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    // if (responseMessage.status == 1) {
    //   // this.dataCommodityIndex.commodities.removeWhere((element) => element.iD == item.iD);
    // }
    responseMessage.isSuccess();
    // ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }
}