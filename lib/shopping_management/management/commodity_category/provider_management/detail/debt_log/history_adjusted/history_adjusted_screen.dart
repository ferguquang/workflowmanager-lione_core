import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/history_adjusted/history_adjusted_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/history_adjusted/history_adjusted_repository.dart';

class HistoryAdjustedScreen extends StatefulWidget {
  int id;

  HistoryAdjustedScreen(this.id);

  @override
  _HistoryAdjustedScreenState createState() => _HistoryAdjustedScreenState();
}

class _HistoryAdjustedScreenState extends State<HistoryAdjustedScreen> {
  HistoryAdjustedRepository _repository = HistoryAdjustedRepository();

  @override
  void initState() {
    super.initState();
    _repository.getProviderViewDebtLog(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, HistoryAdjustedRepository repository, Widget child) {
          return Scaffold(
            appBar: AppBar(title: Text("Lịch sử điều chỉnh"),),
            body: SafeArea(
              child: repository.data == null ? EmptyScreen() : ListView.builder(
                itemCount: repository.data.providerDebtLogs.length,
                itemBuilder: (BuildContext context, int index) {
                  return HistoryAdjustedItem(repository.data.providerDebtLogs[index], index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
