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
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_history_detail_response.dart';

import 'delivery_history_detail_repository.dart';

class DeliveryHistoryDetailScreen extends StatefulWidget {
  int id;

  DeliveryHistoryDetailScreen(this.id);

  @override
  _DeliveryHistoryDetailScreenState createState() =>
      _DeliveryHistoryDetailScreenState();
}

class _DeliveryHistoryDetailScreenState
    extends State<DeliveryHistoryDetailScreen> {
  bool isNeedRefreshListScreen = false;
  DeliveryHistoryDetailRepository _detailRepository =
      DeliveryHistoryDetailRepository();

  ContentShoppingModel asdf;

  @override
  void initState() {
    super.initState();
    _detailRepository.setFixItems();
    _detailRepository.loadData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _detailRepository,
      child: Consumer(
        builder: (context,
            DeliveryHistoryDetailRepository deliveryDetailRepository, child) {
          List<ContentShoppingModel> fixItems =
              deliveryDetailRepository.fixItems;
          List<Histories> histories =
              deliveryDetailRepository?.deliveryHistoryDetailModel?.histories;
          return Scaffold(
              appBar: AppBar(
                title: Text("Chi tiết lịch sử hàng về"),
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
                            );
                          },
                        ),
                        SeparatorHeaderWidget(
                            "Dữ liệu chi tiết lịch sử hàng về"),
                        ListView.builder(
                          itemCount: histories?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Histories history = histories[index];
                            return _getLineItem(history);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }

  Widget _getLineItem(Histories model) {
    return InkWell(
      onTap: () async {
        showHistory(model);
      },
      child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            replaceDateToMobileFormat(model?.actDeliveryDate) ??
                                "",
                            style: TextStyle(
                                color: getColor("#54A0F5"), fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                          ),
                          Text("Trạng thái: ${model.status}"),
                        ],
                      ),
                    ),
                    RightArrowIcons()
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
              )
            ],
          ),
          secondaryActions: []),
    );
  }

  showHistory(Histories data) {
    List<ContentShoppingModel> listModels = [];
    ContentShoppingModel importDateItem = ContentShoppingModel(
        title: "Ngày giao",
        value: replaceDateToMobileFormat(data.actDeliveryDate),
        isNextPage: false);
    ContentShoppingModel numberRequestItem = ContentShoppingModel(
        title: "Số lượng yêu cầu (1)",
        value: data.qTY?.toInt() ?? "",
        isNextPage: false);
    ContentShoppingModel sendNumberItem = ContentShoppingModel(
        title: "Số lượng giao (2)",
        value: data.deliveryQTY?.toInt() ?? "",
        isNextPage: false);
    ContentShoppingModel payNumberItem = ContentShoppingModel(
        title: "Số lượng trả (3)",
        value: data.returnQTY?.toInt() ?? "",
        isNextPage: false);
    ContentShoppingModel sumNumbersendItem = ContentShoppingModel(
        title: "Tổng số lượng đã giao (4) = (4)+(2)-(3)",
        value: data.totalQTY?.toInt() ?? "",
        isNextPage: false);
    ContentShoppingModel numberRestItem = ContentShoppingModel(
        title: "Số lượng còn lại (5)=(4)-(1)",
        value: data.remainQTY?.toInt() ?? "",
        isNextPage: false);
    ContentShoppingModel statusItem = ContentShoppingModel(
        title: "Trạng thái", value: data?.status ?? "", isNextPage: false);
    ContentShoppingModel numberOKItem = ContentShoppingModel(
        title: "Số lượng đạt",
        value: data.okQTY?.toInt() ?? "",
        isNextPage: false);
    ContentShoppingModel numberNotItem = ContentShoppingModel(
        title: "Số lượng chưa đạt",
        value: data.notOkQTY?.toInt() ?? "",
        isNextPage: false);
    ContentShoppingModel noteItem = ContentShoppingModel(
        title: "Ghi chú",
        value: data.note ?? "",
        isNextPage: isNotNullOrEmpty(data.note));

    listModels.add(importDateItem);
    listModels.add(numberRequestItem);
    listModels.add(sendNumberItem);
    listModels.add(payNumberItem);
    listModels.add(sumNumbersendItem);
    listModels.add(numberRestItem);
    listModels.add(statusItem);
    listModels.add(numberOKItem);
    listModels.add(numberNotItem);
    listModels.add(noteItem);
    pushPage(
        context,
        ListWithArrowScreen(
          data: listModels,
          screenTitle: "Chi tiết dữ liệu phiếu kiểm tra",
          isShowSaveButton: false,
        ));
  }
}
