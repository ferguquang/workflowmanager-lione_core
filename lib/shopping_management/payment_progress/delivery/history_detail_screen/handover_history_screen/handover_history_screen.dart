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
import 'package:workflow_manager/shopping_management/response/handover_history_response.dart';

import 'handover_history_repository.dart';

class HandoverHistoryScreen extends StatefulWidget {
  int id;

  HandoverHistoryScreen(this.id);

  @override
  _HandoverHistoryScreenState createState() => _HandoverHistoryScreenState();
}

class _HandoverHistoryScreenState extends State<HandoverHistoryScreen> {
  HandoverHistoryRepository _handoverHistoryRepository =
      HandoverHistoryRepository();

  @override
  void initState() {
    super.initState();
    _handoverHistoryRepository.setFixItems();
    _handoverHistoryRepository.loadData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _handoverHistoryRepository,
      child: Consumer(
        builder: (context, HandoverHistoryRepository handoverHistoryRepository,
            child) {
          List<ContentShoppingModel> fixItems =
              handoverHistoryRepository.fixItems;
          List<Histories> histories =
              handoverHistoryRepository?.handoverHistoryModel?.histories;
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
                              onClick: (model, position) {},
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
                            Histories detailDelivery = histories[index];
                            return _getLineItem(detailDelivery);
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
        showItemDetail(model);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(
              Icons.history,
              size: 35,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    replaceDateToMobileFormat(model?.actDeliveryDate),
                    style: TextStyle(color: getColor("#54A4FF"), fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Text("Trạng thái: ${model?.status ?? ""}"),
                ],
              ),
            ),
            RightArrowIcons()
          ],
        ),
      ),
    );
  }

  showItemDetail(Histories data) async {
    ContentShoppingModel importDateItem,
        numberRequestItem,
        sendNumberItem,
        payNumberItem,
        sumNumbersendItem,
        numberRestItem,
        statusItem,
        numberOKItem,
        numberNotItem,
        noteItem;
    List<ContentShoppingModel> listItems = [];
    importDateItem = ContentShoppingModel(
        title: "Ngày giao",
        value: replaceDateToMobileFormat(data.actDeliveryDate),
        isNextPage: false);
    numberRequestItem = ContentShoppingModel(
        title: "Số lượng yêu cầu (1)",
        value: getStringFromDouble(data.qTY),
        isNextPage: false);
    sendNumberItem = ContentShoppingModel(
        title: "Số lượng giao (2)",
        value: getStringFromDouble(data.deliveryQTY),
        isNextPage: false);
    payNumberItem = ContentShoppingModel(
        title: "Số lượng trả (3)",
        value: getStringFromDouble(data.returnQTY),
        isNextPage: false);
    sumNumbersendItem = ContentShoppingModel(
        title: "Tổng số lượng đã giao (4) = (4)+(2)-(3)",
        value: getStringFromDouble(data.totalQTY),
        isNextPage: false);
    numberRestItem = ContentShoppingModel(
        title: "Số lượng còn lại (5)=(1)-(4)",
        value: getStringFromDouble(data.remainQTY),
        isNextPage: false);
    statusItem = ContentShoppingModel(
        title: "Trạng thái", value: data?.status ?? "", isNextPage: false);
    numberOKItem = ContentShoppingModel(
        title: "Số lượng đạt",
        value: getStringFromDouble(data.okQTY),
        isNextPage: false);
    numberNotItem = ContentShoppingModel(
        title: "Số lượng chưa đạt",
        value: getStringFromDouble(data.notOkQTY),
        isNextPage: false);
    noteItem = ContentShoppingModel(
        title: "Ghi chú",
        isEditable: false,
        value: data?.note ?? "",
        isNextPage: isNotNullOrEmpty(data?.note));
    listItems.add(importDateItem);
    listItems.add(numberRequestItem);
    listItems.add(sendNumberItem);
    listItems.add(payNumberItem);
    listItems.add(sumNumbersendItem);
    listItems.add(numberRestItem);
    listItems.add(statusItem);
    listItems.add(numberOKItem);
    listItems.add(numberNotItem);
    listItems.add(noteItem);
    pushPage(
        context,
        ListWithArrowScreen(
          data: listItems,
          screenTitle: "Chi tiết dữ liệu lịch sử hàng về",
          isShowSaveButton: false,
        ));
  }

  String removeSeparateThousand(dynamic text) {
    if (isNullOrEmpty(text)) return "";
    return text.toString().replaceAll(Constant.SEPARATOR_THOUSAND, "");
  }

  int getInt(String number) {
    if (isNullOrEmpty(number)) return 0;
    return int.tryParse(number) ?? 0;
  }

  String getStringFromDouble(double number) {
    if (number == null) return "0";
    return number.toInt().toString();
  }

  showDetailHistory(int id) {
    pushPage(context, DeliveryHistoryDetailScreen(id));
  }
}
