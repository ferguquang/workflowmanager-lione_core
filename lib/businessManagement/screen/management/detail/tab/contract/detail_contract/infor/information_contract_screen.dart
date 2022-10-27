import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_contract_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/detail/tab/contract/create_contract/create_contract_screen.dart';

import '../../../../../../../../main.dart';

class InformationContractScreen extends StatefulWidget {
  ContractDetail contractDetail;
  bool isOnlyView;
  int idOpportunity;

  InformationContractScreen(
      {this.contractDetail, this.isOnlyView, this.idOpportunity});

  @override
  _InformationContractScreenState createState() =>
      _InformationContractScreenState();
}

class _InformationContractScreenState extends State<InformationContractScreen> {
  List<InfoContractModel> listData = [];
  ContractDetail contractData = ContractDetail();
  StreamSubscription _dataContracts;
  bool isUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contractData = widget.contractDetail;
    isUpdate = contractData?.isUpdate;
    if (isUpdate == null) isUpdate = false;
    addList();

    _dataContracts =
        eventBus.on<GetDataContractDetailEventBus>().listen((event) {
      setState(() {
        contractData = event?.contracts;
        isUpdate = contractData?.isUpdate;
        addList();
      });
    });
  }

  addList() {
    String signDate = '', startDate = '', endDate = '';
    if (!widget.isOnlyView) {
      // admin
      signDate =
          '${convertTimeStampToHumanDate(contractData?.signDate ?? 0, Constant.ddMMyyyy2)}';
      startDate =
          '${convertTimeStampToHumanDate(contractData?.startDate ?? 0, Constant.ddMMyyyy2)}';
      endDate =
          '${convertTimeStampToHumanDate(contractData?.endDate ?? 0, Constant.ddMMyyyy2)}';
    } else {
      // khachs
      signDate = contractData?.signDateString ?? "";
      startDate = contractData?.startDateString ?? "";
      endDate = contractData?.endDateString ?? "";
    }

    InfoContractModel signDateModel =
        new InfoContractModel("Ngày ký", signDate);
    InfoContractModel typeModel = new InfoContractModel(
        "Loại hình hợp đồng", contractData?.projectType ?? '');
    InfoContractModel startDateModel =
        new InfoContractModel("Ngày bắt đầu", startDate);
    InfoContractModel endDateModel =
        new InfoContractModel("Ngày kết thúc", endDate);

    InfoContractModel totalMoneyModel =
        new InfoContractModel("Giá trị", contractData?.totalMoney ?? "");
    InfoContractModel capitalModel =
        new InfoContractModel("Giá vốn", contractData?.capital ?? "");
    InfoContractModel grossProfitModel =
        new InfoContractModel("Lãi gộp", contractData?.grossProfit ?? "");
    InfoContractModel bonusModel =
        new InfoContractModel("Thưởng(%)", contractData?.bonus ?? "");
    InfoContractModel bonusTypeModel = new InfoContractModel(
        "Tiêu chí thưởng", contractData?.bonusTypes ?? "");
    InfoContractModel typeOfContractModel =
        new InfoContractModel("Loại hình hợp đồng", contractData?.type ?? "");
    InfoContractModel absoluteValueModel = new InfoContractModel(
        "Giá trị tuyệt đối", contractData?.absoluteValue ?? "");
    InfoContractModel marketingModel = new InfoContractModel(
        "Chi phí marketing (%)", contractData?.marketingCost ?? "");
    InfoContractModel deployCostModel = new InfoContractModel(
        "Chi phí triển khai", contractData?.deployCost ?? "");

    listData = [];
    listData.add(signDateModel);
    listData.add(typeModel);
    listData.add(typeOfContractModel);
    listData.add(totalMoneyModel);
    listData.add(capitalModel);
    listData.add(grossProfitModel);
    listData.add(absoluteValueModel);
    listData.add(startDateModel);
    listData.add(endDateModel);
    listData.add(bonusModel);
    listData.add(bonusTypeModel);
    listData.add(marketingModel);
    listData.add(deployCostModel);
  }

  @override
  void dispose() {
    super.dispose();
    if (isNotNullOrEmpty(_dataContracts)) _dataContracts.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: getColor('#f1f1f1'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thông tin hợp đồng',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Visibility(
                    visible: !widget.isOnlyView && isUpdate,
                    child: InkWell(
                      onTap: () {
                        if (!widget.isOnlyView && isUpdate) {
                          if (contractData?.iD == null ||
                              contractData?.iD == 0) {
                            ToastMessage.show(
                                "Không lấy được thông tin hợp đồng cần sửa!",
                                ToastStyle.error);
                            return;
                          }
                          pushPage(
                              context,
                              CreateContractScreen(
                                  widget.idOpportunity, false));
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        child: Text('Chỉnh sửa'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listData?.length ?? 0,
                itemBuilder: (context, index) {
                  InfoContractModel item = listData[index];
                  return _itemContract(item);
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemContract(InfoContractModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item?.title ?? '',
            style: TextStyle(color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(item?.value ?? ''),
          ),
        ],
      ),
    );
  }
}

class InfoContractModel {
  String title, value;

  InfoContractModel(String title, String value) {
    this.title = title;
    this.value = value;
  }
}
