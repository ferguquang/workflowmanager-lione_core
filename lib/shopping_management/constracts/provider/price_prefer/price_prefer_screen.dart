import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/commons/separator_header_widget.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/add_provider_screen/add_provider_screen.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/price_prefer/price_prefer_repository.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/suggesst_provider_screen/suggest_provider_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/price_prefer_params.dart';
import 'package:workflow_manager/shopping_management/response/provider_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/search_provider_reponse.dart';
import 'package:workflow_manager/shopping_management/response/price_prefer_response.dart';

class PricePreferScreen extends StatefulWidget {
  bool isBrowse;
  int id;
  String title;
  bool isDontSave;
  int providerId;
  LineChooseProviderDetail itemModel;

  PricePreferScreen(this.id, this.title, this.isBrowse, this.isDontSave,
      this.providerId, this.itemModel);

  @override
  _PricePreferScreenState createState() => _PricePreferScreenState();
}

class _PricePreferScreenState extends State<PricePreferScreen> {
  PricePreferRepository _pricePreferRepository = PricePreferRepository();
  List<ContentShoppingModel> fixModels = [];
  PriceRefers selected;
  bool isDontSetSelected = false;

  @override
  void initState() {
    super.initState();
    _createFixModels();
    _pricePreferRepository.loadData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kh???o gi?? nh?? cung c???p"),
      ),
      body: provider.ChangeNotifierProvider.value(
        value: _pricePreferRepository,
        child: provider.Consumer(
          builder:
              (context, PricePreferRepository pricePreferRepository, child) {
            if (selected == null &&
                !isDontSetSelected &&
                isNotNullOrEmpty(
                    _pricePreferRepository?.pricePreferModels?.priceRefers)) {
              for (PriceRefers model
                  in _pricePreferRepository.pricePreferModels.priceRefers) {
                if (model.priceRefer.provider.iD ==
                    widget.itemModel.providerID) {
                  selected = model;
                  break;
                }
              }
            }
            _createFixModels();
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: fixModels.length,
                  itemBuilder: (context, index) {
                    return ContentViewShoppingItem(
                      model: fixModels[index],
                      onClick: (model, position) async {
                        if (position == 2) {
                          Providers _providerSelected = await pushPage(
                              context,
                              AddProviderScreen(
                                  widget.providerId,
                                  _pricePreferRepository
                                      .pricePreferModels.priceRefers
                                      .map((e) => e.priceRefer.provider.iD)
                                      .toList()));
                          if (_providerSelected != null) {
                            PriceRefers provider = PriceRefers();
                            provider.priceRefer.provider.iD =
                                _providerSelected.iD;
                            provider.priceRefer.provider.name =
                                _providerSelected.name;
                            provider.priceRefer.provider.code =
                                _providerSelected.code;
                            _pricePreferRepository.pricePreferModels.priceRefers
                                .add(provider);
                            _pricePreferRepository.notifyListeners();
                          }
                        } else if (position == 3) {
                          List<PriceRefers> list = await pushPage(
                              context,
                              SuggestProviderScreen(
                                  _pricePreferRepository
                                      .pricePreferModels.priceRefers
                                      .map((e) {
                                    return e.priceRefer.provider;
                                  }).toList(),
                                  widget.itemModel.iDCategory));
                          if (isNotNullOrEmpty(list)) {
                            _pricePreferRepository.add(list);
                          }
                        }
                      },
                      position: index,
                    );
                  },
                ),
                SeparatorHeaderWidget("D??? li???u nh?? cung c???p"),
                Expanded(
                  child: ListView.builder(
                    itemCount: _pricePreferRepository
                            ?.pricePreferModels?.priceRefers?.length ??
                        0,
                    itemBuilder: (context, index) {
                      PriceRefers model = _pricePreferRepository
                          .pricePreferModels.priceRefers[index];
                      return InkWell(
                        onTap: () {
                          showDetails(model);
                        },
                        child: getItem(model, index),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: !widget.isBrowse &&
                      !(_pricePreferRepository?.pricePreferModels?.isHidden ??
                          true),
                  child: SaveButton(
                    title: "L??u",
                    margin: EdgeInsets.all(16),
                    onTap: done,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getItem(PriceRefers model, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (widget.isBrowse ||
                        _pricePreferRepository.pricePreferModels.isHidden ==
                            true) return;
                    if (selected == model) {
                      selected = null;
                      isDontSetSelected = true;
                    } else
                      selected = model;
                    _pricePreferRepository.notifyListeners();
                  },
                  child: model == selected
                      ? Icon(
                          Icons.check_circle,
                          color: getColor("#82D000"),
                          size: 30,
                        )
                      : Image.asset(
                          "assets/images/icon_statistic.webp",
                          width: 30,
                          height: 30,
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
                        model.priceRefer.provider.name,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      Text("M?? NCC: ${model.priceRefer.provider.code ?? ""}"),
                      Text(
                          "??i???m ????nh gi??: ${model.priceRefer.costLog.point ?? ""}"),
                    ],
                  ),
                ),
                RightArrowIcons()
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          )
        ],
      ),
      secondaryActions: widget.isBrowse
          ? []
          : [
              IconSlideAction(
                caption: "X??a",
                color: Colors.red,
                iconWidget: Container(
                  height: 0,
                  width: 0,
                ),
                onTap: () async {
                  showConfirmDialog(
                      context, "B???n c?? mu???n x??a nh?? cung c???p n??y?", () {
                    _pricePreferRepository.pricePreferModels.priceRefers
                        .removeAt(index);
                    _pricePreferRepository.notifyListeners();
                  });
                },
              ),
            ],
    );
  }

  done() async {
    List<String> listIDProvider = [];
    List<String> listPoint = [];
    List<String> listWarranty = [];
    List<String> listDeliveryTime = [];
    List<String> listPaymentTerm = [];
    List<String> listQuality = [];
    List<String> listPrice = [];
    List<PriceRefers> dataList =
        _pricePreferRepository.pricePreferModels.priceRefers;
    PricePreferParams params = _pricePreferRepository.params;
    if (selected != null) {
      int idProviderSelected = selected.priceRefer.provider.iD;
      params.idProviderSelected = idProviderSelected.toString();
    } else {
      showErrorToast("Vui l??ng ch???n nh?? cung c???p c???n kh???o gi??");
    }
    for (int i = 0; i < dataList.length; i++) {
      double price = dataList[i].priceRefer.costLog.price;
      if (price == null || price == 0) {
        showErrorToast("Vui l??ng nh???p gi?? c???a nh?? cung c???p: " +
            dataList[i].priceRefer.provider.name);
        return;
      }
    }

    for (int i = 0; i < dataList.length; i++) {
      listIDProvider.add(
          "\"" + (dataList[i].priceRefer.provider.iD?.toString() ?? "") + "\"");
      listPoint.add("\"" +
          (dataList[i].priceRefer.costLog.point?.toString() ?? "") +
          "\"");
      listWarranty
          .add("\"" + (dataList[i].priceRefer.costLog.quality ?? "") + "\"");
      listDeliveryTime.add(
          "\"" + (dataList[i].priceRefer.costLog.deliveryTime ?? "") + "\"");
      listPaymentTerm.add(
          "\"" + (dataList[i].priceRefer.costLog.paymentTerm ?? "") + "\"");
      listQuality
          .add("\"" + (dataList[i].priceRefer.costLog.quality ?? "") + "\"");
      listPrice.add("\"" +
          (dataList[i].priceRefer.costLog.price?.toInt()?.toString() ?? "") +
          "\"");
    }

    params.idProvider = "[" + listIDProvider.join(",") + "]";
    params.point = "[" + listPoint.join(",") + "]";
    params.warranty = "[" + listWarranty.join(",") + "]";
    params.deliveryTime = "[" + listDeliveryTime.join(",") + "]";
    params.paymentTerm = "[" + listPaymentTerm.join(",") + "]";
    params.quality = "[" + listQuality.join(",") + "]";
    params.price = "[" + listPrice.join(",") + "]";
    params.lineID = widget.id.toString();
    params.idProviderSelected = selected.priceRefer.provider.iD.toString();
    var bool = await _pricePreferRepository.choice();
    if (bool) {
      widget.itemModel.providerID = selected.priceRefer.provider.iD;
      widget.itemModel.priceByProvider = selected.priceRefer.costLog.price;
      widget.itemModel.provider = selected.priceRefer.provider.name;
      Navigator.pop(context, true);
    }
  }

  showDetails(PriceRefers price) async {
    List<ContentShoppingModel> models = [];
    ContentShoppingModel code,
        name,
        priceModel,
        paymentTerm,
        deliveryTime,
        quality,
        warranty,
        point;
    bool isEditable = !widget.isBrowse &&
        _pricePreferRepository.pricePreferModels.isHidden != true;
    code = ContentShoppingModel(
        title: "M?? NCC",
        value: price.priceRefer.provider.code,
        isNextPage: false);
    models.add(code);
    name = ContentShoppingModel(
        title: "T??n NCC",
        value: price.priceRefer.provider.name,
        isNextPage: false);
    models.add(name);
    priceModel = ContentShoppingModel(
        title: "B??o gi?? (VAT)",
        value: (price.priceRefer.costLog.price ?? "").toString(),
        isRequire: true,
        isNextPage: isEditable,
        isMoney: true);
    models.add(priceModel);
    paymentTerm = ContentShoppingModel(
        title: "??i???u khi???n thanh to??n",
        isNextPage: isEditable,
        value: price.priceRefer.costLog.paymentTerm);
    models.add(paymentTerm);
    deliveryTime = ContentShoppingModel(
        isNextPage: isEditable,
        title: "Th???i gian giao h??ng",
        value: price.priceRefer.costLog.deliveryTime);
    models.add(deliveryTime);
    quality = ContentShoppingModel(
        isNextPage: isEditable,
        title: "Ch???t l?????ng s???n ph???m",
        value: price.priceRefer.costLog.quality);
    models.add(quality);
    warranty = ContentShoppingModel(
        isNextPage: isEditable,
        title: "Th???i gian b???o h??nh",
        value: price.priceRefer.costLog.warranty);
    models.add(warranty);
    point = ContentShoppingModel(
        title: "??i???m ????nh gi??",
        value: (price.priceRefer.costLog.point ?? "").toString(),
        isNextPage: false);
    models.add(point);
    await pushPage(
        context,
        ListWithArrowScreen(
          screenTitle: "Chi ti???t nh?? cung c???p",
          data: models,
          isShowSaveButton: !widget.isBrowse &&
              _pricePreferRepository.pricePreferModels.isHidden != true,
          saveTitle: "L??u",
        ));
    price.priceRefer.provider.code = code.value;
    price.priceRefer.provider.name = name.value;
    price.priceRefer.costLog.price = double.tryParse(
            priceModel.value.replaceAll(Constant.SEPARATOR_THOUSAND, "")) ??
        0;
    price.priceRefer.costLog.paymentTerm = paymentTerm.value;
    price.priceRefer.costLog.deliveryTime = deliveryTime.value;
    price.priceRefer.costLog.quality = quality.value;
    price.priceRefer.costLog.warranty = warranty.value;
    price.priceRefer.costLog.point = int.tryParse(point.value) ?? null;
  }

  List<ContentShoppingModel> _createFixModels() {
    fixModels = [];
    ContentShoppingModel model = ContentShoppingModel(
        title: "S???n ph???m kh???o gi??", value: widget.title, isNextPage: false);
    fixModels.add(model);
    model = ContentShoppingModel(
        title: "H??ng", value: widget.itemModel.manufactur, isNextPage: false);
    fixModels.add(model);
    if (!widget.isBrowse &&
        !(_pricePreferRepository?.pricePreferModels?.isHidden ?? true)) {
      model = ContentShoppingModel(
          title: "M?? ho???c t??n nh?? cung c???p",
          value: "Gi?? tr???",
          isNextPage: true);
      fixModels.add(model);
      model = ContentShoppingModel(
          title: "Nh???n g???i ??", value: "Chi ti???t", isNextPage: true);
      fixModels.add(model);
    }
    return fixModels;
  }
}
