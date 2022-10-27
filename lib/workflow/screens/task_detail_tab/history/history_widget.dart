import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/history/history_repository.dart';

import 'history_item.dart';

class HistoryWidget extends StatefulWidget {
  int taskId;

  HistoryWidget(this.taskId);

  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  HistoryRepository repository = HistoryRepository();

  @override
  void initState() {
    super.initState();
    _getListHistory();
  }

  Future<void> _getListHistory() async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDJob'] = widget.taskId;
    repository.getListHistory(params);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return repository;
      },
        child: Consumer(
          builder: (BuildContext context, HistoryRepository repository, Widget child) {
            return repository.list.length == 0 ? EmptyScreen() : ListView.builder(
                itemCount: repository.list.length,
                itemBuilder: (context, index) {
                  return HistoryItem(historyModel: repository.list[index]);
                });
          },
        ),
    );
  }
}
