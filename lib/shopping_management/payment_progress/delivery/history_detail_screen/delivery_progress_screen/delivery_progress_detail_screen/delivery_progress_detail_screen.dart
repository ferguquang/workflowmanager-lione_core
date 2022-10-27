import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/commons/separator_header_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/check_slip_detail_screen/check_slip_detail_screen.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/delivery_details_screen/delivery_detail_repository.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_history_detail_screen.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_progress_screen/delivery_progress_detail_screen/delivery_progress_detail_repository.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_progress_screen/delivery_progress_list_screen/delivery_progress_list_screen.dart';
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_list_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_mail_response.dart';

class DeliveryProgressDetailScreen extends StatefulWidget {
  static const int view_type = 0;
  static const int edit_type = 1;
  static const int create_type = 2;
  int viewType;
  int id;
  int sizeCreate;
  List<double> listRemainQTY = [];
  List<double> listTotalQTY = [];

  DeliveryProgressDetailScreen(this.viewType, this.id, this.listRemainQTY,
      this.listTotalQTY, this.sizeCreate);

  @override
  _DeliveryProgressDetailScreenState createState() =>
      _DeliveryProgressDetailScreenState();
}

class _DeliveryProgressDetailScreenState
    extends State<DeliveryProgressDetailScreen> {
  bool isNeedRefreshListScreen = false;
  DeliveryProgressDetailRepository _progressDetailRepository =
      DeliveryProgressDetailRepository();
  int soLuongQTY = 0;
  int conLaiQTY = 0;
  bool isNeedRefreshPreviewScreen = false;
  ContentShoppingModel nameItem,
      numberRequestItem,
      sendNumberItem,
      payNumberItem,
      sumNumbersendItem,
      numberRestItem,
      numberOKItem,
      numberNotItem,
      noteItem,
      statusItem;

  @override
  void initState() {
    super.initState();
    _progressDetailRepository.viewType = widget.viewType;
    _progressDetailRepository.setFixItems(widget.viewType);
    _progressDetailRepository.loadData(
        widget.id, widget.viewType == DeliveryProgressDetailScreen.create_type);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _progressDetailRepository,
      child: Consumer(
        builder: (context,
            DeliveryProgressDetailRepository deliveryProgressDetailRepository,
            child) {
          List<ContentShoppingModel> fixItems =
              deliveryProgressDetailRepository.fixItems;
          List<DetailDeliveries> detailDeliveries =
              deliveryProgressDetailRepository
                  ?.deliveryProgressDetailModel?.detailDeliveries;
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.viewType ==
                        DeliveryProgressDetailScreen.view_type
                    ? "Chi tiết phiếu nhận hàng"
                    : widget.viewType == DeliveryProgressDetailScreen.edit_type
                        ? "Chỉnh sửa phiếu nhận hàng"
                        : "Thêm mới phiếu nhận hàng"),
              ),
              body: WillPopScope(
                onWillPop: () {
                  if (isNeedRefreshListScreen == true) {
                    Navigator.pop(context, true);
                    return Future.value(false);
                  }
                  return Future.value(true);
                },
                child: Column(
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
                                onClick: (model, position) {
                                  if (model.isFullDate == true) {
                                    DateTimePickerWidget(
                                      format: Constant.ddMMyyyyHHmm,
                                      context: context,
                                      onDateTimeSelected: (date) {
                                        model.value = date;
                                        deliveryProgressDetailRepository
                                            .notifyListeners();
                                      },
                                    )..showDateTimePicker();
                                  } else if (model.isDropDown) {
                                    ChoiceDialog choiceDialog = ChoiceDialog(
                                      context,
                                      model.dropDownData,
                                      selectedObject: model.selected,
                                      getTitle: model.getTitle,
                                      hintSearchText: "Tìm kiếm",
                                      isSingleChoice: model.isSingleChoice,
                                      title: model.title,
                                      onAccept: (list) {
                                        model.selected = list;
                                        if (isNotNullOrEmpty(list)) {
                                          if (model.isSingleChoice) {
                                            model.value =
                                                model.getTitle(list[0]);
                                          }
                                          model.idValue = list
                                              .map((e) => "${e.iD}")
                                              .toList()
                                              .toString();
                                        } else {
                                          model.value = "";
                                          model.idValue = "";
                                          model.selected = null;
                                        }
                                        _progressDetailRepository
                                            .notifyListeners();
                                      },
                                    );
                                    choiceDialog.showChoiceDialog();
                                  } else if (model ==
                                      _progressDetailRepository.checkSlip) {
                                    pushPage(context,
                                        CheckSlipDetailScreen(widget.id));
                                  } else {
                                    pushPage(
                                        context,
                                        InputTextWidget(
                                          model: model,
                                          onSendText: (text) {
                                            model.value = text;
                                            deliveryProgressDetailRepository
                                                .notifyListeners();
                                          },
                                        ));
                                  }
                                },
                              );
                            },
                          ),
                          SeparatorHeaderWidget(
                              "Dữ liệu chi tiết phiếu nhận hàng"),
                          ListView.builder(
                            itemCount: detailDeliveries?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              DetailDeliveries detailDelivery =
                                  detailDeliveries[index];
                              return _getLineItem(detailDelivery);
                            },
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.viewType !=
                          DeliveryProgressDetailScreen.view_type,
                      child: SaveButton(
                        title: widget.viewType ==
                                DeliveryProgressDetailScreen.create_type
                            ? "Thêm mới"
                            : "Chỉnh sửa",
                        margin: EdgeInsets.all(16),
                        onTap: showAction,
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }

  String removeSeparateThousand(dynamic text) {
    if (isNullOrEmpty(text)) return "";
    return text.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
  }

  showAction() async {
    if (isNullOrEmpty(_progressDetailRepository.deliveryItem.value)) {
      showErrorToast("Chưa nhập người giao");
      return;
    }

    if (isNullOrEmpty(_progressDetailRepository.receiverItem.value)) {
      showErrorToast("Chưa nhập người nhận");
      return;
    }

    if (isNullOrEmpty(_progressDetailRepository.actDeliveryDateItem.value)) {
      showErrorToast("Chưa nhập ngày giao");
      return;
    }

    Map<String, dynamic> params = Map();
    if (widget.viewType == DeliveryProgressDetailScreen.edit_type) {
      params["ID"] = widget.id;
    } else {
      params["IDContract"] = widget.id;
    }

    params["Deliver"] = _progressDetailRepository.deliveryItem.value;
    params["Receiver"] = _progressDetailRepository.receiverItem.value;
    params["ActDeliveryDate"] = _progressDetailRepository
        .actDeliveryDateItem.value
        ?.replaceAll("/", "-");
    params["Status"] =
        isNullOrEmpty(_progressDetailRepository.statusItem.selected)
            ? -1
            : _progressDetailRepository.statusItem.selected[0].iD;
    if (widget.viewType == DeliveryProgressDetailScreen.edit_type) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Wrap(
            children: [
              _getActionItem(
                  "Gửi mail",
                  _progressDetailRepository
                          .deliveryProgressDetailModel.isSend ==
                      true, () async {
                var result = await sendMail(params);
                if (result == true) {
                  isNeedRefreshListScreen = true;
                  _progressDetailRepository.loadData(
                      widget.id,
                      widget.viewType ==
                          DeliveryProgressDetailScreen.create_type);
                }
              }),
              _getActionItem(
                  "Gửi kỹ thuật bảo hành",
                  _progressDetailRepository
                          .deliveryProgressDetailModel.isSendKtbh ==
                      true, () async {
                var result = await sendWanrranty(params);
                if (result == true) {
                  isNeedRefreshListScreen = true;
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context, true);
                }
              }),
              _getActionItem(
                  "Lưu",
                  _progressDetailRepository
                          .deliveryProgressDetailModel.isSave ==
                      true, () async {
                var resutl = await _progressDetailRepository.save(getEditParams(
                    params,
                    _progressDetailRepository
                        .deliveryProgressDetailModel.detailDeliveries));
                if (resutl == true) {
                  isNeedRefreshListScreen = true;
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context, true);
                }
              }),
              Divider(height: 4, thickness: 4),
              _getActionItem("Hủy", true, () {
                Navigator.pop(context);
              }),
            ],
          );
        },
      );
    } else {
      String sIDCommodity = "",
          sIDContractDetailDelivery = "",
          sQTY = "",
          sDeliveryQTY = "",
          sReturnQTY = "",
          sTotalQTY = "",
          sRemainQTY = "";

      List<int> listIDCommodity = [];
      List<int> listIDContractDetailDelivery = [];
      List<String> listQTY = [];
      List<String> listDeliveryQTY = [];
      List<String> listReturnQTY = [];
      List<String> listTotalQTY = [];
      List<String> listRemainQTY = [];

      for (DetailDeliveries data in _progressDetailRepository
          .deliveryProgressDetailModel.detailDeliveries) {
        listIDCommodity.add(data.iDCommodity);
        listIDContractDetailDelivery.add(data.iDContractDetailDelivery);
        listTotalQTY.add("\"" + data.totalQTY.toString() + "\"");
        listRemainQTY.add("\"" + data.remainQTY.toString() + "\"");
        listQTY.add("\"" + data.qTY.toString() + "\"");
        listDeliveryQTY.add("\"" + data.deliveryQTY.value.toString() + "\"");
        listReturnQTY.add("\"" + data.returnQTY.value.toString() + "\"");
      }

      sIDCommodity = "[" + listIDCommodity.join(",") + "]";
      sIDContractDetailDelivery =
          "[" + listIDContractDetailDelivery.join(",") + "]";
      sQTY = "[" + listQTY.join(",") + "]";
      sTotalQTY = "[" + listTotalQTY.join(",") + "]";
      sRemainQTY = "[" + listRemainQTY.join(",") + "]";
      sReturnQTY = "[" + listReturnQTY.join(",") + "]";
      sDeliveryQTY = "[" + listDeliveryQTY.join(",") + "]";

      params["ReturnQTY"] = sReturnQTY;
      params["IDCommodity"] = sIDCommodity;
      params["IDContractDetailDelivery"] = sIDContractDetailDelivery;
      params["DeliveryQTY"] = sDeliveryQTY;
      params["TotalQTY"] = sTotalQTY;
      params["RemainQTY"] = sRemainQTY;
      params["QTY"] = sQTY;
      var result = await _progressDetailRepository.create(params);
      if (result == true) {
        isNeedRefreshListScreen = true;
        Navigator.pop(context, true);
      }
    }
  }

  sendWanrranty(Map<String, dynamic> params) async {
    List<DetailDeliveries> listNews = [];
    for (DetailDeliveries data in _progressDetailRepository
        .deliveryProgressDetailModel.detailDeliveries) {
      if (data.isCheckList ||
          (data.isChecked && (data.iDStatus == 1 || data.iDStatus == 3))) {
        listNews.add(data);
      }
    }

    if (listNews.length < 1) {
      showErrorToast("Chưa chọn hàng hóa để gửi kỹ thuật bảo hành");
      return;
    }
    var result = await showConfirmDialog(
        context, "Bạn có muốn gửi kỹ thuật bảo hành không?", () async {});
    if (result == true) {
      String sIDCommodity = "",
          sIDContractDetailDelivery = "",
          sQTY = "",
          sDeliveryQTY = "",
          sReturnQTY = "",
          sTotalQTY = "",
          sRemainQTY = "",
          sIDDeliveriesProgressLogDetail = "",
          sNote = "",
          sOkQTY = "",
          sNotOkQTY = "",
          sCheckIndex = "";

      List<String> listIDCommodity = [];
      List<String> listIDContractDetailDelivery = [];
      List<String> listQTY = [];
      List<String> listDeliveryQTY = [];
      List<String> listReturnQTY = [];
      List<String> listTotalQTY = [];
      List<String> listRemainQTY = [];
      List<String> listIDDeliveriesProgressLogDetail = [];
      List<String> listNote = [];
      List<String> listOkQTY = [];
      List<String> listNotOkQTY = [];
      List<String> listCheckIndex = [];

      for (DetailDeliveries data in _progressDetailRepository
          .deliveryProgressDetailModel.detailDeliveries) {
        listIDCommodity.add("\"" + data.iDCommodity.toString() + "\"");
        listIDContractDetailDelivery
            .add("\"" + data.iDContractDetailDelivery.toString() + "\"");
        listTotalQTY.add("\"" + getStringFromDouble(data.totalQTY) + "\"");
        listRemainQTY.add("\"" + getStringFromDouble(data.remainQTY) + "\"");
        listQTY.add("\"" + getStringFromDouble(data.qTY) + "\"");
        listDeliveryQTY
            .add("\"" + getStringFromDouble(data.deliveryQTY.value) + "\"");
        listReturnQTY
            .add("\"" + getStringFromDouble(data.returnQTY.value) + "\"");
        listIDDeliveriesProgressLogDetail
            .add("\"" + data.iDDeliveriesProgressLogDetail.toString() + "\"");
        listNote.add("\"" + (data?.note?.value ?? "") + "\"");
        listOkQTY.add("\"" + getStringFromDouble(data.okQTY.value) + "\"");
        listNotOkQTY
            .add("\"" + getStringFromDouble(data.notOkQTY.value) + "\"");
        listCheckIndex.add(
            (data.isCheckList || data.isChecked) ? ("\"" + "1" + "\"") : "0");
      }

      sIDCommodity = "[" + listIDCommodity.join(",") + "]";
      sIDContractDetailDelivery =
          "[" + listIDContractDetailDelivery.join(",") + "]";
      sQTY = "[" + listQTY.join(",") + "]";
      sTotalQTY = "[" + listTotalQTY.join(",") + "]";
      sRemainQTY = "[" + listRemainQTY.join(",") + "]";
      sReturnQTY = "[" + listReturnQTY.join(",") + "]";
      sIDDeliveriesProgressLogDetail =
          "[" + listIDDeliveriesProgressLogDetail.join(",") + "]";
      sDeliveryQTY = "[" + listDeliveryQTY.join(",") + "]";
      sNote = "[" + listNote.join(",") + "]";
      sOkQTY = "[" + listOkQTY.join(",") + "]";
      sNotOkQTY = "[" + listNotOkQTY.join(",") + "]";
      sCheckIndex = "[" + listCheckIndex.join(",") + "]";

      params["ReturnQTY"] = sReturnQTY;
      params["IDCommodity"] = sIDCommodity;
      params["IDContractDetailDelivery"] = sIDContractDetailDelivery;
      params["DeliveryQTY"] = sDeliveryQTY;
      params["TotalQTY"] = sTotalQTY;
      params["RemainQTY"] = sRemainQTY;
      params["QTY"] = sQTY;
      params["checkIndex"] = sCheckIndex; // nếu check = 1, không Check thì = 0
      params["OkQTY"] = sOkQTY + "";
      params["NotOkQTY"] = sNotOkQTY + "";
      params["Note"] = sNote;
      params["IDDeliveriesProgressLogDetail"] = sIDDeliveriesProgressLogDetail;
      var result = await _progressDetailRepository.sendCheck(params);
      if (result == true) {
        return true;
      }
      return false;
    }
  }

  Future<bool> sendMail(Map<String, dynamic> params) async {
    List<DetailDeliveries> listNews = [];
    for (DetailDeliveries data in _progressDetailRepository
        .deliveryProgressDetailModel.detailDeliveries) {
      if (data.isCheckList && data.iDStatus == 1) {
        listNews.add(data);
      }
    }

    if (listNews.length < 1) {
      showErrorToast("Chưa chọn hàng hóa để gửi mail");
      return false;
    }

    String sIDDeliveriesProgressLogDetail = "";
    List<int> listIDDeliveriesProgressLogDetail = [];

    for (DetailDeliveries data in listNews) {
      listIDDeliveriesProgressLogDetail.add(data.iDDeliveriesProgressLogDetail);
    }

    sIDDeliveriesProgressLogDetail =
        "[" + listIDDeliveriesProgressLogDetail.join(",") + "]";
    DeliveryProgressMailModel mailContent = await _progressDetailRepository
        .getMailInfo(getEditParams(params, listNews));
    if (mailContent != null) {
      List<ContentShoppingModel> listItem = [];
      ContentShoppingModel itemFrom, itemTo, itemCC, itemTitle, itemContent;
      String FROM_SENDMAIL = "From";
      String TO_SENDMAIL = "To";
      String CC_SENDMAIL = "CC";
      String TITLE_SENDMAIL = "Tiêu đề";
      String CONTENT_SENDMAIL = "Nội dung mail";
      itemFrom = ContentShoppingModel(
          title: FROM_SENDMAIL,
          value: mailContent?.fromMail ?? "",
          isNextPage: false);
      itemTo = ContentShoppingModel(
          title: TO_SENDMAIL,
          isRequire: true,
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: mailContent.users,
          getTitle: (data) => "${data.name}(${data.email})",
          isNextPage: true);
      itemCC = ContentShoppingModel(
          title: CC_SENDMAIL,
          isDropDown: true,
          isSingleChoice: false,
          dropDownData: mailContent.users,
          getTitle: (data) => "${data.name}(${data.email})",
          isNextPage: true);
      itemTitle = ContentShoppingModel(
          title: TITLE_SENDMAIL,
          isRequire: true,
          value: mailContent?.subject ?? "",
          isNextPage: true);
      itemContent = ContentShoppingModel(
          title: CONTENT_SENDMAIL,
          isHtml: true,
          value: mailContent?.content ?? "",
          isNextPage: false);
      listItem.add(itemFrom);
      listItem.add(itemTo);
      listItem.add(itemCC);
      listItem.add(itemTitle);
      listItem.add(itemContent);
      var resutl = await pushPage(
          context,
          ListWithArrowScreen(
            data: listItem,
            screenTitle: "Gửi mail",
            saveTitle: "Gửi",
            onSaveButtonTap: () async {
              for (ContentShoppingModel model in listItem) {
                if (model.isRequire == true && isNullOrEmpty(model.value)) {
                  showErrorToast("${model.title} không được để trống");
                  return;
                }
              }
              Map<String, dynamic> paramsSave = Map();
              paramsSave["ProcessID"] = mailContent.processID;
              paramsSave["FromMail"] = mailContent.fromMail;
              paramsSave["ToMail"] = itemTo.selected.first.iD;
              paramsSave["CCMail"] = isNullOrEmpty(itemCC.selected)
                  ? null
                  : itemCC.selected.map((e) => e.iD).toList().join(", ");
              paramsSave["Subject"] = itemTitle.value;
              paramsSave["Content"] = itemContent.value;
              paramsSave["DetailIds"] = sIDDeliveriesProgressLogDetail;
              var result = await _progressDetailRepository.sendMail(paramsSave);
              if (result == true) {
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              }
            },
          ));
      if (resutl == true) return true;
    }

    return false;
  }

  Map<String, dynamic> getEditParams(
      Map<String, dynamic> params, List<DetailDeliveries> listDetails) {
    String sIDCommodity = "",
        sIDContractDetailDelivery = "",
        sQTY = "",
        sDeliveryQTY = "",
        sReturnQTY = "",
        sTotalQTY = "",
        sRemainQTY = "",
        sIDDeliveriesProgressLogDetail = "",
        sNote = "",
        sOkQTY = "",
        sNotOkQTY = "",
        sCheckIndex = "";

    List<String> listIDCommodity = [];
    List<String> listIDContractDetailDelivery = [];
    List<String> listQTY = [];
    List<String> listDeliveryQTY = [];
    List<String> listReturnQTY = [];
    List<String> listTotalQTY = [];
    List<String> listRemainQTY = [];
    List<String> listIDDeliveriesProgressLogDetail = [];
    List<String> listNote = [];
    List<String> listOkQTY = [];
    List<String> listNotOkQTY = [];
    List<String> listCheckIndex = [];

    for (DetailDeliveries data in listDetails) {
      listIDCommodity.add("\"" + data.iDCommodity.toString() + "\"");
      listIDContractDetailDelivery
          .add("\"" + data.iDContractDetailDelivery.toString() + "\"");
      listTotalQTY.add("\"" + data.totalQTY.toString() + "\"");
      listRemainQTY.add("\"" + data.remainQTY.toString() + "\"");
      listQTY.add("\"" + data.qTY.toString() + "\"");
      listDeliveryQTY.add("\"" + data.deliveryQTY.value.toString() + "\"");
      listReturnQTY.add("\"" + data.returnQTY.value.toString() + "\"");
      listIDDeliveriesProgressLogDetail
          .add("\"" + data.iDDeliveriesProgressLogDetail.toString() + "\"");
      listNote.add("\"" + (data?.note?.value ?? "") + "\"");
      listOkQTY.add("\"" + data.okQTY.value.toString() + "\"");
      listNotOkQTY.add("\"" + data.notOkQTY.value.toString() + "\"");
      listCheckIndex.add(
          (data.isCheckList || data.isChecked) ? ("\"" + "1" + "\"") : "0");
    }

    sIDCommodity = "[" + listIDCommodity.join(",") + "]";
    sIDContractDetailDelivery =
        "[" + listIDContractDetailDelivery.join(",") + "]";
    sQTY = "[" + listQTY.join(",") + "]";
    sTotalQTY = "[" + listTotalQTY.join(",") + "]";
    sRemainQTY = "[" + listRemainQTY.join(",") + "]";
    sReturnQTY = "[" + listReturnQTY.join(",") + "]";
    sIDDeliveriesProgressLogDetail =
        "[" + listIDDeliveriesProgressLogDetail.join(",") + "]";
    sDeliveryQTY = "[" + listDeliveryQTY.join(",") + "]";
    sNote = "[" + listNote.join(",") + "]";
    sOkQTY = "[" + listOkQTY.join(",") + "]";
    sNotOkQTY = "[" + listNotOkQTY.join(",") + "]";
    sCheckIndex = "[" + listCheckIndex.join(",") + "]";

    params["ReturnQTY"] = sReturnQTY;
    params["IDCommodity"] = sIDCommodity;
    params["IDContractDetailDelivery"] = sIDContractDetailDelivery;
    params["DeliveryQTY"] = sDeliveryQTY;
    params["TotalQTY"] = sTotalQTY;
    params["RemainQTY"] = sRemainQTY;
    params["QTY"] = sQTY;
    params["checkIndex"] = sCheckIndex; // nếu check = 1, không Check thì = 0
    params["OkQTY"] = sOkQTY;
    params["NotOkQTY"] = sNotOkQTY;
    params["Note"] = sNote;
    params["IDDeliveriesProgressLogDetail"] = sIDDeliveriesProgressLogDetail;

    return params;
  }

  reload(dynamic isNeedReload) {
    Navigator.pop(context);
    if (isNeedReload == true) {
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

  Widget _getLineItem(DetailDeliveries model) {
    return InkWell(
      onTap: () async {
        showItemDetail(model);
      },
      child: Container(
        color: getColor(model.statusDetail.bgColor),
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                if (model.isCheck != true ||
                    widget.viewType == DeliveryProgressDetailScreen.view_type)
                  return;
                if (model.isCheckList == true) {
                  model.isCheckList = false;
                } else {
                  model.isCheckList = true;
                }
                _progressDetailRepository.notifyListeners();
              },
              child: (model?.isCheckList == true) &&
                      widget.viewType != DeliveryProgressDetailScreen.view_type
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: Colors.blue,
                      size: 40,
                    )
                  : Image.asset(
                      "assets/images/icon_shopping_plan_qlms.webp",
                      width: 40,
                      height: 40,
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model?.nameCommodity ?? "",
                    style: TextStyle(color: getColor("#54A4FF"), fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Text("Số lượng yêu cầu: ${model?.qTY?.toInt() ?? ""}"),
                  Visibility(
                      visible: widget.viewType !=
                          DeliveryProgressDetailScreen.create_type,
                      child: Text(
                          "Trạng thái hạng mục: ${model?.statusDetail?.name ?? ""}")),
                ],
              ),
            ),
            RightArrowIcons()
          ],
        ),
      ),
    );
  }

  showItemDetail(DetailDeliveries data) async {
    int soLuongCuaPhieuTruoc = 0;
    int tongSoLuongDaGiao = 0;
    if (widget.viewType != DeliveryProgressDetailScreen.view_type &&
        widget.listRemainQTY.length > 0 &&
        widget.listTotalQTY.length > 0) {
      soLuongCuaPhieuTruoc = widget.listRemainQTY.length;
      tongSoLuongDaGiao = widget.listTotalQTY.length;
    }
    if (widget.viewType == DeliveryProgressDetailScreen.edit_type) {
      if (widget.sizeCreate == 0) // size của danh sách các trạng thái hoàn tất
      {
        if (data.soLanVao == 0) // khi lần đầu tiên vào sẽ lưu lại 2 trường
        {
          data.soLuongQTY = 0;
          data.conLaiQTY = 0;
        }
      } else {
        if (data.soLanVao == 0) {
          data.soLuongQTY = tongSoLuongDaGiao;
          data.conLaiQTY = soLuongCuaPhieuTruoc;
        }
      }
    } else if (widget.viewType == DeliveryProgressDetailScreen.create_type) {
      if (widget.sizeCreate == 0) {
        if (data.soLanVao == 0) {
          data.soLuongQTY = 0;
          data.conLaiQTY = 0;
        }
      } else {
        if (data.soLanVao == 0) {
          data.soLuongQTY = data.totalQTY?.toInt() ?? 0;
          data.conLaiQTY = data.remainQTY?.toInt() ?? 0;
        }
      }
    }

    soLuongQTY = data.soLuongQTY;
    conLaiQTY = data.conLaiQTY;
    bool isCanEdit =
        (widget.viewType != DeliveryProgressDetailScreen.view_type &&
                data.isChecked == false) ||
            widget.viewType == DeliveryProgressDetailScreen.create_type;
    nameItem = ContentShoppingModel(
        title: "Tên hàng hóa",
        value: data?.nameCommodity ?? "",
        isNextPage: false);
    numberRequestItem = ContentShoppingModel(
        title: "Số lượng yêu cầu (1)",
        isNumeric: true,
        value: getStringFromDouble(data.qTY, defaultValue: ""),
        isNextPage: false);
    sendNumberItem = ContentShoppingModel(
        title: "Số lượng giao (2)",
        isNumeric: true,
        value: getStringFromDouble(data?.deliveryQTY?.value, defaultValue: ""),
        isNextPage: isCanEdit && !(data?.deliveryQTY?.isReadOnly ?? false));
    payNumberItem = ContentShoppingModel(
        title: "Số lượng trả (3)",
        isNumeric: true,
        value: getStringFromDouble(data?.returnQTY?.value, defaultValue: ""),
        isNextPage: isCanEdit && !(data?.returnQTY?.isReadOnly ?? false));
    sumNumbersendItem = ContentShoppingModel(
        title: "Tổng số lượng đã giao (4)=(4)+(2)-(3)",
        isNumeric: true,
        value: getStringFromDouble(data?.totalQTY, defaultValue: ""),
        isNextPage: false);
    numberRestItem = ContentShoppingModel(
        title: "Số lượng còn lại (5)=(1)-(4)",
        isNumeric: true,
        value: getStringFromDouble(data?.remainQTY, defaultValue: ""),
        isNextPage: false);
    numberOKItem = ContentShoppingModel(
        title: "Số lượng đạt",
        isNumeric: true,
        value: getStringFromDouble(data?.okQTY?.value, defaultValue: ""),
        isNextPage: isCanEdit && !(data?.okQTY?.isReadOnly ?? false));
    numberNotItem = ContentShoppingModel(
        title: "Số lượng chưa đạt",
        isNumeric: true,
        value: getStringFromDouble(data?.notOkQTY?.value, defaultValue: ""),
        isNextPage: false);
    noteItem = ContentShoppingModel(
        title: "Ghi chú",
        value: data.note.value,
        isNextPage: isCanEdit && !(data?.note?.isReadOnly ?? false));
    statusItem = ContentShoppingModel(
        title: "Trạng thái danh mục",
        value: data?.statusDetail?.name ?? "",
        isNextPage: false);
    List<ContentShoppingModel> listItem = [];
    listItem.add(nameItem);
    listItem.add(numberRequestItem);
    listItem.add(sendNumberItem);
    listItem.add(payNumberItem);
    listItem.add(sumNumbersendItem);
    listItem.add(numberRestItem);
    listItem.add(numberOKItem);
    listItem.add(numberNotItem);
    listItem.add(noteItem);
    listItem.add(statusItem);
    pushPage(
        context,
        ListWithArrowScreen(
          data: listItem,
          screenTitle: "Chi tiết dữ liệu phiếu nhận hàng",
          isShowSaveButton: isCanEdit,
          saveTitle: "Lưu",
          onValueChanged: (model) async {
            _validateInput(model, sendNumberItem, data, payNumberItem,
                sumNumbersendItem, numberRestItem, numberOKItem, numberNotItem);
          },
          onSaveButtonTap: () {
            doneItem(data);
          },
        ));
  }

  doneItem(DetailDeliveries data) {
    if (isNotNullOrEmpty(error)) {
      showErrorToast(error);
      return;
    }
    if (getInt(sendNumberItem.value) > data.qTY.toInt()) {
      showErrorToast("Số lượng giao không được lớn hơn ${data.qTY ?? "0"}");
      return;
    }
    if (getDouble(data.qTY) > data.totalQTY) {
      if (getDouble(sendNumberItem.value) < 0 ||
          getDouble(sendNumberItem.value) > (data.remainQTY ?? 0)) {
        showErrorToast(
            "Số lượng giao không được nhỏ hơn 0 và lớn hơn ${getInt(data.remainQTY.toString()) ?? 0}");
        return;
      }
      if (getDouble(sendNumberItem.value) < getDouble(numberOKItem.value)) {
        showErrorToast(
            "Số lượng giao không được nhỏ hơn 0 và lớn hơn ${getInt(numberOKItem.value)}");
        return;
      }
    } else if (getDouble(data.qTY) == data.totalQTY) {
      if (getDouble(sendNumberItem.value) < 0 ||
          getDouble(sendNumberItem.value) > (data.deliveryQTY.value ?? 0)) {
        showErrorToast(
            "Số lượng giao không được nhỏ hơn 0 và lớn hơn ${getInt(data?.deliveryQTY?.value?.toString())}");
        return;
      }
      if (getDouble(sendNumberItem.value) < getDouble(numberOKItem.value)) {
        showErrorToast(
            "Số lượng giao không được nhỏ hơn ${getInt(numberOKItem.value)}");
        return;
      }
    }
    if (getInt(payNumberItem.value) < 0) {
      showErrorToast("Số lượng trả không được nhỏ hơn 0");
      return;
    }
    if (_progressDetailRepository
                .deliveryProgressDetailModel?.deliveryProgressLog?.status?.iD ==
            4 &&
        getDouble(numberOKItem.value) == 0) {
      showErrorToast("Số lượng đạt không được để trống");
      return;
    }
    if (getDouble(numberOKItem.value) < 0 ||
        getDouble(numberOKItem.value) > (data.deliveryQTY?.value ?? 0)) {
      showErrorToast(
          "Số lượng đạt không được nhỏ hơn 0 và lớn hơn số lương giao ${data.deliveryQTY?.value ?? 0}");
      return;
    }
    data.soLanVao = 1;
    data.deliveryQTY.value = getDouble(sendNumberItem.value);
    data.returnQTY.value = getDouble(payNumberItem.value);
    data.remainQTY = getDouble(numberRestItem.value);
    data.totalQTY = getDouble(sumNumbersendItem.value);
    if (widget.viewType == DeliveryProgressDetailScreen.edit_type) {
      data.note.value = noteItem.value;
      data.okQTY.value = getDouble(numberOKItem.value, orElse: null);
      data.notOkQTY.value = getDouble(numberNotItem.value, orElse: null);
    }
    Navigator.pop(context);
  }

  String error;

  void _validateInput(
      ContentShoppingModel model,
      ContentShoppingModel sendNumberItem,
      DetailDeliveries data,
      ContentShoppingModel payNumberItem,
      ContentShoppingModel sumNumbersendItem,
      ContentShoppingModel numberRestItem,
      ContentShoppingModel numberOKItem,
      ContentShoppingModel numberNotItem) {
    if (model == sendNumberItem) {
      int iSL = 0;
      if (widget.sizeCreate == 0) {
        iSL = data.qTY?.toInt() ?? 0;
      } else {
        iSL = data.remainQTY?.toInt() ?? 0;
      }
      if (isNullOrEmpty(model.value) &&
          _progressDetailRepository
                  .deliveryProgressDetailModel.deliveryProgressLog.status.iD ==
              4) {
        error = "Số lượng được giao không được để trống";
        showErrorToast(error);
      } else if ((int.tryParse(model.value) ?? 0) <= iSL) //validate (2) <= (1)
      {
        int iTongSLDaGiao =
            data.soLuongQTY + getInt(model.value) - getInt(payNumberItem.value);
        sumNumbersendItem.value = iTongSLDaGiao.toString();
        int iSLConLai = (data.qTY?.toInt() ?? 0) - iTongSLDaGiao;
        numberRestItem.value = iSLConLai.toString(); // số lượng còn lại

        if (widget.viewType == DeliveryProgressDetailScreen.edit_type &&
            getInt(numberOKItem.value) > 0) {
          // số lượng chưa đạt = số lượng giao - số lượng đạt
          int iSLDat = getInt(model.value) - getInt(numberOKItem.value);
          numberNotItem.value = iSLDat.toString(); // số lượng chưa đạt
        }
        _progressDetailRepository.notifyListeners();
        error = null;
      } else {
        error = "Số lượng giao không được lớn hơn $iSL";
        showErrorToast(error);
      }
    } else if (model == payNumberItem) {
      if (getInt(model.value) <= getInt(sendNumberItem.value)) {
        payNumberItem.value = payNumberItem.value; // số lượng trả
        int iTongSLDaGiao = data.soLuongQTY +
            getInt(sendNumberItem.value) -
            getInt(model.value);
        sumNumbersendItem.value =
            iTongSLDaGiao.toString(); // tổng số lượng đã giao
        int iSLConLai = data.qTY.toInt() - iTongSLDaGiao;
        numberRestItem.value = iSLConLai.toString(); // số lượng còn lại
        _progressDetailRepository.notifyListeners();
        error = null;
      } else {
        error = "Số lượng trả không được lớn hơn ${payNumberItem.value ?? ""}";
        showErrorToast(error);
      }
    } else if (model == numberOKItem) {
      if (widget.viewType == DeliveryProgressDetailScreen.edit_type) {
        if (getInt(model.value) <=
            getInt(sendNumberItem.value)) // validate số lượng đạt <= (2)
        {
          numberOKItem.value = model.value; // số lượng đạt
          int iSLChuaDat = getInt(sendNumberItem.value) - getInt(model.value);
          numberNotItem.value = (iSLChuaDat.toString()); //số lượng chưa đạt
          _progressDetailRepository.notifyListeners();
          error = null;
        } else {
          error = "Số lượng đạt không được lớn hơn số lượng giao";
          showErrorToast(error);
        }
      }
    }
  }

  int getInt(String number) {
    if (isNullOrEmpty(number)) return 0;
    return double.tryParse(number)?.toInt() ?? 0;
  }

  String getStringFromDouble(double number, {String defaultValue: "0"}) {
    if (number == null) return defaultValue;
    return number.toInt().toString();
  }

  showDetailHistory(int id) {
    pushPage(context, DeliveryHistoryDetailScreen(id));
  }
}
