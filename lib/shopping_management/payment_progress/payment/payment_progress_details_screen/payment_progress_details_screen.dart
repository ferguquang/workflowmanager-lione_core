import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/commons/separator_header_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/delivery_details_screen/delivery_detail_repository.dart';
import 'package:workflow_manager/shopping_management/payment_progress/payment/payment_progress_list_screen/payment_progress_list_repository.dart';
import 'package:workflow_manager/shopping_management/response/payment_progress_detail_response.dart';

import 'payment_progress_details_repository.dart';

class PaymentProgressDetailScreen extends StatefulWidget {
  bool isUpdate;
  int id;

  PaymentProgressDetailScreen(this.isUpdate, this.id);

  @override
  _PaymentProgressDetailScreenState createState() =>
      _PaymentProgressDetailScreenState();
}

class _PaymentProgressDetailScreenState
    extends State<PaymentProgressDetailScreen> {
  bool isNeedRefreshListScreen = false;
  ProgressPaymentDetailRepository _progressPaymentDetailRepository =
      ProgressPaymentDetailRepository();
  bool isEditting = false;
  ContentShoppingModel amount1,
      amount2,
      amount3,
      actPay1,
      actPay2,
      actPay3,
      totalActAmount,
      totalDept,
      payActDate1,
      payActDate2,
      payActDate3;

  @override
  void initState() {
    super.initState();
    _progressPaymentDetailRepository.setFixItems();
    _progressPaymentDetailRepository.loadData(widget.id, isEditting);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _progressPaymentDetailRepository,
      child: Consumer(
        builder: (context,
            ProgressPaymentDetailRepository progressPaymentDetailRepository,
            child) {
          List<ContentShoppingModel> fixItems =
              progressPaymentDetailRepository.fixItems;
          List<ContractDetails> lines = progressPaymentDetailRepository
              ?.paymentProgressDetailModel?.contractDetails;
          return WillPopScope(
            onWillPop: () {
              if (isEditting) {
                isEditting = false;
                for (int i = 0;
                    i <
                            _progressPaymentDetailRepository
                                ?.paymentProgressDetailModel
                                ?.contractDetails
                                ?.length ??
                        0;
                    i++) {
                  _progressPaymentDetailRepository.backup[i].copyTo(
                      _progressPaymentDetailRepository
                          ?.paymentProgressDetailModel?.contractDetails[i]);
                }
                _updateTotal();
                _progressPaymentDetailRepository.notifyListeners();
                return Future.value(false);
              }
              if (isNeedRefreshListScreen) {
                Navigator.pop(context, true);
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text(isEditting
                      ? "Cập nhật tiến độ thanh toán"
                      : "Chi tiết tiến độ thanh toán"),
                  actions: [
                    Visibility(
                      visible: widget.isUpdate && !isEditting,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          isEditting = true;
                          _progressPaymentDetailRepository.loadData(
                              widget.id, isEditting);
                        },
                      ),
                    )
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          ListView.builder(
                            itemCount: fixItems?.length ?? 0,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              ContentShoppingModel model = fixItems[index];
                              return ContentViewShoppingItem(
                                  model: model,
                                  position: index,
                                  onClick: (model, position) {});
                            },
                          ),
                          SeparatorHeaderWidget("Dữ liệu tiến độ thanh toán"),
                          ListView.builder(
                            itemCount: lines?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ContractDetails line = lines[index];
                              return _getLineItem(line);
                            },
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.isUpdate &&
                          isEditting &&
                          (_progressPaymentDetailRepository
                                  .paymentProgressDetailModel.isSave ||
                              _progressPaymentDetailRepository
                                  .paymentProgressDetailModel.isComplete),
                      child: SaveButton(
                        title: "Xử lý",
                        margin: EdgeInsets.all(16),
                        onTap: showAction,
                      ),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  String removeSeparateThousand(dynamic text) {
    if (isNullOrEmpty(text)) return "";
    return text.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
  }

  Map<String, dynamic> getParams(bool isComplete) {
    Map<String, dynamic> params = Map();
    params["ID"] = widget.id;
    List<String> contractDetailIDs = [];
    List<String> paymentAct1s = [];
    List<String> paymentActDate1s = [];
    List<String> paymentAct2s = [];
    List<String> paymentActDate2s = [];
    List<String> paymentAct3s = [];
    List<String> paymentActDate3s = [];
    List<ContractDetails> lineList = _progressPaymentDetailRepository
        .paymentProgressDetailModel.contractDetails;
    String sendContractDetailID = "",
        sendPaymentAct1 = "",
        sendPaymentActDate1 = "",
        sendPaymentAct2 = "",
        sendPaymentActDate2 = "",
        sendPaymentAct3 = "",
        sendPaymentActDate3 = "";
    for (int i = 0; i < lineList.length; i++) {
      if (isComplete) {
        String pay1String = lineList[i].payActAmount1?.toString();
        double pay1 = 0;
        if (isNotNullOrEmpty(pay1String)) {
          pay1 = getDouble(lineList[i].payActAmount1);
        }

        double pay2 = getDouble(lineList[i].payActAmount2);
        double pay3 = getDouble(lineList[i].payActAmount3);

        if (lineList[i].isRequiredPay1 && pay1 == 0) {
          showErrorToast("Vui lòng nhập Lần 1 Thanh toán thực tế của: " +
              lineList[i].commodity);
          return null;
        }
        if (lineList[i].isRequiredPay2 && pay2 == 0) {
          showErrorToast("Vui lòng nhập Lần 2 Thanh toán thực tế của: " +
              lineList[i].commodity);
          return null;
        }

        if (lineList[i].isRequiredPay3 && pay3 == 0) {
          showErrorToast("Vui lòng nhập Lần 3 Thanh toán thực tế của: " +
              lineList[i].commodity);
          return null;
        }

        int payDate1 = lineList[i].payDate1;
        int payDate2 = lineList[i].payDate2;
        int payDate3 = lineList[i].payDate3;

        if (payDate1 != 0 && lineList[i].payActDate1 == 0) {
          showErrorToast("Vui lòng nhập Lần 1 Ngày thực tế thanh toán của: " +
              lineList[i].commodity);
          return null;
        }
        if (payDate2 != 0 && lineList[i].payActDate2 == 0) {
          showErrorToast("Vui lòng nhập Lần 2 Ngày thực tế thanh toán của: " +
              lineList[i].commodity);
          return null;
        }
        if (payDate3 != 0 && lineList[i].payActDate3 == 0) {
          showErrorToast("Vui lòng nhập Lần 3 Ngày thực tế thanh toán của: " +
              lineList[i].commodity);
          return null;
        }
      }

      String contractDetailID = lineList[i].iD.toString();
      contractDetailIDs.add(contractDetailID);

      String paymentAct1 = getDouble(lineList[i].payActAmount1).toString();
      paymentAct1s.add("\"" + paymentAct1 + "\"");
      String payActDate1 = convertTimeStampToHumanDate(
              lineList[i].payActDate1, Constant.ddMMyyyy)
          ?.replaceAll("/", "-");
      paymentActDate1s.add("\"" + payActDate1 + "\"");

      String paymentAct2 = getDouble(lineList[i].payActAmount2).toString();
      paymentAct2s.add("\"" + paymentAct2 + "\"");
      String payActDate2 = convertTimeStampToHumanDate(
              lineList[i].payActDate2, Constant.ddMMyyyy)
          ?.replaceAll("/", "-");
      paymentActDate2s.add("\"" + payActDate2 + "\"");

      String paymentAct3 = getDouble(lineList[i].payActAmount3).toString();
      paymentAct3s.add("\"" + paymentAct3 + "\"");
      String payActDate3 = convertTimeStampToHumanDate(
              lineList[i].payActDate3, Constant.ddMMyyyy)
          ?.replaceAll("/", "-");
      paymentActDate3s.add("\"" + payActDate3 + "\"");
    }

    sendContractDetailID = "[" + contractDetailIDs.join(", ") + "]";
    sendPaymentAct1 = "[" + paymentAct1s.join(", ") + "]";
    sendPaymentActDate1 = "[" + paymentActDate1s.join(", ") + "]";
    sendPaymentAct2 = "[" + paymentAct2s.join(", ") + "]";
    sendPaymentActDate2 = "[" + paymentActDate2s.join(", ") + "]";
    sendPaymentAct3 = "[" + paymentAct3s.join(", ") + "]";
    sendPaymentActDate3 = "[" + paymentActDate3s.join(", ") + "]";

    params["ContractDetailID"] = sendContractDetailID;
    params["PaymentAct1"] = sendPaymentAct1;
    params["PaymentActDate1"] = sendPaymentActDate1;
    params["PaymentAct2"] = sendPaymentAct2;
    params["PaymentActDate2"] = sendPaymentActDate2;
    params["PaymentAct3"] = sendPaymentAct3;
    params["PaymentActDate3"] = sendPaymentActDate3;
    return params;
  }

  showAction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            _getActionItem(
                "Lưu tạm",
                _progressPaymentDetailRepository
                        .paymentProgressDetailModel.isSave ==
                    true, () async {
              reload(await _progressPaymentDetailRepository
                  .save(getParams(false)));
            }),
            _getActionItem(
                "Hoàn thành",
                _progressPaymentDetailRepository
                        .paymentProgressDetailModel.isComplete ==
                    true, () async {
              Map<String, dynamic> params = getParams(true);
              if (params != null)
                showConfirmDialog(context,
                    "Sau khi hoàn tất, bạn sẽ không được cập nhật lại thông tin nữa. Bạn có chắc chắn hoàn tất quá trình cập nhật tiến độ thanh toán không?",
                    () async {
                  reload(
                      await _progressPaymentDetailRepository.completed(params));
                });
            }),
            Divider(height: 4, thickness: 4),
            _getActionItem("Hủy", true, () {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }

  reload(dynamic isNeedReload) {
    Navigator.pop(context);
    if (isNeedReload == true) {
      isEditting = false;
      _progressPaymentDetailRepository.loadData(widget.id, false);
      isNeedRefreshListScreen = true;
    }
  }

  Widget _getActionItem(
      String text, bool isVisibility, GestureTapCallback onTap) {
    return Visibility(
      visible: isVisibility,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _getLineItem(ContractDetails model) {
    return InkWell(
      onTap: () async {
        showItemDetail(model);
      },
      child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/icon_shopping_plan_qlms.webp",
                  width: 40,
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model?.commodity ?? "",
                        style:
                            TextStyle(color: getColor("#54A0F5"), fontSize: 18),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Text(
                          "Thành tiền: ${getCurrencyFormat(model?.amount?.toString()) ?? ""}"),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Text("Nợ nhà cung cấp: ${model.totalDebt ?? ""}"),
                    ],
                  ),
                ),
                RightArrowIcons()
              ],
            ),
          ),
          secondaryActions: []),
    );
  }

  showItemDetail(ContractDetails model) async {
    List<ContentShoppingModel> listData = [];
    final String TEN_HH = "Tên hàng hóa";
    final String HANG = "Hãng";
    final String THANH_TIEN = "Thành tiền";

    final String LAN_1_TI_LE = "Lần 1 tỷ lệ (%)";
    final String THANHTIEN_1 = "Thành tiền (lần 1)";
    final String TT_THUCTE_1 = "Thanh toán thực tế (lần 1)";
    final String NGAY_DENGHI_TT_1 = "Ngày đề nghị thanh toán (lần 1)";
    final String NGAY_THUCTE_TT_1 = "Ngày thực tế thanh toán (lần 1)";

    final String LAN_2_TI_LE = "Lần 2 tỷ lệ (%)";
    final String THANHTIEN_2 = "Thành tiền (lần 2)";
    final String TT_THUCTE_2 = "Thanh toán thực tế (lần 2)";
    final String NGAY_DENGHI_TT_2 = "Ngày đề nghị thanh toán (lần 2)";
    final String NGAY_THUCTE_TT_2 = "Ngày thực tế thanh toán (lần 2)";

    final String LAN_3_TI_LE = "Lần 3 tỷ lệ (%)";
    final String THANHTIEN_3 = "Thành tiền (lần 3)";
    final String TT_THUCTE_3 = "Thanh toán thực tế (lần 3)";
    final String NGAY_DENGHI_TT_3 = "Ngày đề nghị thanh toán (lần 3)";
    final String NGAY_THUCTE_TT_3 = "Ngày thực tế thanh toán (lần 3)";

    final String TONG_TT_THUCTE = "Tổng thanh toán thực tế";
    final String NO_NCC = "Nợ nhà cung cấp";

    listData.add(ContentShoppingModel(
        title: TEN_HH, value: model?.commodity ?? "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: HANG, value: model?.manufactur ?? "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: THANH_TIEN,
        value: model?.amountString ?? "",
        isNextPage: false));

    listData.add(ContentShoppingModel(
        title: LAN_1_TI_LE,
        value: getInt(model?.payPercent1 ?? ""),
        isNextPage: false));
    amount1 = ContentShoppingModel(
        title: THANHTIEN_1,
        value: model?.payAmount1?.toString() ?? "",
        isNextPage: false);
    listData.add(amount1);
    actPay1 = ContentShoppingModel(
        title: TT_THUCTE_1,
        isRequire: model.isRequiredPay1,
        isMoney: true,
        isNumeric: true,
        value: getCurrencyFormat(model?.payActAmount1?.toString() ?? ""),
        isNextPage: isEditting);
    listData.add(actPay1);
    listData.add(ContentShoppingModel(
        title: NGAY_DENGHI_TT_1,
        value: convertTimeStampToHumanDate(model.payDate1, Constant.ddMMyyyy),
        isNextPage: false));
    payActDate1 = ContentShoppingModel(
        title: NGAY_THUCTE_TT_1,
        isOnlyDate: true,
        value:
            convertTimeStampToHumanDate(model.payActDate1, Constant.ddMMyyyy),
        isNextPage: isEditting);
    listData.add(payActDate1);

    listData.add(ContentShoppingModel(
        title: LAN_2_TI_LE,
        value: getInt(model.payPercent2 ?? ""),
        isNextPage: false));
    amount2 = ContentShoppingModel(
        title: THANHTIEN_2,
        value: model?.payAmount2?.toString() ?? "",
        isNextPage: false);
    listData.add(amount2);

    actPay2 = ContentShoppingModel(
        isRequire: model.isRequiredPay2,
        title: TT_THUCTE_2,
        isMoney: true,
        isNumeric: true,
        value: getCurrencyFormat(model?.payActAmount2?.toString() ?? ""),
        isNextPage: isEditting);
    listData.add(actPay2);
    listData.add(ContentShoppingModel(
        title: NGAY_DENGHI_TT_2,
        value: convertTimeStampToHumanDate(model.payDate2, Constant.ddMMyyyy),
        isNextPage: false));
    payActDate2 = ContentShoppingModel(
        title: NGAY_THUCTE_TT_2,
        isOnlyDate: true,
        value:
            convertTimeStampToHumanDate(model.payActDate2, Constant.ddMMyyyy),
        isNextPage: isEditting);
    listData.add(payActDate2);

    listData.add(ContentShoppingModel(
        title: LAN_3_TI_LE,
        value: getInt(model.payPercent3 ?? ""),
        isNextPage: false));
    amount3 = ContentShoppingModel(
        title: THANHTIEN_3,
        value: model?.payAmount3?.toString() ?? "",
        isNextPage: false);
    listData.add(amount3);

    actPay3 = ContentShoppingModel(
        isRequire: model.isRequiredPay3,
        title: TT_THUCTE_3,
        isNumeric: true,
        isMoney: true,
        value: getCurrencyFormat(model?.payActAmount3?.toString() ?? ""),
        isNextPage: isEditting);
    listData.add(actPay3);
    listData.add(ContentShoppingModel(
        title: NGAY_DENGHI_TT_3,
        value: convertTimeStampToHumanDate(model.payDate3, Constant.ddMMyyyy),
        isNextPage: false));
    payActDate3 = ContentShoppingModel(
        title: NGAY_THUCTE_TT_3,
        isOnlyDate: true,
        value:
            convertTimeStampToHumanDate(model.payActDate3, Constant.ddMMyyyy),
        isNextPage: isEditting);
    listData.add(payActDate3);
    totalActAmount = ContentShoppingModel(
        title: TONG_TT_THUCTE,
        value: getCurrencyFormat(model.totalActAmount?.toString()),
        isNextPage: false);
    listData.add(totalActAmount);
    totalDept = ContentShoppingModel(
        title: NO_NCC,
        value: getCurrencyFormat(model.totalDebt?.toString()),
        isNextPage: false);
    listData.add(totalDept);
    pushPage(
        context,
        ListWithArrowScreen(
          data: listData,
          screenTitle: "Chi tiết dữ liệu tiến độ thanh toán",
          saveTitle: "Lưu",
          isShowSaveButton: isEditting,
          onSaveButtonTap: () {
            model.payActAmount1 = getDouble(actPay1.value);
            model.payActAmount2 = getDouble(actPay2.value);
            model.payActAmount3 = getDouble(actPay3.value);

            model.totalActAmount = getDouble(totalActAmount.value);
            model.totalDebt = totalDept.value;
            model.payActDate1 = isNullOrEmpty(payActDate1.value)
                ? null
                : getDateTimeObject(payActDate1.value).millisecondsSinceEpoch;
            model.payActDate2 = isNullOrEmpty(payActDate2.value)
                ? null
                : getDateTimeObject(payActDate2.value).millisecondsSinceEpoch;
            model.payActDate3 = isNullOrEmpty(payActDate3.value)
                ? null
                : getDateTimeObject(payActDate3.value).millisecondsSinceEpoch;
            _updateTotal();
            Navigator.pop(context);
          },
          onValueChanged: (model) async {
            if ([actPay1, actPay2, actPay3].contains(model)) {
              updateItem();
            }
          },
        ));
  }

  _updateTotal() {
    String currency = " VND";
    double actAmount1 = 0, actAmount2 = 0, actAmount3 = 0;
    for (ContractDetails contractDetails in _progressPaymentDetailRepository
        .paymentProgressDetailModel.contractDetails) {
      actAmount1 += contractDetails.payActAmount1 ?? 0;
      actAmount2 += contractDetails.payActAmount2 ?? 0;
      actAmount3 += contractDetails.payActAmount3 ?? 0;
    }
    _progressPaymentDetailRepository.payAmount1.value =
        getCurrencyFormat(actAmount1.toString()) + currency;
    _progressPaymentDetailRepository.payAmount2.value =
        getCurrencyFormat(actAmount2.toString()) + currency;
    _progressPaymentDetailRepository.payAmount3.value =
        getCurrencyFormat(actAmount3.toString()) + currency;
    _progressPaymentDetailRepository.totalDept.value = getCurrencyFormat(
            (getDouble(_progressPaymentDetailRepository
                        .paymentProgressDetailModel.contract.totalAmount
                        .split(" ")[0]) -
                    actAmount1 -
                    actAmount2 -
                    actAmount3)
                .toString()) +
        currency;
    _progressPaymentDetailRepository.notifyListeners();
  }

  updateItem() {
    double actPayTotal = getDouble(actPay1.value) +
        getDouble(actPay2.value) +
        getDouble(actPay3.value);
    double totalAmount = getDouble(amount1.value) +
        getDouble(amount2.value) +
        getDouble(amount3.value);
    totalActAmount.value = getCurrencyFormat(actPayTotal.toString());
    totalDept.value = getCurrencyFormat((totalAmount -
            (getDouble(actPay1.value) +
                getDouble(actPay2.value) +
                getDouble(actPay3.value)))
        .toString());
  }
}
