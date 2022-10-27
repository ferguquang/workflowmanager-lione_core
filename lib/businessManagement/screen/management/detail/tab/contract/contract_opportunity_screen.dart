import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/bottom_sheet_contract_oppotunity.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/row_icon_text_widget.dart';

import '../../../../../../main.dart';
import 'contract_opportunity_repository.dart';
import 'create_contract/create_contract_screen.dart';
import 'detail_contract/detail_contract_screen.dart';

class ContractOpportunityScreen extends StatefulWidget {
  List<Contracts> contracts;
  bool isOnlyView;
  bool isCreateContract;
  int idOpportunity;

  @override
  _ContractOpportunityScreenState createState() =>
      _ContractOpportunityScreenState();

  ContractOpportunityScreen(this.contracts, this.isOnlyView,
      this.isCreateContract, this.idOpportunity);
}

class _ContractOpportunityScreenState extends State<ContractOpportunityScreen> {
  ContractOpportunityRepository _repository = ContractOpportunityRepository();

  StreamSubscription _dataContracts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dataContracts = eventBus.on<GetDataContractEventBus>().listen((event) {
      setState(() {
        if (event.isCreate)
          widget.contracts?.add(event?.contracts);
        else
          widget.contracts[widget.contracts?.indexWhere(
                  (element) => element?.iD == event?.contracts?.iD)] =
              event?.contracts;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (isNotNullOrEmpty(_dataContracts)) _dataContracts.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, ContractOpportunityRepository __repository1, child) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: getColor('#f1f1f1'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.contracts?.length ?? 0} hợp đồng',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.contracts?.length ?? 0,
                    itemBuilder: (context, index) {
                      Contracts item = widget.contracts[index];
                      return InkWell(
                        child: _itemContract(item),
                        onTap: () {
                          pushPage(
                              context,
                              DetailContractScreen(
                                isOnlyView: widget.isOnlyView,
                                idOpportunity: widget.idOpportunity,
                                idContract: item?.iD,
                              ));
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemContract(Contracts item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: item.isDeleted ? Colors.red : Colors.black),
                ),
                RowAndTextWidget(
                  padding: EdgeInsets.only(top: 4),
                  icon: Icons.access_time,
                  text:
                      'Ngày ký: ${widget.isOnlyView ? item?.signDateString : convertTimeStampToHumanDate(item?.signDate, Constant.ddMMyyyy2)}' ??
                          '',
                ),
                RowAndTextWidget(
                  padding: EdgeInsets.only(top: 4),
                  icon: Icons.access_time,
                  text: 'Giá trị hợp đồng thực tế: ${item?.totalMoney}' ?? '',
                ),
                RowAndTextWidget(
                  padding: EdgeInsets.only(top: 4),
                  icon: Icons.access_time,
                  text: 'Mã hợp đồng: ${item?.code}' ?? '',
                ),
                RowAndTextWidget(
                  padding: EdgeInsets.only(top: 4),
                  icon: Icons.access_time,
                  text:
                      'Thời gian thực hiện: Từ ${widget.isOnlyView ? "${item?.startDateString} đến ${item?.endDateString}" : "${convertTimeStampToHumanDate(item?.startDate, Constant.ddMMyyyy2)} đến ${convertTimeStampToHumanDate(item?.endDate, Constant.ddMMyyyy2)}"}' ??
                          '',
                ),
              ],
            ),
          ),
          Visibility(
            visible: !widget.isOnlyView,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: this.context,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) {
                      return Wrap(
                        children: [
                          BottomSheetContractOpportunityScreen(
                            contract: item,
                            onData: (data) {
                              _callApicontract(item, data);
                            },
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  // click vào 3 chấm ở hơp đồng và call api
  _callApicontract(Contracts item, ModelContract data) async {
    switch (data.type) {
      // sửa
      case BottomSheetContractOpportunityScreen.VIEW_UPDATE:
        if (item?.iD == null || item?.iD == 0) {
          ToastMessage.show(
              "Không lấy được thông tin hợp đồng cần sửa!", ToastStyle.error);
          return;
        }
        pushPage(context, CreateContractScreen(item?.iD, false));
        break;
      // xóa
      case BottomSheetContractOpportunityScreen.VIEW_DELETE:
        ConfirmDialogFunction(
            content: 'Bạn có muốn xóa hợp đồng không?',
            context: context,
            onAccept: () async {
              bool status = await _repository.getContractTrash(item?.iD);
              if (status) {
                setState(() {
                  widget.contracts?.remove(item);
                });
              }
            }).showConfirmDialog();
        break;

      // xóa vĩnh viễn
      case BottomSheetContractOpportunityScreen.VIEW_DELETE_FOREVER:
        ConfirmDialogFunction(
            content: 'Bạn có muốn xóa vĩnh viễn hợp đồng không?',
            context: context,
            onAccept: () async {
              bool status = await _repository.getContractRemove(item?.iD);
              if (status) {
                setState(() {
                  widget.contracts?.remove(item);
                });
              }
            }).showConfirmDialog();
        break;

      // khôi phục
      case BottomSheetContractOpportunityScreen.VIEW_RESTORE:
        Contracts model = await _repository.getContractRestore(item?.iD);
        if (model != null) {
          setState(() {
            widget.contracts?.insert(0, model);
          });
        }
        break;
    }
  }
}
