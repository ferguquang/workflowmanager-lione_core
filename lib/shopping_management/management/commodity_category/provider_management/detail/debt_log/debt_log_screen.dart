import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/action_adjusted/action_adjusted_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/debt_log_detail_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/debt_log_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/debt_log_repository.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/history_adjusted/history_adjusted_screen.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class DebtLogScreen extends StatefulWidget {
  ProvidersIndex model;

  DebtLogScreen(this.model);

  @override
  _DebtLogScreenState createState() => _DebtLogScreenState();
}

class _DebtLogScreenState extends State<DebtLogScreen> {
  DebtLogRepository _repository = DebtLogRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _repository.getProviderDetailDebt(widget.model.iD);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, DebtLogRepository repository, Widget child) {
          _repository = repository;
          return Scaffold(
            appBar: AppBar(title: Text("Nợ cần trả nhà cung cấp"),),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: _viewAction("Điều chỉnh", Icons.edit, Colors.green),
                          onTap: () {
                            if (!_checkEmptyData(repository)) {
                              pushPage(
                                  context,
                                  ActionAdjustedScreen(
                                    widget.model.iD,
                                    onUpdateList: (list) {
                                      _repository.updateData(list);
                                    },
                                  ));
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: _viewAction("Lịch sử điều chỉnh", Icons.access_time, Colors.orange),
                          onTap: () {
                            if (!_checkEmptyData(repository)) {
                              pushPage(context,
                                  HistoryAdjustedScreen(widget.model.iD));
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8,),
                  _checkEmptyData(repository)
                      ? EmptyScreen()
                      : ListView.builder(
                          itemCount: _repository.data.providerDebts.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return DebtLogItem(
                              model: _repository.data.providerDebts[index],
                              onClickItem: (itemClick) {
                                pushPage(
                                    context,
                                    DebtLogDetailScreen(
                                        _repository.data.providerDebts[index]));
                              },
                            );
                          },
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _checkEmptyData(DebtLogRepository repository) {
    return _repository.data == null ||
        _repository.data.providerDebts.length == 0;
  }

  Widget _viewAction(String text, IconData icon, MaterialColor colors) {
    return Visibility(
      visible: widget.model.isUpdate || widget.model.isDelete,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        height: 36,
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            Text(" $text",
                style: TextStyle(color: Colors.white)),
          ],
        ),
        decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(64)
        ),
      ),
    );
  }
}
