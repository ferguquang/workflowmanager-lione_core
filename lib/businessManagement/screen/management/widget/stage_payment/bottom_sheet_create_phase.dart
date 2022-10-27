import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/custom_text_field_validate.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/request/stage_payments_request.dart';
import 'package:workflow_manager/businessManagement/model/response/create_contract_response.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_contract_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/create/group_customers/group_customers_create_screen.dart';
import 'package:workflow_manager/businessManagement/screen/management/detail/tab/contract/detail_contract/stage_payment/type_stage_payment_screen.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

import 'bottom_sheet_create_phase_repository.dart';

class BottomSheetCreatePhaseScreen extends StatefulWidget {
  static const int TYPE_CRETAE_OPPOTUNITY = 1;
  static const int TYPE_CRETAE_CONTRACT = 2;
  static const int TYPE_UPDATE_CONTRACT = 3;

  List<TypeProjects> listData;
  final void Function(Payments data) onPaymentsCreate; // dành cho tạo cơ hội
  int type;
  int idContract;
  ContractPayments contractPayments; // chính sửa hợp đồng mới truyền vào

  BottomSheetCreatePhaseScreen(
      {this.listData,
      this.onPaymentsCreate,
      this.type,
      this.idContract,
      this.contractPayments});

  @override
  _BottomSheetCreatePhaseScreenState createState() =>
      _BottomSheetCreatePhaseScreenState();
}

class _BottomSheetCreatePhaseScreenState
    extends State<BottomSheetCreatePhaseScreen> {
  var ratioController = TextEditingController();
  var rulesController = TextEditingController();
  var remindDayController = TextEditingController();
  var nameController = TextEditingController();
  String datePay = '';
  TypeProjects typeProject = TypeProjects();
  StagePaymentContractRepository _repository = StagePaymentContractRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == BottomSheetCreatePhaseScreen.TYPE_UPDATE_CONTRACT) {
      nameController.text = widget.contractPayments?.name ?? "";
      ratioController.text =
          widget.contractPayments?.ratio.toString().replaceAll('.0', '') ?? '';
      rulesController.text = widget.contractPayments?.rules ?? "";
      remindDayController.text =
          widget.contractPayments?.remindDay.toString() ?? '';
      datePay = convertTimeStampToHumanDate(
          widget.contractPayments?.paymentDate, Constant.ddMMyyyy2);
      typeProject.iD = widget.contractPayments?.type;
      typeProject.name = widget.contractPayments?.typeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder:
            (context, StagePaymentContractRepository __repository1, child) {
          return Container(
            margin: MediaQuery.of(context).viewInsets,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/icon_stage.png',
                        height: 24,
                        width: 24,
                      ),
                      Text(
                        widget.type ==
                                BottomSheetCreatePhaseScreen
                                    .TYPE_UPDATE_CONTRACT
                            ? '  Cập nhật giai đoạn'
                            : '  Tạo mới giai đoạn',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  TextFieldValidate(
                    isShowValidate: true,
                    padding: EdgeInsets.only(top: 16),
                    title: 'Tên giai đoạn',
                    controller: nameController,
                  ),
                  TagLayoutWidget(
                    isShowValidate: true,
                    icon: Icons.arrow_drop_down,
                    horizontalPadding: 0,
                    title: "Loại giai đoạn",
                    value: typeProject?.name ?? '',
                    openFilterListener: () {
                      FocusScope.of(context).unfocus();
                      eventCallBackTypePhase();
                    },
                  ),
                  TextFieldValidate(
                    isShowValidate: true,
                    maxLength: 4,
                    inputFormatters:
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    padding: EdgeInsets.only(top: 8),
                    title: 'Tỉ lệ(%)',
                    controller: ratioController,
                    onChange: () {
                      ratioController =
                          getDataPercentController(ratioController);
                    },
                  ),
                  TextFieldValidate(
                    padding: EdgeInsets.only(top: 8),
                    title: 'Quyết định',
                    controller: rulesController,
                  ),
                  TagLayoutWidget(
                    isShowValidate: true,
                    icon: Icons.date_range,
                    horizontalPadding: 0,
                    title: "Ngày thanh toán",
                    value: datePay ?? '',
                    openFilterListener: () {
                      FocusScope.of(context).unfocus();
                      DateTimePickerWidget(
                          minTime: DateTime.now(),
                          format: Constant.ddMMyyyy2,
                          context: context,
                          onDateTimeSelected: (valueDate) {
                            setState(() {
                              datePay = valueDate;
                            });
                            // print(valueDate);
                          }).showOnlyDatePicker();
                    },
                  ),
                  TextFieldValidate(
                    keyboardType: TextInputType.number,
                    padding: EdgeInsets.only(top: 8),
                    title: 'Báo trước (Ngày)',
                    controller: remindDayController,
                  ),
                  SaveButton(
                    margin: EdgeInsets.only(top: 8),
                    onTap: () {
                      _eventClickDone();
                    },
                    title: 'Xong',
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _eventClickDone() async {
    if (nameController.text.length == 0) {
      ToastMessage.show("Tên giai đoạn$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (typeProject?.iD == null) {
      ToastMessage.show("Loại giai đoạn$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (ratioController.text.length == 0) {
      ToastMessage.show("Tỉ lệ(%)$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (datePay.length == 0) {
      ToastMessage.show("Ngày thanh toán$textNotLeftBlank", ToastStyle.error);
      return;
    }

    if (widget.type == BottomSheetCreatePhaseScreen.TYPE_CRETAE_OPPOTUNITY) {
      Payments data = Payments();
      data?.name = nameController.text;
      data?.type = typeProject?.iD;
      data?.typeName = typeProject?.name;
      data?.ratio = double.parse(ratioController.text);
      data?.rules = rulesController.text;
      data?.remindDay = int.parse(remindDayController.text.length == 0
          ? '0'
          : remindDayController.text);
      data?.paymentDate = getDateTimeObject(datePay, format: Constant.ddMMyyyy2)
          .millisecondsSinceEpoch;
      data.status = Status();
      if (widget.onPaymentsCreate != null) {
        widget.onPaymentsCreate(data);
        Navigator.pop(context);
      }
    } else {
      StagePaymentsRequest request = StagePaymentsRequest();
      request.status = 1; //??? doceye đang  = 1
      request.name = nameController.text;
      request.type = typeProject?.iD;
      request.ratio = ratioController.text;
      request.rules = rulesController.text;
      request.paymentDate = datePay;
      request.remindDay = remindDayController.text;
      request.iDContract = widget.idContract;

      if (widget.type == BottomSheetCreatePhaseScreen.TYPE_UPDATE_CONTRACT) {
        request.iDPayment = widget.contractPayments?.iD;
      }
      await _repository.getContractChangePaymentStatus(request,
          widget.type == BottomSheetCreatePhaseScreen.TYPE_CRETAE_CONTRACT);
      Navigator.pop(context);
    }
  }

  eventCallBackTypePhase() {
    if (widget.type == BottomSheetCreatePhaseScreen.TYPE_CRETAE_OPPOTUNITY) {
      pushPage(
          context,
          GroupCustomersCreateScreen(
            widget.listData,
            typeProject?.iD ?? 0,
            'Chọn loại giai đoạn',
            onGroupCustomers: (_groupCustomers) {
              setState(() {
                typeProject = _groupCustomers;
              });
            },
          ));
    } else {
      pushPage(
          context,
          TypeStagePaymentScreen(
            widget.listData,
            typeProject?.iD ?? 0,
            'Chọn loại giai đoạn',
            onGroupCustomers: (_groupCustomers) {
              setState(() {
                typeProject = _groupCustomers;
              });
            },
          ));
    }
  }
}
