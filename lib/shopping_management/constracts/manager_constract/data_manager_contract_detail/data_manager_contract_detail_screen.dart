import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/data_check_validate_response.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/contract_detail_response.dart';

import 'data_manager_contract_detail_repository.dart';

class DataManagerContractDetailScreen extends StatefulWidget {
  Lines model;
  int iIDSuggestionType;
  bool isEditable;

  DataManagerContractDetailScreen(
      this.model, this.iIDSuggestionType, this.isEditable);

  @override
  _DataManagerContractDetailScreenState createState() =>
      _DataManagerContractDetailScreenState();
}

class _DataManagerContractDetailScreenState
    extends State<DataManagerContractDetailScreen> {
  DataManagerContractDetailRepository _dataManagerContractDetailRepository =
      DataManagerContractDetailRepository();

  @override
  void initState() {
    super.initState();
    _dataManagerContractDetailRepository.isEditable = widget.isEditable;
    _dataManagerContractDetailRepository.loadData(
        widget.model, widget.iIDSuggestionType, widget.isEditable);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết dữ liệu quản lý hợp đồng"),
      ),
      body: ChangeNotifierProvider.value(
        value: _dataManagerContractDetailRepository,
        child: Consumer(
          builder: (context,
              DataManagerContractDetailRepository
                  dataManagerContractDetailRepository,
              child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: _dataManagerContractDetailRepository
                              ?.listData?.length ??
                          0,
                      itemBuilder: (context, index) {
                        return ContentViewShoppingItem(
                          model: _dataManagerContractDetailRepository
                              .listData[index],
                          onClick: (model, position) {
                            if (model.isNextPage) {
                              if (model.isOnlyDate) {
                                DateTimePickerWidget(
                                  format: Constant.ddMMyyyy,
                                  context: context,
                                  onDateTimeSelected: (date) {
                                    model.value = date;
                                    _dataManagerContractDetailRepository
                                        .notifyListeners();
                                  },
                                )..showOnlyDatePicker();
                              } else {
                                pushPage(
                                    context,
                                    InputTextWidget(
                                      model: model,
                                      isEditable: model.isEditable,
                                      onSendText: (text) {
                                        model.value = text;
                                        _dataManagerContractDetailRepository
                                            .notifyListeners();
                                        _dataManagerContractDetailRepository
                                            .calcNext(model);
                                      },
                                      onValidate: (text) {
                                        return _dataManagerContractDetailRepository
                                            .valid(model, text);
                                      },
                                    ));
                              }
                            }
                          },
                        );
                      }),
                ),
                Visibility(
                  visible: widget.isEditable,
                  child: SaveButton(
                    title: "Lưu",
                    margin: EdgeInsets.all(16),
                    onTap: () {
                      if (_dataManagerContractDetailRepository.save())
                        Navigator.pop(context, true);
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
