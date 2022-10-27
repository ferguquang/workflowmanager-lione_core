import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_tab_controller/history/history_group_item.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_tab_controller/history/history_group_repository.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/history/history_repository.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';

class HistoryGroupWidget extends StatefulWidget {
  int taskId;

  HistoryGroupWidget(this.taskId);

  @override
  _HistoryGroupWidgetState createState() => _HistoryGroupWidgetState();
}

class _HistoryGroupWidgetState extends State<HistoryGroupWidget> {
  HistoryGroupRepository repository = HistoryGroupRepository();

  @override
  void initState() {
    super.initState();
    _getListHistory();
  }

  Future<void> _getListHistory() async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDGroupJob'] = widget.taskId;
    repository.getListHistory(params);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return repository;
      },
      child: Consumer(
        builder: (BuildContext context, HistoryGroupRepository repository, Widget child) {
          return repository.list.length == 0 ? EmptyScreen() : ListView.builder(
              itemCount: repository.list.length,
              itemBuilder: (context, index) {
                return HistoryGroupItem(historyModel: repository.list[index]);
              });
        },
      ),
    );
  }
}
