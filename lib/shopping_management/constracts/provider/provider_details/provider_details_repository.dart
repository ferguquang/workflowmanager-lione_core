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
import 'package:workflow_manager/shopping_management/request/provider_details_params.dart';
import 'package:workflow_manager/shopping_management/response/choose_provider_response.dart';
import 'package:workflow_manager/shopping_management/response/create_content_mail.dart';
import 'package:workflow_manager/shopping_management/response/exhange_rate_response.dart';
import 'package:workflow_manager/shopping_management/response/provider_detail_response.dart';
import 'package:workflow_manager/base/extension/int.dart';

class ProviderDetailRepository extends ChangeNotifier {
  ProviderDetail providerDetail;
  List<ContentShoppingModel> listData = [];
  List<LineChooseProviderDetail> lineList = [];
  int idDetail;
  bool isSave;
  bool isSend;
  bool isMua;
  bool isShowDoneButton = false;
  bool isBrowser;
  bool isLuuTrongKhaoGiaNCC;
  List<ExchangeRateModel> exchangeRates = [];
  int providerId;

  loadData(bool isBrowser) async {
    this.isBrowser = isBrowser;
    ProviderDetailsParams params = ProviderDetailsParams();
    params.id = providerId;
    String api = isBrowser
        ? AppUrl.qlmsConfirmProviderDetail
        : AppUrl.qlmsChooseProviderDetail;
    var response =
        await ApiCaller.instance.postFormData(api, params.getParams());
    ProviderDetailResponse providerDetailResponse =
        ProviderDetailResponse.fromJson(response);
    if (providerDetailResponse.status == 1) {
      providerDetail = providerDetailResponse.data;
      updateValue(false);
      await _loadExchangeRate();
      notifyListeners();
    } else {
      showErrorToast(providerDetailResponse.messages);
    }
  }

  Future<bool> approve() async {
    ProviderDetailsApproveParams params = ProviderDetailsApproveParams();
    params.id = providerId;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.qlmsConfirmProviderApproval, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  Future<bool> reject(String reason) async {
    ProviderDetailsRejectParams params = ProviderDetailsRejectParams();
    params.id = providerId;
    params.reason = reason;
    var response = await ApiCaller.instance
        .postFormData(AppUrl.qlmsConfirmProviderReject, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    return baseResponse.isSuccess();
  }

  Future<bool> sendApprove(ProviderSendApproveParams params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsChooseProviderSendMail, params.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    if (baseResponse.status == 1) {
      showSuccessToast(baseResponse.messages);
      return true;
    }
    showErrorToast(baseResponse.messages);
    return false;
  }

  Future<CreateContentMailModel> getContentMailModel(
      int id, Map<String, dynamic> params) async {
    var json = await ApiCaller.instance
        .postFormData(AppUrl.qlmsChooseProviderCreateContentMail, {"ID": id});
    CreateContentMailResponse response =
        CreateContentMailResponse.fromJson(json);
    if (response.status == 1) {
      return response.data;
    } else {
      bool isSuccess = await save(params);
      if (isSuccess) {
        var json = await ApiCaller.instance.postFormData(
            AppUrl.qlmsChooseProviderCreateContentMail, {"ID": id});
        CreateContentMailResponse response =
            CreateContentMailResponse.fromJson(json);
        if (response.status == 1) {
          return response.data;
        } else {
          showErrorToast(response.messages);
        }
      }
    }
    // showErrorToast(response.messages);
    return null;
  }

  Future<bool> save(Map<String, dynamic> params) async {
    var response = await ApiCaller.instance
        .postFormData(AppUrl.qlmsChooseProviderSave, params);
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    return baseResponse.isSuccess(isShowSuccessMessage: true);
  }

  _loadExchangeRate() async {
    var response =
        await ApiCaller.instance.postFormData(AppUrl.qlmsTyGia, Map());
    ExchangeRateResponse exchangeRateResponse =
        ExchangeRateResponse.fromJson(response);
    if (exchangeRateResponse.status == 1) {
      exchangeRates = exchangeRateResponse.data.tyGia;
    } else {
      showErrorToast(exchangeRateResponse.messages);
    }
  }

  updateValue(bool isNotify) {
    Requisition model = providerDetail.requisition;
    listData[0].value = model.requisitionNumber;
    listData[1].value = model.suggestionType;
    listData[2].value = model.shoppingType;
    listData[3].value = model.purpose;
    listData[4].value = model.requestBy;
    listData[5].value = model.dept.name;
    listData[6].value = model.requestDate.toInt().toDate(Constant.ddMMyyyy);
    listData[7].value = model.project;
    listData[8].value = model.investor;
    listData[9].value = model.currencyCode;
    listData[9].isRequire = true;
    listData[9].isNextPage = !isBrowser && !model.disableFiels.currencyCode;

    listData[10].value = model.currencyRate.toString();
    listData[10].isNextPage = !isBrowser && !model.disableFiels.currencyRate;
    listData[10].isRequire = true;
    listData[11].value = model.receptionDate == 0
        ? ""
        : model.receptionDate.toInt().toDate(Constant.ddMMyyyy);
    listData[12].value = model.changeProviderDate == 0
        ? ""
        : model?.changeProviderDate?.toInt()?.toDate(Constant.ddMMyyyy) ?? "";
    listData[13].value = model.status;
    listData[14].value = model.processingDay.toString();
    listData[14].isRequire = true;
    listData[14].isNextPage = !isBrowser && !model.disableFiels.processingDay;

    lineList = model.lines;
    idDetail = model.iD;
    isSave = model.isSave;
    isSend = model.isSend;

    // isReject = model.isReject;
    // isApprove = model.;

    isMua = model.suggestionType == "Mua";

    if (isNullOrEmpty(model.totalAmount)) {
      listData[15].value = "";
    } else {
      for (int i = 0; i < lineList.length; i++) {
        double priceByProvider = 1;
        if (isNullOrEmpty(lineList[i].priceByProvider)) {
          priceByProvider = 0;
        } else {
          priceByProvider = lineList[i].priceByProvider;
        }
        double qty = lineList[i].qTY;

        if (isMua) {
          String calculate = priceByProvider.toString() + "*" + qty.toString();
          lineList[i].total = calcString(calculate);
        } else {
          double nbRent = lineList[i].nbRent.toDouble();
          String calculate = priceByProvider.toString() +
              "*" +
              qty.toString() +
              "*" +
              nbRent.toString();
          lineList[i].total = calcString(calculate);
        }
      }

      listData[15].value = sumTotal();
    }

    if (model.status.toLowerCase() == "Chờ duyệt".toLowerCase() ||
        model.status.toLowerCase() == "Đã duyệt".toLowerCase()) {
      isLuuTrongKhaoGiaNCC = true;
    }

    if (isBrowser) {
      isShowDoneButton = true;
    } else {
      isShowDoneButton = model.isSave; //|| model.is ? View.VISIBLE : View.GONE;
    }
    if (isNotify) notifyListeners();
  }

  String sumTotal() {
    StringBuffer sb = StringBuffer();
    for (LineChooseProviderDetail line in lineList) {
      if (isNotNullOrEmpty(line.total)) {
        sb..write(line.total)..write("+");
      }
    }
    String calc = sb.toString();
    if (calc.length > 0) {
      calc = calc.substring(0, calc.length - 1);
      return getCurrencyFormat(calcString(calc));
    }
    return "";
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
