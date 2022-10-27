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
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_history_detail_screen.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_progress_screen/delivery_progress_list_screen/delivery_progress_list_screen.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/handover_history_screen/handover_history_screen.dart';
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';

class DeliveryDetailScreen extends StatefulWidget {
  bool isUpdate;
  int id;

  DeliveryDetailScreen(this.isUpdate, this.id);

  @override
  _DeliveryDetailScreenState createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  bool isNeedRefreshListScreen = false;
  DeliveryDetailRepository _detailRepository = DeliveryDetailRepository();
  bool isEditting = false;

  final String DELIVERY = "Người giao";
  final String ACT_ADDRESS = "Địa điểm thực tế";
  final String ACT_CO = "CO thực tế";
  final String ACT_CQ = "CQ thực tế";
  final String NOTE_OTHER = "Nội dung chứng từ khác";
  final String ACT_CT = "CT thực tế";
  final String DOCHANDOVER = "Bàn giao CT kế hoạch";
  final String ACT_DOCHANDOVER = "Bàn giao CT thực tế";
  final String RECEIVER = "Người nhận";
  final String NOTE = "Ghi chú";
  final String HISTORY = "Xem lịch sử bàn giao";
  final String DELIVERY_DATE = "Ngày giao hàng dự kiến";
  final String ACT_DELIVERY_DATE = "Ngày giao hàng thực tế";
  final String PORT_DATE = "Ngày dự kiến hàng về cảng";
  final String ACT_PORT_DATE = "Ngày thực tế hàng về cảng";

  ContentShoppingModel nameItem,
      manufactursItem,
      descriptionItem,
      qTYItem,
      unitItem,
      totalQTYItem,
      remainQTYItem,
      importDateItem,
      actImportDateItem,
      deliverItem,
      addressItem,
      actAddressItem,
      checkerItem,
      checkDateItem,
      checkResultItem,
      cOItem,
      actCOItem,
      cQItem,
      actCQItem,
      otherNoteItem,
      cTItem,
      actCTItem,
      docHandoverItem,
      actDocHandoverItem,
      receiverItem,
      noteItem,
      historyItem;

  @override
  void initState() {
    super.initState();
    _detailRepository.setFixItems();
    _detailRepository.getViewInfo(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _detailRepository,
      child: Consumer(
        builder: (context, DeliveryDetailRepository deliveryDetailRepository,
            child) {
          List<ContentShoppingModel> fixItems =
              deliveryDetailRepository.fixItems;
          List<Lines> lines =
              deliveryDetailRepository?.deliveryDetailModel?.lines;
          return WillPopScope(
            onWillPop: () {
              if (isEditting) {
                isEditting = false;
                _detailRepository.notifyListeners();
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
                      ? "Cập nhật hàng về bàn giao"
                      : "Chi tiết hàng về bàn giao"),
                  actions: [
                    Visibility(
                      visible: widget.isUpdate &&
                          !isEditting &&
                          (_detailRepository?.deliveryDetailModel?.contract
                                      ?.isComplete !=
                                  false &&
                              _detailRepository
                                      ?.deliveryDetailModel?.contract?.isSave !=
                                  false),
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          isEditting = true;
                          _detailRepository.getUpdateInfo(widget.id);
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
                                onClick: (model, position) async {
                                  if (model ==
                                      _detailRepository.signingApprovalItem) {
                                    var result = await pushPage(
                                        context,
                                        DeliveryProgressListScreen(
                                            widget.id, isEditting));
                                    if (result == true) {
                                      _detailRepository.getViewInfo(widget.id);
                                    }
                                  }
                                },
                              );
                            },
                          ),
                          SeparatorHeaderWidget("Dữ liệu hàng về bàn giao"),
                          ListView.builder(
                            itemCount: lines?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Lines line = lines[index];
                              return _getLineItem(line);
                            },
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.isUpdate &&
                          isEditting &&
                          (_detailRepository
                                      ?.deliveryDetailModel?.contract?.isSave ==
                                  true ||
                              _detailRepository?.deliveryDetailModel?.contract
                                      ?.isComplete ==
                                  true),
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
    Contract contract = _detailRepository.deliveryDetailModel.contract;
    Map<String, dynamic> params = Map();
    String sListLine = "";
    List<String> listStringLine = [];
    var lineList = _detailRepository.deliveryDetailModel.lines;
    for (Lines data in lineList) {
      if (isComplete) // hoàn thành
      {
        String nameLines = data.commodityName;
        if (isNullOrEmpty(nameLines))
          nameLines = "";
        else if (nameLines.length > 25) {
          nameLines = nameLines.substring(0, 25) + "...";
        }
        if (isNullOrEmpty(data.deliver.value)) {
          showErrorToast("Người giao của " + nameLines + " trống");
          return null;
        }

        if (isNullOrEmpty(data.actAddress.value)) {
          showErrorToast("Địa điểm thực tế của " + nameLines + " trống");
          return null;
        }

        if (isNullOrEmpty(data.receiver.value)) {
          showErrorToast("Người nhận của " + nameLines + " trống");
          return null;
        }
      }

      String iIDLine = data.iD.toString();

      listStringLine.add(iIDLine.toString());

      if (contract.iDShoppingType == 3) // mua sắm phân phối
      {
        params[iIDLine + "_DeliveryDate"] = data.deliveryDate.value;
        params[iIDLine + "_ActDeliveryDate"] = data.actDeliveryDate.value;
        params[iIDLine + "_ActPortDate"] = data.actPortDate.value;
        params[iIDLine + "_PortDate"] = data.portDate.value;
      }

      params[iIDLine + "_Deliver"] = data.deliver.value;
      params[iIDLine + "_ActAddress"] = data.actAddress.value;
      params[iIDLine + "_ActCO"] = data.actCO.value;
      params[iIDLine + "_ActCQ"] = data.actCQ.value;
      params[iIDLine + "_OtherNote"] = data.otherNote.value;
      params[iIDLine + "_ActOther"] = data.actOther.value;
      params[iIDLine + "_DocHandover"] = data.docHandover.value;
      params[iIDLine + "_ActDocHandover"] = data.actDocHandover.value;
      params[iIDLine + "_Receiver"] = data.receiver.value;
      params[iIDLine + "_Note"] = data.note.value;
    }

    sListLine = "[" + listStringLine.join(",") + "]";

    params["ID"] = contract.iD;
    params["LineID"] = sListLine;
    return params;
  }

  showAction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            _getActionItem("Lưu tạm",
                _detailRepository.deliveryDetailModel.contract.isSave == true,
                () async {
              reload(await _detailRepository.save(getParams(false)));
            }),
            _getActionItem(
                "Hoàn thành",
                _detailRepository.deliveryDetailModel.contract.isComplete ==
                    true, () async {
              Map<String, dynamic> params = getParams(true);
              if (params != null)
                showConfirmDialog(context,
                    "Sau khi hoàn tất, bạn sẽ không được cập nhật lại thông tin nữa. Bạn có chắc chắn hoàn tất quá trình cập nhật tiến độ hàng về và bàn giao không?",
                    () async {
                  reload(await _detailRepository.complete(params));
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
      _detailRepository.getUpdateInfo(widget.id);
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

  Widget _getLineItem(Lines model) {
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
                        model?.commodityName ?? "",
                        style:
                            TextStyle(color: getColor("#54A0F5"), fontSize: 18),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Text(
                          "Ngày về dự kiến: ${replaceDateToMobileFormat(model.importDate.value)}"),
                      Row(
                        children: [
                          Text("Lịch sử hàng về: "),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                "Chi tiết",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            onTap: () {
                              showDetailHistory(model.iD);
                            },
                          ),
                        ],
                      ),
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

  showItemDetail(Lines data) async {
    List<ContentShoppingModel> itemList = [];
    bool isCheckUpdate = isEditting;
    nameItem = ContentShoppingModel(
        title: "Tên hàng hóa", value: data.commodityName, isNextPage: false);
    manufactursItem = ContentShoppingModel(
        title: "Hãng", value: data.manufactur, isNextPage: false);
    descriptionItem = ContentShoppingModel(
        title: "Mô tả hàng hóa", value: data.description, isNextPage: false);
    qTYItem = ContentShoppingModel(
        title: "Số lượng", value: data.qTY, isNextPage: false);
    unitItem = ContentShoppingModel(
        title: "Đơn vị tính", value: data.commodityUnit, isNextPage: false);
    totalQTYItem = ContentShoppingModel(
        title: "Số lượng đã giao", value: data.totalQTY, isNextPage: false);
    remainQTYItem = ContentShoppingModel(
        title: "Số lượng còn lại", value: data.remainQTY, isNextPage: false);
    importDateItem = ContentShoppingModel(
        isOnlyDate: true,
        title: "Ngày về dự kiến",
        value: replaceDateToMobileFormat(data.importDate.value),
        isNextPage: false);
    actImportDateItem = ContentShoppingModel(
        title: "Ngày về thực tế",
        isOnlyDate: true,
        value: replaceDateToMobileFormat(data.actImportDate.value),
        isNextPage: false);
    deliverItem = ContentShoppingModel(
        title: DELIVERY, value: data.deliver.value, isNextPage: isCheckUpdate);
    addressItem = ContentShoppingModel(
        title: "Địa điểm dự kiến",
        value: data.address.value,
        isNextPage: false);
    actAddressItem = ContentShoppingModel(
        title: ACT_ADDRESS,
        value: data.actAddress.value,
        isNextPage: isCheckUpdate);
    checkerItem = ContentShoppingModel(
        title: "Kỹ thuật kiểm tra", value: data.checker, isNextPage: false);
    checkDateItem = ContentShoppingModel(
        title: "Ngày kiểm tra",
        isOnlyDate: true,
        value: replaceDateToMobileFormat(data.checkDate),
        isNextPage: false);
    checkResultItem = ContentShoppingModel(
        title: "Kết luận", value: data.checkResult, isNextPage: false);

    cOItem = ContentShoppingModel(
        title: "CO dự kiến",
        isNextPage: false,
        isCheckbox: true,
        value: data.cO.value);
    actCOItem = ContentShoppingModel(
        title: ACT_CO,
        isNextPage: isEditting,
        value: data.actCO.value,
        isCheckbox: true);

    cQItem = new ContentShoppingModel(
        title: "CQ dự kiến",
        isNextPage: false,
        value: data.cQ.value,
        isCheckbox: true);
    actCQItem = ContentShoppingModel(
        title: ACT_CQ,
        isNextPage: isEditting,
        value: data.actCQ.value,
        isCheckbox: true);
    otherNoteItem = ContentShoppingModel(
        title: NOTE_OTHER,
        value: data.otherNote.value,
        isNextPage: isCheckUpdate);

    cTItem = new ContentShoppingModel(
        title: "CT dự kiến",
        isNextPage: false,
        value: data.other.value,
        isCheckbox: true);
    actCTItem = ContentShoppingModel(
        title: ACT_CT,
        isNextPage: isEditting,
        value: data.actOther.value,
        isCheckbox: true);
    docHandoverItem = ContentShoppingModel(
        title: DOCHANDOVER,
        value: data.docHandover.value,
        isNextPage: isCheckUpdate);
    actDocHandoverItem = ContentShoppingModel(
        title: ACT_DOCHANDOVER,
        value: data.actDocHandover.value,
        isNextPage: isCheckUpdate);
    receiverItem = ContentShoppingModel(
        title: RECEIVER,
        value: replaceDateToMobileFormat(data.receiver.value),
        isNextPage: isCheckUpdate);
    noteItem = ContentShoppingModel(
        title: NOTE, value: data.note.value, isNextPage: isCheckUpdate);
    historyItem = ContentShoppingModel(
      title: HISTORY,
      value: "Chi tiết",
      isNextPage: true,
      onTap: (model) {
        pushPage(context, HandoverHistoryScreen(data.iD));
      },
    );

    deliverItem.isRequire = true;
    actAddressItem.isRequire = true;
    receiverItem.isRequire = true;

    itemList.add(nameItem);
    itemList.add(manufactursItem);
    itemList.add(descriptionItem);
    itemList.add(qTYItem);
    itemList.add(unitItem);
    itemList.add(totalQTYItem);
    itemList.add(remainQTYItem);
    if (_detailRepository.deliveryDetailModel.contract.iDShoppingType == 3) {
      ContentShoppingModel deliveryDateItem = new ContentShoppingModel(
          title: DELIVERY_DATE,
          isOnlyDate: true,
          value: replaceDateToMobileFormat(data.deliveryDate?.value ?? ""),
          isNextPage: isCheckUpdate);
      ContentShoppingModel actDeliveryDateItem = new ContentShoppingModel(
          title: ACT_DELIVERY_DATE,
          isOnlyDate: true,
          value: replaceDateToMobileFormat(data.actDeliveryDate?.value ?? ""),
          isNextPage: isCheckUpdate);
      ContentShoppingModel portDateItem = new ContentShoppingModel(
          isOnlyDate: true,
          title: PORT_DATE,
          value: replaceDateToMobileFormat(data.portDate?.value ?? ""),
          isNextPage: isCheckUpdate);
      ContentShoppingModel actPortDateItem = new ContentShoppingModel(
          isOnlyDate: true,
          title: ACT_PORT_DATE,
          value: replaceDateToMobileFormat(data.actPortDate?.value ?? ""),
          isNextPage: isCheckUpdate);

      itemList.add(deliveryDateItem);
      itemList.add(actDeliveryDateItem);
      itemList.add(portDateItem);
      itemList.add(actPortDateItem);
    }

    itemList.add(importDateItem);
    itemList.add(actImportDateItem);
    itemList.add(deliverItem);
    itemList.add(addressItem);
    itemList.add(actAddressItem);
    itemList.add(checkerItem);
    itemList.add(checkDateItem);
    itemList.add(checkResultItem);
    itemList.add(cOItem);
    itemList.add(actCOItem);
    itemList.add(cQItem);
    itemList.add(actCQItem);
    itemList.add(otherNoteItem);
    itemList.add(cTItem);
    itemList.add(actCTItem);
    itemList.add(docHandoverItem);
    itemList.add(actDocHandoverItem);
    itemList.add(receiverItem);
    itemList.add(noteItem);
    itemList.add(historyItem);
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: itemList,
          screenTitle: "Chi tiết dữ liệu hàng về bàn giao",
          saveTitle: "Áp dụng",
          isShowSaveButton: isEditting,
        ));
    if (result != null) {
      data.deliver.value = deliverItem.value;
      data.actAddress.value = actAddressItem.value;
      data.actCO.value = actCOItem.value;
      data.actCQ.value = actCQItem.value;
      data.actOther.value = actCTItem.value;
      data.docHandover.value = docHandoverItem.value;
      data.actDocHandover.value = actDocHandoverItem.value;
      data.receiver.value = receiverItem.value;
      data.note.value = noteItem.value;
      data.otherNote.value = otherNoteItem.value;
    }
    _detailRepository.notifyListeners();
  }

  showDetailHistory(int id) {
    pushPage(context, DeliveryHistoryDetailScreen(id));
  }
}
