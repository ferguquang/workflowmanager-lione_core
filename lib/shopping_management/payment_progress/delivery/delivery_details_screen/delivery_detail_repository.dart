import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';

class DeliveryDetailRepository extends ChangeNotifier {
  static const String MA_YEUCAU = "Mã yêu cầu";
  static const String LOAI_DENGHI = "Loại đề nghị";
  static const String HINHTHUC_MUASAM = "Hình thức mua sắm";
  static const String DU_AN = "Dự án";
  static const String MA_HOPDONG = "Mã hợp đồng";
  static const String TIENTE = "Tiền tệ";
  static const String TY_GIA = "Tỷ giá";
  static const String NHA_CC = "Nhà cung cấp";
  static const String NGAYKY_HDPO = "Ngày ký HĐ/PO";
  static const String NGUOI_KY = "Người ký";
  static const String CHUC_VU = "Chức vụ";
  static const String TONG_CONG = "Tổng cộng";
  static const String TONG_TT_1 = "Tổng thanh toán lần 1";
  static const String TONG_TT_2 = "Tổng thanh toán lần 2";
  static const String TONG_TT_3 = "Tổng thanh toán lần 3";
  static const String TONG_NO = "Tổng nợ";
  ContentShoppingModel codeRequestItem,
      typeRecommendedItem,
      suggestionTypeItem,
      projectItem,
      codeContractItem,
      currencyItem,
      exchangeRateItem,
      supplierItem,
      pOItem,
      theSignerItem,
      positionItem,
      sumItem,
      signingApprovalItem;
  DeliveryDetailModel deliveryDetailModel;
  List<ContentShoppingModel> fixItems = [];

  setFixItems() {
    fixItems = [];
    Contract data = deliveryDetailModel?.contract;
    codeRequestItem = ContentShoppingModel(
        title: "Mã yêu cầu",
        value: data?.requisitionNumber ?? "",
        isNextPage: false);
    typeRecommendedItem = ContentShoppingModel(
        title: "Loại đề nghị",
        value: data?.suggestionType ?? "",
        isNextPage: false);
    suggestionTypeItem = ContentShoppingModel(
        title: "Hình thức mua sắm",
        value: data?.shoppingType ?? "",
        isNextPage: false);
    projectItem = ContentShoppingModel(
        title: "Dự án", value: data?.project ?? "", isNextPage: false);
    codeContractItem = ContentShoppingModel(
        title: "Mã hợp đồng",
        value: data?.pONumber ?? "",
        isNextPage: false);
    currencyItem = ContentShoppingModel(
        title: "Tiền tệ", value: data?.currencyCode ?? "", isNextPage: false);
    exchangeRateItem = ContentShoppingModel(
        title: "Tỉ giá",
        value: getCurrencyFormat(data?.currencyRate?.toString(),
                isAllowDot: true) ??
            "",
        isNextPage: false);
    supplierItem = ContentShoppingModel(
        title: "Nhà cung cấp",
        value: data?.provider ?? "",
        isNextPage: false);
    pOItem = ContentShoppingModel(
        title: "Ngày ký HĐ/PO:",
        value: replaceDateToMobileFormat(data?.signDate),
        isNextPage: false);
    theSignerItem = ContentShoppingModel(
        title: "Người ký", value: data?.signBy ?? "", isNextPage: false);
    positionItem = ContentShoppingModel(
        title: "Chức vụ", value: data?.jobPosition ?? "", isNextPage: false);
    sumItem = ContentShoppingModel(
        title: "Tổng cộng",
        value: data?.totalAmount ?? "",
        isNextPage: false);
    signingApprovalItem = ContentShoppingModel(
        title: "Tiến độ hàng về", value: "Chi tiết", isNextPage: true);
    fixItems.add(codeRequestItem);
    fixItems.add(typeRecommendedItem);
    fixItems.add(suggestionTypeItem);
    fixItems.add(projectItem);
    fixItems.add(codeContractItem);
    fixItems.add(currencyItem);
    fixItems.add(exchangeRateItem);
    fixItems.add(supplierItem);
    fixItems.add(pOItem);
    fixItems.add(theSignerItem);
    fixItems.add(positionItem);
    fixItems.add(sumItem);
    fixItems.add(signingApprovalItem);
  }

  getViewInfo(int id) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsDeliveryView, {"ID": id});
    DeliveryDetailResponse response = DeliveryDetailResponse.fromJson(json);
    if (response.isSuccess()) {
      deliveryDetailModel = response.data;
      setFixItems();
      notifyListeners();
    }
  }

  getUpdateInfo(int id) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsDeliveryUpdate, {"ID": id});
    DeliveryDetailResponse response = DeliveryDetailResponse.fromJson(json);
    if (response.isSuccess()) {
      deliveryDetailModel = response.data;
      setFixItems();
      notifyListeners();
    }
  }

  Future<bool> save(Map<String, dynamic> params) async {
    if (isNullOrEmpty(params)) return false;
    var json =
        await ApiCaller.instance.postFormData(AppUrl.qlmsDeliverySave, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  Future<bool> complete(Map<String, dynamic> params) async {
    if (isNullOrEmpty(params)) return false;
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsDeliveryFinish, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
