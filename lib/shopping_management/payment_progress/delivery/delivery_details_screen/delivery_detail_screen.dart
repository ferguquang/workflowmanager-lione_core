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

  final String DELIVERY = "Ng?????i giao";
  final String ACT_ADDRESS = "?????a ??i???m th???c t???";
  final String ACT_CO = "CO th???c t???";
  final String ACT_CQ = "CQ th???c t???";
  final String NOTE_OTHER = "N???i dung ch???ng t??? kh??c";
  final String ACT_CT = "CT th???c t???";
  final String DOCHANDOVER = "B??n giao CT k??? ho???ch";
  final String ACT_DOCHANDOVER = "B??n giao CT th???c t???";
  final String RECEIVER = "Ng?????i nh???n";
  final String NOTE = "Ghi ch??";
  final String HISTORY = "Xem l???ch s??? b??n giao";
  final String DELIVERY_DATE = "Ng??y giao h??ng d??? ki???n";
  final String ACT_DELIVERY_DATE = "Ng??y giao h??ng th???c t???";
  final String PORT_DATE = "Ng??y d??? ki???n h??ng v??? c???ng";
  final String ACT_PORT_DATE = "Ng??y th???c t??? h??ng v??? c???ng";

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
                      ? "C???p nh???t h??ng v??? b??n giao"
                      : "Chi ti???t h??ng v??? b??n giao"),
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
                          SeparatorHeaderWidget("D??? li???u h??ng v??? b??n giao"),
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
                        title: "X??? l??",
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
      if (isComplete) // ho??n th??nh
      {
        String nameLines = data.commodityName;
        if (isNullOrEmpty(nameLines))
          nameLines = "";
        else if (nameLines.length > 25) {
          nameLines = nameLines.substring(0, 25) + "...";
        }
        if (isNullOrEmpty(data.deliver.value)) {
          showErrorToast("Ng?????i giao c???a " + nameLines + " tr???ng");
          return null;
        }

        if (isNullOrEmpty(data.actAddress.value)) {
          showErrorToast("?????a ??i???m th???c t??? c???a " + nameLines + " tr???ng");
          return null;
        }

        if (isNullOrEmpty(data.receiver.value)) {
          showErrorToast("Ng?????i nh???n c???a " + nameLines + " tr???ng");
          return null;
        }
      }

      String iIDLine = data.iD.toString();

      listStringLine.add(iIDLine.toString());

      if (contract.iDShoppingType == 3) // mua s???m ph??n ph???i
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
            _getActionItem("L??u t???m",
                _detailRepository.deliveryDetailModel.contract.isSave == true,
                () async {
              reload(await _detailRepository.save(getParams(false)));
            }),
            _getActionItem(
                "Ho??n th??nh",
                _detailRepository.deliveryDetailModel.contract.isComplete ==
                    true, () async {
              Map<String, dynamic> params = getParams(true);
              if (params != null)
                showConfirmDialog(context,
                    "Sau khi ho??n t???t, b???n s??? kh??ng ???????c c???p nh???t l???i th??ng tin n???a. B???n c?? ch???c ch???n ho??n t???t qu?? tr??nh c???p nh???t ti???n ????? h??ng v??? v?? b??n giao kh??ng?",
                    () async {
                  reload(await _detailRepository.complete(params));
                });
            }),
            Divider(height: 4, thickness: 4),
            _getActionItem("H???y", true, () {
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
                          "Ng??y v??? d??? ki???n: ${replaceDateToMobileFormat(model.importDate.value)}"),
                      Row(
                        children: [
                          Text("L???ch s??? h??ng v???: "),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                "Chi ti???t",
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
        title: "T??n h??ng h??a", value: data.commodityName, isNextPage: false);
    manufactursItem = ContentShoppingModel(
        title: "H??ng", value: data.manufactur, isNextPage: false);
    descriptionItem = ContentShoppingModel(
        title: "M?? t??? h??ng h??a", value: data.description, isNextPage: false);
    qTYItem = ContentShoppingModel(
        title: "S??? l?????ng", value: data.qTY, isNextPage: false);
    unitItem = ContentShoppingModel(
        title: "????n v??? t??nh", value: data.commodityUnit, isNextPage: false);
    totalQTYItem = ContentShoppingModel(
        title: "S??? l?????ng ???? giao", value: data.totalQTY, isNextPage: false);
    remainQTYItem = ContentShoppingModel(
        title: "S??? l?????ng c??n l???i", value: data.remainQTY, isNextPage: false);
    importDateItem = ContentShoppingModel(
        isOnlyDate: true,
        title: "Ng??y v??? d??? ki???n",
        value: replaceDateToMobileFormat(data.importDate.value),
        isNextPage: false);
    actImportDateItem = ContentShoppingModel(
        title: "Ng??y v??? th???c t???",
        isOnlyDate: true,
        value: replaceDateToMobileFormat(data.actImportDate.value),
        isNextPage: false);
    deliverItem = ContentShoppingModel(
        title: DELIVERY, value: data.deliver.value, isNextPage: isCheckUpdate);
    addressItem = ContentShoppingModel(
        title: "?????a ??i???m d??? ki???n",
        value: data.address.value,
        isNextPage: false);
    actAddressItem = ContentShoppingModel(
        title: ACT_ADDRESS,
        value: data.actAddress.value,
        isNextPage: isCheckUpdate);
    checkerItem = ContentShoppingModel(
        title: "K??? thu???t ki???m tra", value: data.checker, isNextPage: false);
    checkDateItem = ContentShoppingModel(
        title: "Ng??y ki???m tra",
        isOnlyDate: true,
        value: replaceDateToMobileFormat(data.checkDate),
        isNextPage: false);
    checkResultItem = ContentShoppingModel(
        title: "K???t lu???n", value: data.checkResult, isNextPage: false);

    cOItem = ContentShoppingModel(
        title: "CO d??? ki???n",
        isNextPage: false,
        isCheckbox: true,
        value: data.cO.value);
    actCOItem = ContentShoppingModel(
        title: ACT_CO,
        isNextPage: isEditting,
        value: data.actCO.value,
        isCheckbox: true);

    cQItem = new ContentShoppingModel(
        title: "CQ d??? ki???n",
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
        title: "CT d??? ki???n",
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
      value: "Chi ti???t",
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
          screenTitle: "Chi ti???t d??? li???u h??ng v??? b??n giao",
          saveTitle: "??p d???ng",
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
