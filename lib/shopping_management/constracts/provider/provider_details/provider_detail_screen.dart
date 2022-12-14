import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/commons/separator_header_widget.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/choose_shopping_screen/choose_shopping_screen.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/price_prefer/price_prefer_screen.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/provider_details/provider_details_repository.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/provider_details_params.dart';
import 'package:workflow_manager/shopping_management/response/create_content_mail.dart';
import 'package:workflow_manager/shopping_management/response/exhange_rate_response.dart';
import 'package:workflow_manager/shopping_management/response/price_prefer_response.dart';
import 'package:workflow_manager/shopping_management/response/provider_detail_response.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

class ProviderDetailScreen extends StatefulWidget {
  bool isBrowser;
  int providerId;

  ProviderDetailScreen(this.isBrowser, this.providerId);

  @override
  _ProviderDetailScreenState createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  ProviderDetailRepository _providerDetailRepository =
      ProviderDetailRepository();
  final String MA_YEUCAU = "M?? y??u c???u";
  final String LOAI_DENGHI = "Lo???i ????? ngh???";
  final String HINHTHUC_MUASAM = "H??nh th???c mua s???m";
  final String MUC_DICH = "M???c ????ch";
  final String NGUOI_DENGHI = "Ng?????i ????? ngh???";
  final String BOPHAN_DENGHI = "B??? ph???n ????? ngh???";
  final String NGAY_YEUCAU = "Ng??y y??u c???u";
  final String DU_AN = "D??? ??n";
  final String CHU_DAUTU = "Ch??? ?????u t??";
  final String TIEN_TE = "Ti???n t???";
  final String TI_GIA = "T??? gi??";
  final String THOIGIAN_TIEPNHAN = "Th???i gian ti???p nh???n";
  final String THOI_GIAN_DOI_NCC = "Ng??y thay ?????i NCC";
  final String TRANG_THAI = "Tr???ng th??i";
  final String THOIGIAN_XULY = "Th???i gian x??? l?? (Ng??y)";
  final String TONG_CONG = "T???ng c???ng";
  bool isNeddReload = false;
  TextEditingController _rejectControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    _providerDetailRepository.providerId = widget.providerId;
    _providerDetailRepository.loadData(widget.isBrowser);
    addItem();
  }

  void addItem() {
    var listData = _providerDetailRepository.listData;
    listData.clear();
    listData.add(
        ContentShoppingModel(title: MA_YEUCAU, value: "", isNextPage: false));
    listData.add(
        ContentShoppingModel(title: LOAI_DENGHI, value: "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: HINHTHUC_MUASAM, value: "", isNextPage: false));
    listData.add(
        ContentShoppingModel(title: MUC_DICH, value: "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: NGUOI_DENGHI, value: "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: BOPHAN_DENGHI, value: "", isNextPage: false));
    listData.add(
        ContentShoppingModel(title: NGAY_YEUCAU, value: "", isNextPage: false));
    listData
        .add(ContentShoppingModel(title: DU_AN, value: "", isNextPage: false));
    listData.add(
        ContentShoppingModel(title: CHU_DAUTU, value: "", isNextPage: false));
    listData.add(
        ContentShoppingModel(title: TIEN_TE, value: "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: TI_GIA,
        value: "",
        isNextPage: false,
        isMoney: true,
        isDecimal: true));
    listData.add(ContentShoppingModel(
        title: THOIGIAN_TIEPNHAN, value: "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: THOI_GIAN_DOI_NCC, value: "", isNextPage: false));
    listData.add(
        ContentShoppingModel(title: TRANG_THAI, value: "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: THOIGIAN_XULY, value: "", isNextPage: false));
    listData.add(
        ContentShoppingModel(title: TONG_CONG, value: "", isNextPage: false));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, isNeddReload);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.isBrowser
                ? "Chi ti???t duy???t l???a ch???n nh?? cung c???p"
                : "Chi ti???t l???a ch???n nh?? cung c???p"),
          ),
          body: ChangeNotifierProvider.value(
            value: _providerDetailRepository,
            child: Consumer(
              builder: (context,
                  ProviderDetailRepository providerDetailRepository, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            _providerDetailRepository?.listData?.length ?? 0,
                        itemBuilder: (context, index) {
                          return ContentViewShoppingItem(
                            model: _providerDetailRepository?.listData
                                ?.elementAt(index),
                            onClick: (model, position) {
                              if (model.isNextPage == false) return;
                              if (index == 9) {
                                ChoiceDialog<ExchangeRateModel>(
                                  context,
                                  _providerDetailRepository.exchangeRates,
                                  selectedObject: _providerDetailRepository
                                      .exchangeRates
                                      .where((element) =>
                                          element.currencyCode ==
                                          _providerDetailRepository.listData
                                              .elementAt(9)
                                              .value)
                                      .toList(),
                                  isSingleChoice: true,
                                  title: model.title,
                                  hintSearchText: "T??m ki???m",
                                  getTitle: (data) => data.currencyCode,
                                  onAccept: (data) {
                                    _providerDetailRepository.listData
                                        .elementAt(9)
                                        .value = data[0].currencyCode;
                                    _providerDetailRepository.listData
                                        .elementAt(10)
                                        .value = data[0].sell;
                                    setState(() {});
                                  },
                                ).showChoiceDialog();
                              } else {
                                pushPage(
                                    context,
                                    InputTextWidget(
                                      title: model.title,
                                      isNumberic: index == 14,
                                      content: model.value,
                                      model: model,
                                      onSendText: (text) {
                                        model.value = text;
                                        setState(() {});
                                      },
                                    ));
                              }
                            },
                          );
                        },
                      ),
                      SeparatorHeaderWidget(widget.isBrowser
                          ? "Chi ti???t d??? li???u duy???t l???a ch???n nh?? cung c???p"
                          : "D??? li???u l???a ch???n nh?? cung c???p"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            _providerDetailRepository?.lineList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return _getLineItem(_providerDetailRepository
                              ?.lineList
                              ?.elementAt(index));
                        },
                      ),
                      Visibility(
                        visible: (!widget.isBrowser &&
                                (_providerDetailRepository
                                        ?.providerDetail?.requisition?.isSave ??
                                    false ||
                                        (_providerDetailRepository
                                                ?.providerDetail
                                                ?.requisition
                                                ?.isReject ??
                                            false))) ||
                            (widget.isBrowser &&
                                ((_providerDetailRepository?.providerDetail
                                            ?.requisition?.isSave ??
                                        false) ||
                                    (_providerDetailRepository?.providerDetail
                                            ?.requisition?.isApprove ??
                                        false))),
                        child: SaveButton(
                          title: "X??? l??",
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          onTap: done,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      )
                    ],
                  ),
                );
              },
            ),
          )),
    );
  }

  done() {
    Map<String, dynamic> params = Map();
    params["ID"] = widget.providerId;
    params["CurrencyCode"] =
        _providerDetailRepository?.listData?.elementAt(9)?.value ?? "";
    params["CurrencyRate"] =
        _providerDetailRepository?.listData?.elementAt(10)?.value;
    params["ProcessingDay"] =
        _providerDetailRepository?.listData?.elementAt(14)?.value;
    params["TotalAmount"] =
        _providerDetailRepository?.listData?.elementAt(15)?.value;

    List<String> lineIDList = [];
    List<LineChooseProviderDetail> lineList =
        _providerDetailRepository.lineList;
    for (int i = 0; i < lineList.length; i++) {
      int idLineHang = lineList[i].iD;
      lineIDList.add(idLineHang.toString());

      params["${idLineHang}_ProviderID"] = lineList[i].providerID;
      params["${idLineHang}_PriceByProvider"] = lineList[i].priceByProvider;
    }

    String sendLineID = "[${lineIDList.join(", ")}]";
    params["LineID"] = sendLineID;
    _showActions(params);
  }

  _showActions(Map<String, dynamic> params) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            _getActionItem(
                "Duy???t",
                widget.isBrowser &&
                    _providerDetailRepository
                        .providerDetail.requisition.isApprove, () async {
              showConfirmDialog(
                  context, "B???n c?? mu???n duy???t nh?? cung c???p n??y kh??ng?",
                  () async {
                reload(await _providerDetailRepository.approve());
              });
            }),
            _getActionItem(
                "T??? ch???i",
                widget.isBrowser &&
                    _providerDetailRepository
                        .providerDetail.requisition.isReject, () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          children: [
                            TitleDialog("L?? do"),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  TextFormField(
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(0),
                                        hintText: "Nh???p l?? do t??? ch???i"),
                                    controller: _rejectControler,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SaveButton(
                                            color: Colors.red.withAlpha(170),
                                            title: "H???y",
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            margin: EdgeInsets.all(8)),
                                      ),
                                      Expanded(
                                        child: SaveButton(
                                          title: "X??c nh???n",
                                          onTap: () async {
                                            if (isNullOrEmpty(
                                                    _rejectControler.text) ||
                                                isNullOrEmpty(_rejectControler
                                                    .text
                                                    .trim())) {
                                              showErrorToast(
                                                  "B???n ch??a nh???p l?? do t??? ch???i");
                                              return;
                                            }
                                            Navigator.pop(context);
                                            reload(
                                                await _providerDetailRepository
                                                    .reject(
                                                        _rejectControler.text));
                                          },
                                          margin: EdgeInsets.all(8),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
              _rejectControler.text = "";
            }),
            _getActionItem(
                "G???i duy???t",
                !widget.isBrowser &&
                    _providerDetailRepository.providerDetail.requisition.isSend,
                () async {
              reload(await send(params));
            }),
            _getActionItem(
                "L??u t???m",
                !widget.isBrowser &&
                    _providerDetailRepository.providerDetail.requisition.isSave,
                () async {
              reload(await _providerDetailRepository.save(params));
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

  Future<bool> send(Map<String, dynamic> params) async {
    final String FROM = "From";
    final String TO = "To";
    final String CC = "CC";
    final String TIEU_DE = "Ti??u ?????";
    final String NOIDUNG_MAIL = "N???i dung mail";
    CreateContentMailModel result = await _providerDetailRepository
        .getContentMailModel(widget.providerId, params);
    if (result != null) {
      List<ContentShoppingModel> data = [];
      ContentShoppingModel from = ContentShoppingModel(
          title: FROM, value: result.fromMail, isNextPage: true);
      data.add(from);
      ContentShoppingModel to = ContentShoppingModel(
        title: TO,
        value: "",
        isNextPage: true,
        isDropDown: true,
        dropDownData: result.user,
        getTitle: (data) => "${data.name} (${data.email})",
      );
      data.add(to);
      ContentShoppingModel cc = ContentShoppingModel(
          title: CC,
          value: "",
          isNextPage: true,
          isDropDown: true,
          dropDownData: result.user,
          getTitle: (data) => "${data.name} (${data.email})",
          isSingleChoice: false);
      data.add(cc);
      ContentShoppingModel title = ContentShoppingModel(
          title: TIEU_DE, value: result.subject, isNextPage: true);
      data.add(title);
      ContentShoppingModel content = ContentShoppingModel(
          title: NOIDUNG_MAIL, value: result.content, isNextPage: true);
      data.add(content);
      bool isSuccess = await pushPage(
          context,
          ListWithArrowScreen(
            screenTitle: "G???i duy???t".toUpperCase(),
            data: data,
            isShowSaveButton: true,
            saveTitle: "G???I",
            onSaveButtonTap: () async {
              for (ContentShoppingModel model in data) {
                if (isNullOrEmpty(model.value) && model.title != CC) {
                  showErrorToast("Tr?????ng ${model.title} kh??ng ???????c ????? tr???ng");
                  return;
                }
              }
              ProviderSendApproveParams params = ProviderSendApproveParams();
              params.content = content.value;
              params.subject = title.value;
              if (isNotNullOrEmpty(cc.selected)) {
                params.cCMail = cc.selected.map((e) => e.iD).toList().join(",");
              }
              params.toMail = to.selected[0].iD;
              params.iDRecord = widget.providerId;
              bool isSuccess =
                  await _providerDetailRepository.sendApprove(params);
              if (isSuccess) {
                Navigator.pop(context, true);
              }
            },
          ));
      if (isSuccess == true) {
        return true;
      }
    }
    return false;
  }

  reload(bool isNeedReload) {
    Navigator.pop(context);
    if (isNeedReload) _providerDetailRepository.loadData(widget.isBrowser);
    this.isNeddReload = isNeedReload;
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

  Widget _getLineItem(LineChooseProviderDetail model) {
    return InkWell(
      onTap: () async {
        await pushPage(
            context,
            ChooseShoppingScreen(
                widget.isBrowser,
                model,
                ["ch??? duy???t", "???? duy???t"].contains(_providerDetailRepository
                    .providerDetail.requisition.status
                    .toLowerCase()),
                widget.providerId,
                _providerDetailRepository.providerDetail.requisition));
        _providerDetailRepository.updateValue(true);
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Image.asset(
                "assets/images/icon_statistic.webp",
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
                      model?.product ?? "",
                      style:
                          TextStyle(color: getColor("#54A0F5"), fontSize: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                    ),
                    Text("S??? l?????ng duy???t mua: ${(model?.qTY?.toInt() ?? "")}"),
                    Text("Nh?? cung c???p: ${(model?.provider ?? "")}"),
                  ],
                ),
              ),
              RightArrowIcons()
            ],
          ),
        ),
        secondaryActions: model.isHidden
            ? []
            : [
                IconSlideAction(
                  caption: "Xem kh???o gi??",
                  color: getColor("#54A0F5"),
                  iconWidget: Container(
                    height: 0,
                    width: 0,
                  ),
                  onTap: () async {
                    // /model.iD, model.product, widget.isBrowser,
                    //                         widget.isDontSave, widget.providerId, model
                    var isSuccess = await pushPage(
                        context,
                        PricePreferScreen(
                            model.iD,
                            model.product,
                            widget.isBrowser,
                            ["ch??? duy???t", "???? duy???t"].contains(
                                _providerDetailRepository
                                    .providerDetail.requisition.status
                                    .toLowerCase()),
                            widget.providerId,
                            model));
                    if (isSuccess == true) {
                      _providerDetailRepository.updateValue(true);
                    }
                  },
                ),
              ],
      ),
    );
  }
}
