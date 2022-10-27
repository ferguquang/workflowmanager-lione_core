import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_contract_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/bottom_sheet_stage_payment_contract.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/row_icon_text_widget.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/stage_payment/bottom_sheet_create_phase.dart';

import '../../../../../../../../main.dart';
import 'stage_payment_contract_repository.dart';

class StagePaymentContractScreen extends StatefulWidget {
  ContractDetail contractDetail;
  bool isOnlyView;

  StagePaymentContractScreen(this.contractDetail, this.isOnlyView);

  @override
  _StagePaymentContractScreenState createState() =>
      _StagePaymentContractScreenState();
}

class _StagePaymentContractScreenState
    extends State<StagePaymentContractScreen> {
  StagePaymentContractRepository _repository = StagePaymentContractRepository();
  List<ContractPayments> listData = [];
  List<TypeProjects> listStatus = [];
  bool isCreatePayment = false;
  bool isChangeStatus = false;
  StreamSubscription _dataContracts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listData = widget.contractDetail?.contractPayments;
    listStatus = widget.contractDetail?.contractPaymentStatus;
    isCreatePayment = widget.contractDetail?.isCreatePayment ?? false;
    isChangeStatus = widget.contractDetail?.isChangePhase ?? false;

    _dataContracts =
        eventBus.on<GetDataContractPaymentsEventBus>().listen((event) {
      setState(() {
        if (event.isCreate) {
          listData.add(event?.contracts);
        } else {
          listData[listData.indexWhere(
                  (element) => element.iD == event?.contracts?.iD)] =
              event?.contracts;
        }
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
        builder:
            (context, StagePaymentContractRepository __repository1, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: getColor('#f1f1f1'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${listData.length ?? 0} giai đoạn',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Visibility(
                      visible: !widget.isOnlyView && isCreatePayment,
                      child: InkWell(
                        onTap: () {
                          if (!widget.isOnlyView && isCreatePayment)
                            _showBottomSheetCreatePhase(context);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: Text('Thêm mới +'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: listData?.length == 0
                    ? EmptyScreen()
                    : ListView.separated(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: listData?.length ?? 0,
                        itemBuilder: (context, index) {
                          ContractPayments item = listData[index];
                          return _itemStagePayment(item);
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _itemStagePayment(ContractPayments item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.name ?? '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (!widget.isOnlyView) _eventClickStatus(item);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: getColor('${item?.status?.color}') ??
                                Colors.white),
                        child: Row(
                          children: [
                            Text(
                              '${item?.status?.name ?? 'Chưa thanh toán'} ',
                              style: TextStyle(color: Colors.white),
                            ),
                            Visibility(
                              visible: !widget.isOnlyView && isChangeStatus,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(''),
                    )
                  ],
                ),
                _buildRow(
                    Icons.error, 'Loại giai đoạn: ${item?.typeName ?? ''}'),
                _buildRow(
                    Icons.aspect_ratio_sharp, 'Tỉ lệ (%): ${item?.ratio ?? 0}'),
                _buildRow(Icons.insert_drive_file,
                    'Điều khoản: ${item?.rules ?? ""}'),
                _buildRow(Icons.access_time,
                    'Ngày thanh toán: ${!widget.isOnlyView ? convertTimeStampToHumanDate(item?.paymentDate, Constant.ddMMyyyy2) : item?.paymentDateString}'),
                _buildRow(Icons.date_range,
                    'Báo trước (Ngày): ${item?.remindDay ?? ""}'),
              ],
            ),
          ),
          Visibility(
            visible: !widget.isOnlyView && isChangeStatus,
            child: IconButton(
              onPressed: () {
                if (!widget.isOnlyView && isChangeStatus) {
                  _eventClickOptionItem(item);
                }
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

  _buildRow(IconData icon, String name) {
    return RowAndTextWidget(
      padding: EdgeInsets.only(top: 4),
      icon: icon,
      text: name ?? '',
    );
  }

  // thay đổi trạng thái
  _eventClickStatus(ContractPayments item) {
    if (isNullOrEmpty(listStatus)) {
      ToastMessage.show("Không có dữ liệu", ToastStyle.error);
      return;
    }

    ChoiceDialog choiceDialog = ChoiceDialog<TypeProjects>(
      context,
      listStatus,
      title: 'Thay đổi trạng thái giai đoạn thanh toán',
      getTitle: (data) => data.name,
      isSingleChoice: true,
      onAccept: (List<TypeProjects> selected) async {
        if (isNotNullOrEmpty(selected)) {
          TypeProjects data = selected[0];
          ContractPayments model = await _repository
              .getContractChangePaymentStatus(item?.iD, data?.iD);
          setState(() {
            if (model != null) {
              listData[listData
                  .indexWhere((element) => element.iD == model.iD)] = model;
            }
          });
        }
      },
      choiceButtonText: 'Chọn trạng thái',
    );
    choiceDialog.showChoiceDialog();
  }

  // dấu 3 châm ở item
  _eventClickOptionItem(ContractPayments item) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: this.context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Wrap(
            children: [
              BottomSheetStagePaymentContractScreen(
                title: item?.name ?? '',
                onData: (data) {
                  _callApiContract(item, data);
                },
              ),
            ],
          );
        });
  }

  // click vào 3 chấm ở hơp đồng và call api
  _callApiContract(ContractPayments item, ModelContract data) async {
    switch (data.type) {
      // sửa
      case BottomSheetStagePaymentContractScreen.VIEW_UPDATE:
        _showBottomSheetEditPhase(context, item);
        break;
      // xóa
      case BottomSheetStagePaymentContractScreen.VIEW_DELETE:
        ConfirmDialogFunction(
            content: 'Bạn có muốn xóa giai đoạn này không?',
            context: context,
            onAccept: () async {
              bool status =
                  await _repository.getContractDeletePayment(item?.iD);
              if (status) {
                setState(() {
                  listData?.remove(item);
                });
              }
            }).showConfirmDialog();
        break;
    }
  }

  // tạo mới giai đoạn thanh toán
  _showBottomSheetCreatePhase(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Wrap(
            children: [
              BottomSheetCreatePhaseScreen(
                idContract: widget.contractDetail?.iD,
                type: BottomSheetCreatePhaseScreen.TYPE_CRETAE_CONTRACT,
                listData: widget.contractDetail?.contractPaymentTypes,
              ),
            ],
          );
        });
  }

  // Chỉnh sửa giai đoạn thanh toán
  _showBottomSheetEditPhase(BuildContext context, ContractPayments item) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Wrap(
            children: [
              BottomSheetCreatePhaseScreen(
                idContract: widget.contractDetail?.iD,
                type: BottomSheetCreatePhaseScreen.TYPE_UPDATE_CONTRACT,
                listData: widget.contractDetail?.contractPaymentTypes,
                contractPayments: item,
              ),
            ],
          );
        });
  }
}
