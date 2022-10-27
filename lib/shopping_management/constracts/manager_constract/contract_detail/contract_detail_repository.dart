import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/choose_provider_params.dart';
import 'package:workflow_manager/shopping_management/request/contract_detail_send_params.dart';
import 'package:workflow_manager/shopping_management/request/contract_details_params.dart';
import 'package:workflow_manager/shopping_management/request/provider_details_params.dart';
import 'package:workflow_manager/shopping_management/response/choose_provider_response.dart';
import 'package:workflow_manager/shopping_management/response/contract_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/exhange_rate_response.dart';
import 'package:workflow_manager/shopping_management/response/provider_detail_response.dart';
import 'package:workflow_manager/base/extension/int.dart';
import 'package:workflow_manager/shopping_management/response/sign_info_response.dart';

class ContractDetailRepository extends ChangeNotifier {
  static final String CONTRACT_DETAIL = "Hợp đồng gốc";
  static final String SIGNINGAPPROVAL_DETAIL = "Ký duyệt";
  ContractDetailModel contractDetailModel;
  List<ContentShoppingModel> listItem = [];
  bool isEditting = false;
  bool isUpdate = false;
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
      paymentsItem,
      contentItem,
      signingApprovalItem,
      contractItem,
      sumItem;

  Future<void> loadData(int id) async {
    ContractDetailsParams params = ContractDetailsParams();
    params.id = id;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.qlmsContractDetail, params.getParams());
    ContractDetailResponse contractDetailsResponse =
        ContractDetailResponse.fromJson(response);
    if (contractDetailsResponse.status == 1) {
      contractDetailModel = contractDetailsResponse.data;
      isUpdate = contractDetailModel.contract.isUpdate;
      addItem(contractDetailModel);
      notifyListeners();
    } else {
      showErrorToast(contractDetailsResponse.messages);
    }
  }

  save(ContractDetailSendParams params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsContractSave, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  ContractDetailSendParams getParams(int action) {
    Contract contract = contractDetailModel.contract;
    if (isNullOrEmpty(codeContractItem.value)) {
      showErrorToast("Chưa điền mã hợp đồng");
      return null;
    }

    if (isNullOrEmpty(pOItem.value)) {
      showErrorToast("Chưa chọn ngày ký HĐ/PO");
      return null;
    }

    if (isNullOrEmpty(theSignerItem.value)) {
      showErrorToast("Chưa điền người ký");
      return null;
    }

    if (isNullOrEmpty(positionItem.value)) {
      showErrorToast("Chưa điền chức vụ");
      return null;
    }

    if (isNullOrEmpty(paymentsItem.value)) {
      showErrorToast("Chưa điền hình thức thanh toán");
      return null;
    }

    if (isNullOrEmpty(contentItem.value)) {
      showErrorToast("Chưa điền nội dung");
      return null;
    }

    if (isNullOrEmpty(contractDetailModel.contract.contractFiles) &&
        action != 1) {
      showErrorToast("Chưa có hợp đồng");
      return null;
    }

    for (Lines line in contractDetailModel.contract.lines) {
      if (getDouble(line.payPercent1) +
              getDouble(line.payPercent2) +
              getDouble(line.payPercent3) !=
          100) {
        showErrorToast(line.product + " tổng 3 lần phải bằng 100");
        return null;
      }
    }

    contract.pONumber = codeContractItem.value;
    contract.signDate = pOItem.value;
    contract.singBy = theSignerItem.value;
    contract.jobPosition = positionItem.value;
    contract.paymentMethod = paymentsItem.value;
    contract.note = contentItem.value;

    ContractDetailSendParams params = ContractDetailSendParams();
    params.contract = contractDetailModel.contract;
    params.pONumber = codeContractItem.value;
    params.signDate = pOItem.value;
    params.signBy = theSignerItem.value;
    params.jobPosition = positionItem.value;
    params.paymentMethod = paymentsItem.value;
    params.note = contentItem.value;
    return params;
  }

  Future<bool> outOfStock(int id) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsContractOutOfStock, {"ID": id});
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  double getDouble(dynamic value) {
    if (isNullOrEmpty(value)) return 0;
    String text = value.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
    return double.parse(text);
  }

  int getInt(dynamic value) {
    if (isNullOrEmpty(value)) return 0;
    String text = value.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
    return int.parse(text);
  }

  Future<List<Info>> loadSignInfo(int id) async {
    var response = await ApiCaller.instance
        .postFormData(AppUrl.qlmsContractSigninInfo, {"ID": id});
    SignInfoResponse signInfoResponse = SignInfoResponse.fromJson(response);
    if (signInfoResponse.isSuccess()) {
      return signInfoResponse.data.info;
    }
    return null;
  }

  updateContractFiles(List<ContractFiles> files) {
    contractDetailModel.contract.contractFiles = files;
    contractItem.value = (files?.length ?? 0).toString();
    notifyListeners();
  }

  updateTotal() {
    double total = 0;
    for (Lines line in contractDetailModel.contract.lines) {
      total += line.amount;
    }
    sumItem.value = getCurrencyFormat(total.toString());
    notifyListeners();
  }

  addItem(ContractDetailModel contractDetailModel) {
    listItem = [];
    List<Lines> listLine = contractDetailModel.contract.lines;
    Contract data = contractDetailModel.contract;
    double sSumAmount = 0;
    if (listLine.length > 0) {
      for (Lines lData in listLine) {
        sSumAmount += lData.amount;
      }
      data.totalAmount = sSumAmount;
    }
    codeRequestItem = new ContentShoppingModel(
        title: "Mã yêu cầu",
        value: data?.requisitionNumber ?? "",
        isNextPage: false);
    typeRecommendedItem = new ContentShoppingModel(
        title: "Loại đề nghị",
        value: data?.suggestionType ?? "",
        isNextPage: false);
    suggestionTypeItem = new ContentShoppingModel(
        title: "Hình thức mua sắm",
        value: data?.shoppingType ?? "",
        isNextPage: false);
    projectItem = new ContentShoppingModel(
        title: "Dự án", value: data?.project ?? "", isNextPage: false);
    codeContractItem = new ContentShoppingModel(
        title: "Mã hợp đồng",
        value: data?.pONumber ?? "",
        isNextPage: isEditting);
    currencyItem = new ContentShoppingModel(
        title: "Tiền tệ", value: data?.currency ?? "", isNextPage: false);
    exchangeRateItem = new ContentShoppingModel(
        title: "Tỉ giá",
        value: getCurrencyFormat(data.rate.toString(), isAllowDot: true),
        isNextPage: false);
    supplierItem = new ContentShoppingModel(
        title: "Nhà cung cấp",
        value: data?.provider ?? "",
        isNextPage: false);
    pOItem = new ContentShoppingModel(
        title: "Ngày ký HĐ/PO:",
        value: data?.signDate ?? "",
        isOnlyDate: true,
        isNextPage: isEditting);
    theSignerItem = new ContentShoppingModel(
        title: "Người ký", value: data?.singBy ?? "", isNextPage: isEditting);
    positionItem = new ContentShoppingModel(
        title: "Chức vụ",
        value: data?.jobPosition ?? "",
        isNextPage: isEditting);
    paymentsItem = new ContentShoppingModel(
        title: "Hình thức thanh toán",
        value: data?.paymentMethod ?? "",
        isNextPage: isEditting);
    contentItem = new ContentShoppingModel(
        title: "Nội dung", value: data?.note ?? "", isNextPage: isEditting);
    signingApprovalItem = new ContentShoppingModel(
        title: SIGNINGAPPROVAL_DETAIL, value: "Chi tiết", isNextPage: true);
    contractItem = new ContentShoppingModel(
        title: CONTRACT_DETAIL,
        value: data?.contractFiles?.length?.toString() ?? "",
        isNextPage: true);
    sumItem = new ContentShoppingModel(
        title: "Tổng cộng",
        value: getCurrencyFormat(data?.totalAmount?.toString() ?? ""),
        isNextPage: false);

    codeContractItem.isRequire = true;
    pOItem.isRequire = isEditting;
    theSignerItem.isRequire = isEditting;
    positionItem.isRequire = isEditting;
    paymentsItem.isRequire = isEditting;
    contentItem.isRequire = isEditting;
    contractItem.isRequire = isEditting;

    listItem.add(codeRequestItem);
    listItem.add(typeRecommendedItem);
    listItem.add(suggestionTypeItem);
    listItem.add(projectItem);
    listItem.add(codeContractItem);
    listItem.add(currencyItem);
    listItem.add(exchangeRateItem);
    listItem.add(supplierItem);
    listItem.add(pOItem);
    listItem.add(theSignerItem);
    listItem.add(positionItem);
    listItem.add(paymentsItem);
    listItem.add(contentItem);
    listItem.add(signingApprovalItem);
    listItem.add(contractItem);
    listItem.add(sumItem);
  }

  toggleEditing() {
    isEditting = !isEditting;
    addItem(contractDetailModel);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
