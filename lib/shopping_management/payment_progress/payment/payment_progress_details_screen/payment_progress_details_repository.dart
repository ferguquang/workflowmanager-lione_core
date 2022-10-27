import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/payment_progress_detail_response.dart';

class ProgressPaymentDetailRepository extends ChangeNotifier {
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
  ContentShoppingModel payAmount1,
      payAmount2,
      payAmount3,
      totalDept,
      totalAmount;
  PaymentProgressDetailModel paymentProgressDetailModel;
  List<ContentShoppingModel> fixItems = [];
  List<ContractDetails> backup;

  setFixItems() {
    fixItems = [];
    Contract data = paymentProgressDetailModel?.contract;
    fixItems.add(ContentShoppingModel(
        title: MA_YEUCAU, value: data?.requisitionNumber, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: LOAI_DENGHI, value: data?.suggestionType, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: HINHTHUC_MUASAM, value: data?.shoppingType, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: DU_AN, value: data?.project, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: MA_HOPDONG, value: data?.pONumber, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: TIENTE, value: data?.currency, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: TY_GIA, value: data?.rate ?? 0, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: NHA_CC, value: data?.provider, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: NGAYKY_HDPO,
        value: convertTimeStampToHumanDate(data?.signDate, Constant.ddMMyyyy),
        isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: NGUOI_KY, value: data?.signBy, isNextPage: false));
    fixItems.add(ContentShoppingModel(
        title: CHUC_VU, value: data?.jobPosition, isNextPage: false));
    totalAmount = ContentShoppingModel(
        title: TONG_CONG, value: data?.totalAmount, isNextPage: false);
    fixItems.add(totalAmount);
    payAmount1 = ContentShoppingModel(
        title: TONG_TT_1, value: data?.payAmount1, isNextPage: false);
    fixItems.add(payAmount1);
    payAmount2 = ContentShoppingModel(
        title: TONG_TT_2, value: data?.payAmount2, isNextPage: false);
    fixItems.add(payAmount2);
    payAmount3 = ContentShoppingModel(
        title: TONG_TT_3, value: data?.payAmount3, isNextPage: false);
    fixItems.add(payAmount3);
    totalDept = ContentShoppingModel(
        title: TONG_NO, value: data?.totalDebt, isNextPage: false);
    fixItems.add(totalDept);
  }

  loadData(int id, bool isEditting) async {
    var api = isEditting
        ? AppUrl.qlmsPaymentProgressUpdate
        : AppUrl.qlmsPaymentProgressDetail;
    var json = await ApiCaller.instance.postFormData(api, {"ID": id});
    PaymentProgressDetailResponse response =
        PaymentProgressDetailResponse.fromJson(json);
    if (response.isSuccess()) {
      paymentProgressDetailModel = response.data;
      backupContractDetails();
      setFixItems();
      notifyListeners();
    }
  }

  backupContractDetails() {
    backup = [];
    for (ContractDetails contractDetails
        in paymentProgressDetailModel.contractDetails) {
      ContractDetails save = ContractDetails();
      contractDetails.copyTo(save);
      backup.add(save);
    }
  }

  Future<bool> save(Map<String, dynamic> params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsPaymentProgressSave, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    var result = baseResponse.isSuccess(isShowSuccessMessage: true);
    if (result) backupContractDetails();
    return result;
  }

  Future<bool> completed(Map<String, dynamic> params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsPaymentProgressComplete, params);
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
