import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/commons/separator_header_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/delivery_details_screen/delivery_detail_repository.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_history_detail_screen.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_progress_screen/delivery_progress_detail_screen/delivery_progress_detail_repository.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_progress_screen/delivery_progress_list_screen/delivery_progress_list_screen.dart';
import 'package:workflow_manager/shopping_management/response/check_slip_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_detail_response.dart';

import 'check_slip_detail_repository.dart';

class CheckSlipDetailScreen extends StatefulWidget {
  int id;

  CheckSlipDetailScreen(this.id);

  @override
  _CheckSlipDetailScreenState createState() => _CheckSlipDetailScreenState();
}

class _CheckSlipDetailScreenState extends State<CheckSlipDetailScreen> {
  bool isNeedRefreshListScreen = false;
  CheckSlipDetailRepository _detailRepository = CheckSlipDetailRepository();
  bool isEditting = false;

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
        builder: (context, CheckSlipDetailRepository checkSlipDetailRepository,
            child) {
          List<ContentShoppingModel> fixItems =
              checkSlipDetailRepository.fixItems;
          List<DeliveriesProgressLogDetails> lines = checkSlipDetailRepository
              ?.checkSlipDetailModel?.deliveriesProgressLogDetails;
          return Scaffold(
              appBar: AppBar(
                title: Text("Phiếu kiểm tra"),
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
                              onClick: (model, position) {
                                pushPage(
                                    context,
                                    DetailProcedureScreen(
                                      idServiceRecord: checkSlipDetailRepository
                                          ?.checkSlipDetailModel
                                          ?.deliveriesProgressLog
                                          ?.iDServiceRecord,
                                      type: DetailProcedureScreen.TYPE_REGISTER,
                                      state: null,
                                    ));
                              },
                            );
                          },
                        ),
                        SeparatorHeaderWidget("Dữ liệu phiếu kiểm tra"),
                        ListView.builder(
                          itemCount: lines?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            DeliveriesProgressLogDetails line = lines[index];
                            return _getLineItem(line);
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

  Widget _getLineItem(DeliveriesProgressLogDetails model) {
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
                      Text("Số lượng gửi: ${model?.deliverQTY?.toInt() ?? 0}"),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Text("Xuất xứ: ${model?.origin ?? ""}"),
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

  showItemDetail(DeliveriesProgressLogDetails data) async {
    List<ContentShoppingModel> itemList = [];
    ContentShoppingModel nameItem,
        descriptionItem,
        sendNumberItem,
        unitItem,
        serialItem,
        originallItem,
        numberReachedItem,
        notNumberReachedItem,
        noteItem;

    nameItem = ContentShoppingModel(
        title: "Tên hàng hóa(MSP)",
        value: data.commodityName,
        isNextPage: false);
    descriptionItem = ContentShoppingModel(
        title: "Mô tả", value: data.description, isNextPage: true);
    sendNumberItem = ContentShoppingModel(
        title: "Gửi số lượng",
        value: data.deliverQTY?.toInt() ?? 0,
        isNextPage: false);
    unitItem = ContentShoppingModel(
        title: "Đơn vị tính", value: data.unit, isNextPage: false);
    serialItem = ContentShoppingModel(
        title: "Serial", value: data.serials, isNextPage: false);
    originallItem = ContentShoppingModel(
        title: "Xuất xứ", value: data.origin, isNextPage: false);
    numberReachedItem = ContentShoppingModel(
        title: "Số lượng đạt",
        value: data.okQTY?.toInt() ?? 0,
        isNextPage: false);
    notNumberReachedItem = ContentShoppingModel(
        title: "Số lượng chưa đạt",
        value: data.notOkQTY?.toInt() ?? 0,
        isNextPage: false);
    noteItem = ContentShoppingModel(
        title: "Ghi chú", value: data.checkNote, isNextPage: true);
    itemList.add(nameItem);
    itemList.add(descriptionItem);
    itemList.add(sendNumberItem);
    itemList.add(unitItem);
    itemList.add(serialItem);
    itemList.add(originallItem);
    itemList.add(numberReachedItem);
    itemList.add(notNumberReachedItem);
    itemList.add(noteItem);
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: itemList,
          screenTitle: "Chi tiết dữ liệu hàng về bàn giao",
          saveTitle: "Áp dụng",
          isShowSaveButton: isEditting,
        ));
  }

  showDetailHistory(int id) {
    pushPage(context, DeliveryHistoryDetailScreen(id));
  }
}
