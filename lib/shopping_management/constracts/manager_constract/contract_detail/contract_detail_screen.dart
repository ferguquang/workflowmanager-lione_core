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
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/commons/separator_header_widget.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_constract/add_contract_files/add_contract_files_screen.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_constract/contract_detail/contract_sign_info_screen.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_constract/contract_list_repository.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_constract/data_manager_contract_detail/data_manager_contract_detail_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/contract_detail_send_params.dart';
import 'package:workflow_manager/shopping_management/response/contract_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/exhange_rate_response.dart';
import 'package:workflow_manager/shopping_management/response/provider_detail_response.dart';
import 'package:workflow_manager/shopping_management/response/sign_info_response.dart';

import 'contract_detail_repository.dart';

class ContractDetailScreen extends StatefulWidget {
  int id;

  ContractDetailScreen(this.id);

  @override
  _ContractDetailScreenState createState() => _ContractDetailScreenState();
}

class _ContractDetailScreenState extends State<ContractDetailScreen> {
  ContractDetailRepository _contractDetailRepository =
      ContractDetailRepository();
  bool isNeedUpdatePreviewScreen = false;

  @override
  void initState() {
    super.initState();
    _contractDetailRepository.loadData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _contractDetailRepository,
        child: Consumer(builder: (context,
            ContractDetailRepository contractDetailRepository, child) {
          List<ContentShoppingModel> listData =
              _contractDetailRepository?.listItem;
          List<Lines> listLine =
              _contractDetailRepository?.contractDetailModel?.contract?.lines;
          return WillPopScope(
            onWillPop: () {
              if (_contractDetailRepository.isEditting == true) {
                _contractDetailRepository.toggleEditing();
                return Future.value(false);
              }
              if (isNeedUpdatePreviewScreen) {
                Navigator.pop(context, true);
                return Future.value(false);
              }

              return Future.value(true);
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text(_contractDetailRepository.isEditting
                      ? "Chỉnh sửa hợp đồng"
                      : "Chi tiết quản lý hợp đồng"),
                  actions: [
                    Visibility(
                      visible: _contractDetailRepository.isUpdate &&
                          !_contractDetailRepository.isEditting,
                      child: InkWell(
                        onTap: () {
                          _contractDetailRepository.toggleEditing();
                        },
                        child: Container(
                          child: Icon(
                            Icons.edit,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                      ),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listData?.length ?? 0,
                        itemBuilder: (context, index) {
                          return ContentViewShoppingItem(
                            model: listData?.elementAt(index),
                            onClick: (model, position) async {
                              if (model.isNextPage == false)
                                return;
                              else if (model.isOnlyDate) {
                                DateTimePickerWidget(
                                  format: Constant.ddMMyyyy,
                                  context: context,
                                  onDateTimeSelected: (date) {
                                    model.value = date;
                                    _contractDetailRepository.notifyListeners();
                                  },
                                )..showOnlyDatePicker();
                              } else {
                                if (model.title ==
                                    ContractDetailRepository.CONTRACT_DETAIL) {
                                  List<ContractFiles> files = await pushPage(
                                      context,
                                      AddContractFilesScreen(
                                          _contractDetailRepository
                                              .contractDetailModel
                                              .contract
                                              .contractFiles,
                                          _contractDetailRepository
                                              .isEditting));
                                  _contractDetailRepository
                                      .updateContractFiles(files);
                                } else if (model.title ==
                                    ContractDetailRepository
                                        .SIGNINGAPPROVAL_DETAIL) {
                                  List<Info> result =
                                      await _contractDetailRepository
                                          .loadSignInfo(widget.id);
                                  if (isNotNullOrEmpty(result)) {
                                    pushPage(context,
                                        ContractSignInfoScreen(result));
                                  }
                                } else {
                                  await pushPage(
                                      context,
                                      InputTextWidget(
                                        title: model.title,
                                        isNumberic: index == 14,
                                        content: model.value,
                                        onSendText: (text) {
                                          model.value = text;
                                          setState(() {});
                                        },
                                      ));
                                  if (model ==
                                      _contractDetailRepository
                                          .codeContractItem) {
                                    isNeedUpdatePreviewScreen = true;
                                  }
                                }
                              }
                            },
                          );
                        },
                      ),
                      SeparatorHeaderWidget("Dữ liệu quản lý hợp đồng"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listLine?.length ?? 0,
                        itemBuilder: (context, index) {
                          return _getLineItem(listLine?.elementAt(index));
                        },
                      ),
                      Visibility(
                        visible: _contractDetailRepository.isEditting,
                        child: SaveButton(
                          title: "Áp dụng",
                          onTap: done,
                          margin: EdgeInsets.all(16),
                        ),
                      )
                    ],
                  ),
                )),
          );
        }));
  }

  done() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            _getActionItem("Hoàn tất",
                _contractDetailRepository.contractDetailModel.contract.isFinish,
                () async {
              reload(await send(5));
            }),
            _getActionItem(
                "Trình ký",
                _contractDetailRepository
                    .contractDetailModel.contract.isSendSign, () async {
              reload(await send(2));
            }),
            _getActionItem("Lưu tạm",
                _contractDetailRepository.contractDetailModel.contract.isSave,
                () async {
              reload(await send(1));
            }),
            _getActionItem(
                "Hết hàng",
                _contractDetailRepository
                    .contractDetailModel.contract.isOutOfStock, () async {
              reload(await send(-1));
            }),
            Divider(height: 4, thickness: 4),
            _getActionItem("Hủy", true, () {
              Navigator.pop(context);
              _contractDetailRepository.toggleEditing();
            }),
          ],
        );
      },
    );
  }

  Future<bool> send(int action) async {
    if (action != -1) {
      String content =
          "Bạn có chắc chắn hoàn thành lập hợp đồng? Khi chọn hoàn thành, thông tin hợp đồng sẽ không được sửa lại!";
      if (action == 5) {
        var result = await showConfirmDialog(context, content, () {});
        if (result != true) return false;
      }
      ContractDetailSendParams params =
          _contractDetailRepository.getParams(action);
      if (params == null) return false;
      params.act = action;
      isNeedUpdatePreviewScreen = true;
      return await _contractDetailRepository.save(params);
    } else {
      var result = await showConfirmDialog(
          context,
          "Sau khi thay đổi hết hàng, PO sẽ bị hủy bỏ và quay về bước Lựa chọn nhà cung cấp. Bạn có chắc chắn với lựa chọn này?",
          () {});
      if (result != true) return false;
      isNeedUpdatePreviewScreen = true;
      return _contractDetailRepository.outOfStock(widget.id);
    }
  }

  reload(bool isNeedReload) {
    Navigator.pop(context);
    if (isNeedReload) {
      isNeedUpdatePreviewScreen = true;
      _contractDetailRepository.toggleEditing();
      _contractDetailRepository.loadData(widget.id);
    }
  }

  Widget _getActionItem(
      String text, bool isVisibility, GestureTapCallback onTap) {
    return Visibility(
      visible: isVisibility,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _getLineItem(Lines model) {
    return InkWell(
      onTap: () {
        pushPage(
                context,
                DataManagerContractDetailScreen(
                    model,
                    _contractDetailRepository
                        .contractDetailModel.contract.iDSuggestionType,
                    _contractDetailRepository.isEditting))
            .then((value) {
          if (value == true) {
            _contractDetailRepository.updateTotal();
          }
        });
      },
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
                    model?.product ?? "",
                    style: TextStyle(color: getColor("#54A0F5"), fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Text("Số lượng: ${(model?.qTY?.toInt() ?? "")}"),
                  Text("Đơn vị: ${(model?.unit ?? "")}"),
                ],
              ),
            ),
            RightArrowIcons()
          ],
        ),
      ),
    );
  }
}
