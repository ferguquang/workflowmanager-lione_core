import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/requisition_shopping/detail/requisition_sub_detail_item.dart';
import 'package:workflow_manager/shopping_management/management/requisition_shopping/detail/requisiton_detail_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/requisition_response.dart';
import 'approve_reject_bottomsheet.dart';

class RequisitionDetailScreen extends StatefulWidget {
  Requisitions model;

  RequisitionDetailScreen({@required this.model});

  @override
  _RequisitionDetailScreenState createState() =>
      _RequisitionDetailScreenState();
}

class _RequisitionDetailScreenState extends State<RequisitionDetailScreen> {
  RequisitionDetailRepository _repository = RequisitionDetailRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getRequisitionDetail(widget.model.iD);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, RequisitionDetailRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(
              title: Text("Chi tiết yêu cầu mua sắm"),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _repository.listDetail.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ContentViewShoppingItem(
                          model: _repository.listDetail[index],
                          onClick: (item, position) {
                            if (item.title == "Chi tiết") {
                              pushPage(
                                  context,
                                  DetailProcedureScreen(
                                    idServiceRecord: _repository
                                        .dataPlanningDetail
                                        .requisition
                                        .iDServiceRecord,
                                    type: DetailProcedureScreen.TYPE_RESOLVE,
                                    state: null,
                                  ));
                            } else if (item.title == "Ghi chú lý do" &&
                                _repository
                                    .dataPlanningDetail.requisition.isNote) {
                              pushPage(
                                  context,
                                  InputTextWidget(
                                    title: "Ghi chú lý do",
                                    content: _repository.listDetail[10].value,
                                    onSendText: (text) {
                                      setState(() {
                                        _repository.listDetail[10].value = text;
                                      });
                                    },
                                  ));
                            }
                          },
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      child: Text("Dữ liệu yêu cầu mua sắm"),
                      color: Colors.grey[100],
                      padding: EdgeInsets.all(16),
                    ),
                    isNotNullOrEmpty(_repository.dataPlanningDetail.requisitionDetails) ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _repository.dataPlanningDetail.requisitionDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RequisitionSubDetailItem(
                          model: _repository.dataPlanningDetail.requisitionDetails[index],
                          onClickItem: (itemClick) async {
                            List<ContentShoppingModel> list = _repository.getSubDetail(itemClick, _repository.dataPlanningDetail.requisitionDetails[index]);
                            pushPage(context, ListWithArrowScreen(
                              data: list,
                              screenTitle: "Chi tiết dữ liệu",
                              isShowSaveButton: false,
                            ));
                          },
                        );
                      },
                    ) : SizedBox(),
                    SizedBox(height: 24,),
                    Visibility(
                      visible: isVisibility(
                          _repository.dataPlanningDetail.requisition.isApprove,
                          _repository.dataPlanningDetail.requisition.isReject),
                      child: SaveButton(
                        title: "XỬ LÝ",
                        onTap: () async {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Wrap(
                                  children: [
                                    ApproveRejectBottomSheet(
                                      onApprove: () async {
                                        int status = await _repository
                                            .requisitionApprove(
                                                widget.model.iD);
                                        if (status == 1) {
                                          _repository.getRequisitionDetail(
                                              widget.model.iD);
                                        }
                                      },
                                      onReject: () async {
                                        int status =
                                            await _repository.requisitionReject(
                                                widget.model.iD,
                                                _repository
                                                    .listDetail[10].value);
                                        if (status == 1) {
                                          _repository.getRequisitionDetail(
                                              widget.model.iD);
                                        }
                                      },
                                      isReject: _repository.dataPlanningDetail
                                          .requisition.isReject,
                                      isApprove: _repository.dataPlanningDetail
                                          .requisition.isApprove,
                                    )
                                  ],
                                );
                              });
                        },
                        margin: EdgeInsets.all(16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isVisibility(bool isApprove, bool isReject) {
    if (!isApprove && !isReject) {
      return false;
    } else {
      return true;
    }
  }
}
