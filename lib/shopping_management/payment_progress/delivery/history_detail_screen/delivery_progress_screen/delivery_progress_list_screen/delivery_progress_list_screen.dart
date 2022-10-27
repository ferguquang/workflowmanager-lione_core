import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/history_detail_screen/delivery_progress_screen/delivery_progress_detail_screen/delivery_progress_detail_screen.dart';
import 'package:workflow_manager/shopping_management/response/delivery_progress_list_response.dart';

import 'delivery_progress_list_repository.dart';

class DeliveryProgressListScreen extends StatefulWidget {
  int id;
  bool isUpdate;

  DeliveryProgressListScreen(this.id, this.isUpdate);

  @override
  _DeliveryProgressListScreenState createState() =>
      _DeliveryProgressListScreenState();
}

class _DeliveryProgressListScreenState
    extends State<DeliveryProgressListScreen> {
  DeliveryProgressListRepository _deliveryProgressListRepository =
      DeliveryProgressListRepository();

  @override
  void initState() {
    super.initState();
    _deliveryProgressListRepository.isUpdate = widget.isUpdate;
    _deliveryProgressListRepository.loadData(widget.id);
  }

  bool isNeedRefreshListScreen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isNeedRefreshListScreen == true) {
          Navigator.pop(context, true);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: ChangeNotifierProvider.value(
        value: _deliveryProgressListRepository,
        child: Consumer(
          builder: (context,
              DeliveryProgressListRepository deliveryProgressListRepository,
              child) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Danh sách phiếu nhận hàng"),
              ),
              floatingActionButton: Visibility(
                  visible: widget.isUpdate,
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      var deliveryList = deliveryProgressListRepository
                          ?.deliveryProgressListModel?.deliveries;
                      List<int> listIDStatus = [];
                      if (deliveryList.length > 0) {
                        for (Deliveries data in deliveryList) {
                          if (data.iDStatus == 5) // id trạng thái hoàn tất
                          {
                            listIDStatus.add(5);
                          }
                        }
                      }
                      var result = await pushPage(
                          context,
                          DeliveryProgressDetailScreen(
                              DeliveryProgressDetailScreen.create_type,
                              widget.id,
                              _deliveryProgressListRepository.listRemainQTY,
                              _deliveryProgressListRepository.listTotalQTY,
                              listIDStatus.length));
                      if (result == true) {
                        isNeedRefreshListScreen = true;
                        _deliveryProgressListRepository.loadData(widget.id);
                      }
                    },
                  )),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: deliveryProgressListRepository
                              ?.deliveryProgressListModel?.deliveries?.length ??
                          0,
                      itemBuilder: (context, index) {
                        Deliveries delivery = deliveryProgressListRepository
                            ?.deliveryProgressListModel?.deliveries[index];
                        return InkWell(
                          onTap: () async {
                            if (!widget.isUpdate && !delivery.isView) {
                              showErrorToast(
                                  "Bạn không có quyền xem chi tiết phiếu nhận hàng");
                              return;
                            }
                            if (widget.isUpdate && !delivery.isUpdate) {
                              showErrorToast(
                                  "Bạn không có quyền sửa chi tiết phiếu nhận hàng");
                              return;
                            }
                            var deliveryList = deliveryProgressListRepository
                                ?.deliveryProgressListModel?.deliveries;
                            List<int> listIDStatus = [];
                            if (deliveryList.length > 0) {
                              for (Deliveries data in deliveryList) {
                                if (data.iDStatus ==
                                    5) // id trạng thái hoàn tất
                                {
                                  listIDStatus.add(5);
                                }
                              }
                            }
                            var result = await pushPage(
                                context,
                                DeliveryProgressDetailScreen(
                                    widget.isUpdate
                                        ? DeliveryProgressDetailScreen.edit_type
                                        : DeliveryProgressDetailScreen
                                            .view_type,
                                    delivery.iD,
                                    _deliveryProgressListRepository
                                        .listRemainQTY,
                                    _deliveryProgressListRepository
                                        .listTotalQTY,
                                    listIDStatus.length));
                            if (result == true) {
                              isNeedRefreshListScreen = true;
                              _deliveryProgressListRepository
                                  .loadData(widget.id);
                            }
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 40,
                                      margin: EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.orange),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Text(
                                        "${index + 1}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          delivery.status,
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 16),
                                        ),
                                        Text(
                                            "Người nhận: ${delivery?.receiver ?? ""}"),
                                        Text(
                                            "Người giao: ${delivery?.deliver ?? ""}"),
                                        Text(
                                            "Ngày giao: ${replaceDateToMobileFormat(delivery?.actDeliveryDate ?? "")}"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
