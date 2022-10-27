import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/price_prefer/price_prefer_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/provider_detail_response.dart';

class ChooseShoppingScreen extends StatefulWidget {
  bool isBrowser;
  LineChooseProviderDetail model;
  bool isDontSave;
  int providerId;
  Requisition requisition;

  ChooseShoppingScreen(this.isBrowser, this.model, this.isDontSave,
      this.providerId, this.requisition);

  @override
  ChooseShoppingScreenState createState() => ChooseShoppingScreenState();
}

class ChooseShoppingScreenState extends State<ChooseShoppingScreen> {
  final String TEN_HH = "Tên hàng hoá";
  final String MOTA_HH = "Mô tả hàng hoá";
  final String HANG = "Hãng";
  final String SOLUONG_DUYETMUA = "Số lượng duyệt mua";
  final String DONVI_TINH = "Đơn vị tính";
  final String XUATXU = "Xuất xứ";
  final String DONGIA = "Đơn giá (PR)";
  final String THANHTIEN = "Thành tiền (PR)";
  final String NGAY_YC_MUAHANG = "Ngày yêu cầu giao hàng";
  final String DIADIEM_GIAOHANG = "Địa điểm giao hàng";
  final String THOIGIAN_THUE = "Thời gian thuê";
  final String DONVI_TINH_TIME = "Đơn vị tính";
  final String TEN_NCC = "Tên nhà cung cấp";
  final String GIA_NCC = "Giá nhà cung cấp (VAT)";
  List<ContentShoppingModel> listData = [];
  LineChooseProviderDetail model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    setData();
  }

  setData() {
    listData = [];
    listData.add(ContentShoppingModel(
        title: TEN_HH, value: model.product, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: MOTA_HH, value: model.description, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: HANG, value: model.manufactur ?? "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: SOLUONG_DUYETMUA,
        value: model?.qTY?.toInt()?.toString() ?? "",
        isNextPage: false));
    listData.add(ContentShoppingModel(
        title: DONVI_TINH, value: model.unit, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: XUATXU, value: model.origin, isNextPage: false));
    if (isNotNullOrEmpty(model.price)) {
      String price = getCurrencyFormat(model.price.toString());
      listData.add(
          ContentShoppingModel(title: DONGIA, value: price, isNextPage: false));
    } else {
      listData.add(
          ContentShoppingModel(title: DONGIA, value: "", isNextPage: false));
    }

    String amount = getCurrencyFormat(model.amount?.toString() ?? "");
    listData.add(ContentShoppingModel(
        title: THANHTIEN, value: amount + "", isNextPage: false));
    listData.add(ContentShoppingModel(
        title: NGAY_YC_MUAHANG,
        value: getDate(model.deliveryDate.toString()),
        isNextPage: false));
    listData.add(ContentShoppingModel(
        title: DIADIEM_GIAOHANG,
        value: model.deliveryDestination,
        isNextPage: false));
    listData.add(ContentShoppingModel(
        title: THOIGIAN_THUE,
        value: model.nbRent.toString(),
        isNextPage: false));
    listData.add(ContentShoppingModel(
        title: DONVI_TINH_TIME,
        value: model.rentType.toString(),
        isNextPage: false));
    listData.add(ContentShoppingModel(
        title: TEN_NCC, value: model.provider, isNextPage: false));
    listData.add(ContentShoppingModel(
        title: GIA_NCC,
        value: getCurrencyFormat(model.priceByProvider.toString()),
        isNextPage: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isBrowser
              ? "Chi tiết dữ liệu duyệt lựa chọn NCC"
              : "Chi tiết dữ liệu yêu cầu mua sắm")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listData?.length ?? 0,
              itemBuilder: (context, index) {
                return ContentViewShoppingItem(
                  model: listData[index],
                );
              },
            ),
          ),
          Visibility(
            visible: !model.isHidden,
            child: SaveButton(
              title: "Khảo giá nhà cung cấp",
              margin: EdgeInsets.all(16),
              onTap: () async {
                var isSuccess = await pushPage(
                    context,
                    PricePreferScreen(model.iD, model.product, widget.isBrowser,
                        widget.isDontSave, widget.providerId, model));
                if (isSuccess == true) {
                  setData();
                  setState(() {});
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
