import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_list_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_mail_response.dart';

import 'delivery_progress_detail_screen.dart';

class DeliveryProgressDetailRepository extends ChangeNotifier {
  final String DELIVERY = "Người giao";
  final String RECEIVER = "Người nhận";
  final String ACT_DELIVERY_DATE = "Ngày giao";
  final String STATUS = "Trạng thái";
  final String CHECK_SLIP = "Phiếu kiểm tra";
  int viewType;
  ContentShoppingModel deliveryItem,
      receiverItem,
      actDeliveryDateItem,
      statusItem,
      checkSlip;

  List<ContentShoppingModel> fixItems = [];
  DeliveryProgressDetailModel deliveryProgressDetailModel;

  loadData(int id, bool isCreate) async {
    var json = await ApiCaller.instance.postFormData(
        isCreate
            ? AppUrl.qlmsCreateDeliveryProgress
            : AppUrl.qlmsUpdateDeliveryProgress,
        {"ID": id});
    DeliveryProgressDetailResponse response =
        DeliveryProgressDetailResponse.fromJson(json);
    if (response.isSuccess()) {
      deliveryProgressDetailModel = response.data;
      for (var line in deliveryProgressDetailModel.detailDeliveries) {
        line.isCheckList = line.isChecked;
      }
      setFixItems(viewType);
      notifyListeners();
    }
  }

  setFixItems(int viewType) {
    bool isView = viewType == DeliveryProgressDetailScreen.view_type;
    fixItems = [];
    DeliveryProgressLog deliveryProgressLog =
        deliveryProgressDetailModel?.deliveryProgressLog;
    deliveryItem = new ContentShoppingModel(
        title: DELIVERY,
        isRequire: true,
        value: deliveryProgressLog?.deliver?.value ?? "",
        isNextPage: !(deliveryProgressLog?.deliver?.isReadOnly ?? false));
    receiverItem = new ContentShoppingModel(
        title: RECEIVER,
        isRequire: true,
        value: viewType == DeliveryProgressDetailScreen.create_type
            ? deliveryProgressDetailModel?.receiver?.name
            : deliveryProgressLog?.receiver?.value,
        isNextPage: !(deliveryProgressLog?.receiver?.isReadOnly ?? false));
    actDeliveryDateItem = new ContentShoppingModel(
        title: ACT_DELIVERY_DATE,
        isRequire: true,
        value: replaceDateToMobileFormat(
            deliveryProgressLog?.actDeliveryDate?.value ?? ""),
        isNextPage:
            !(deliveryProgressLog?.actDeliveryDate?.isReadOnly ?? false),
        isFullDate: true);
    statusItem = new ContentShoppingModel(
        title: STATUS,
        isDropDown: true,
        isSingleChoice: true,
        dropDownData: deliveryProgressDetailModel?.status ?? [],
        value: deliveryProgressLog?.status?.name ?? "",
        getTitle: (data) => data.name,
        selected: isNotNullOrEmpty(deliveryProgressDetailModel?.status) &&
                viewType == DeliveryProgressDetailScreen.create_type
            ? [deliveryProgressDetailModel?.status[0]]
            : deliveryProgressDetailModel?.status
                ?.where(
                    (element) => element.iD == deliveryProgressLog?.status?.iD)
                ?.toList(),
        isNextPage: !(deliveryProgressLog?.status?.isReadOnly ?? false));
    checkSlip = new ContentShoppingModel(
        title: CHECK_SLIP, value: "Chi tiết", isNextPage: true);

    fixItems.add(deliveryItem);
    fixItems.add(receiverItem);
    fixItems.add(actDeliveryDateItem);
    fixItems.add(statusItem);
    if (isView) fixItems.add(checkSlip);
  }

  sendMail(Map<String, dynamic> params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsDeliveryProgressSendMail, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  Future<DeliveryProgressMailModel> getMailInfo(
      Map<String, dynamic> params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsDeliveryProgressViewSendMail, params);
    DeliveryProgressMailResponse response =
        DeliveryProgressMailResponse.fromJson(json);
    if (response.isSuccess()) {
      return response.data;
    }
    return null;
  }

  Future<bool> save(Map<String, dynamic> params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsChangeDeliveryProgress, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  Future<bool> sendCheck(Map<String, dynamic> params) async {
    var json =
        await ApiCaller.instance.postFormData(AppUrl.qlmsSendCheck, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  Future<bool> create(Map<String, dynamic> params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsSaveDeliveryProgress, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
