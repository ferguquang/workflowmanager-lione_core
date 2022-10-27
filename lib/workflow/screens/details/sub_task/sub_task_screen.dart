import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/screens/create_job/create_job_screen.dart';
import 'package:workflow_manager/workflow/screens/details/details_screen_main/task_details_screen.dart';

import 'sub_task_provider.dart';

class SubTaskScreen extends StatefulWidget {
  int _taskId; // id cv
  int taskType;

  // iD nhóm CV, ID column kanban, id cv cha
  int sIDJobGroup, sIDJobGroupCol, sIDParent;

  SubTaskScreen(this._taskId, this.taskType, this.sIDJobGroup,
      this.sIDJobGroupCol, this.sIDParent);

  @override
  State<StatefulWidget> createState() {
    return _SubTaskScreenState();
  }
}

class _SubTaskScreenState extends State<SubTaskScreen> {
  SubTabProvider _subTabProvider = SubTabProvider();

  @override
  void initState() {
    super.initState();
    reloadData();
  }

  reloadData() {
    _subTabProvider.loadById(widget._taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Công việc con"),
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (build) {
                return CreateJobScreen(true, widget.sIDJobGroup,
                    widget.sIDJobGroupCol, widget._taskId, 0);
              }));
              // showToastNormal("Tạo công việc con");
              reloadData();
            },
            child: Visibility(
                visible: (widget.taskType == 1 ||
                    widget.taskType == 2), // 1: CV Được giao, 2: CV Đã giao
                child: Container(
                    margin: EdgeInsets.all(6), child: Icon(Icons.add))),
          )
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: _subTabProvider,
        child: Consumer(
          builder: (context, SubTabProvider subTabProvider, child) {
            return Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                        child: subTabProvider.subTasks.length == 0
                            ? EmptyScreen()
                            : ListView.builder(
                                itemCount: subTabProvider.subTasks.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    child: _itemSubTask(subTabProvider, index),
                                    onTap: () {
                                      if (isNotNullOrEmpty(subTabProvider
                                              ?.subTasks[index]?.job) ||
                                          isNotNullOrEmpty(subTabProvider
                                              ?.subTasks[index]?.job?.iD)) {
                                        pushPage(
                                            context,
                                            TaskDetailsScreen(
                                                subTabProvider
                                                    ?.subTasks[index]?.job?.iD,
                                                null));
                                      }
                                    },
                                  );
                                },
                              ))
                  ],
                ));
          },
        ),
      ),
    );
  }

  Widget _itemSubTask(SubTabProvider subTabProvider, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 3),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                    color: "D9EFFA".toColor(),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text("${index + 1}"),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        subTabProvider?.subTasks[index]?.job?.name ?? "--",
                        style:
                            TextStyle(fontSize: 16, color: getColor('#00689D')),
                      ),
                    ),
                    _buildRow("Độ ưu tiên", "",
                        contentWidget: _getPriorityText(
                            subTabProvider.subTasks[index].priorityAPI.key)),
                    _buildRow(
                        "Ngày kết thúc",
                        subTabProvider?.subTasks[index]?.job?.endDate
                                ?.toDateFormat() ??
                            ""),
                    _buildRow("Người giao",
                        subTabProvider?.subTasks[index]?.assigner ?? ""),
                    _buildRow("Người nhận",
                        subTabProvider?.subTasks[index]?.executer ?? ""),
                    // _buildRow("Người giám sát",
                    //     subTabProvider?.subTasks[index]?.supervisor ?? ""),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRow(String label, String content, {Widget contentWidget}) {
    return Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            Text(label + ": "),
            contentWidget ??
                Text(
                  content,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
          ],
        ));
  }

  Widget _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return Text("Thấp");
      case 2:
        return Text("Trung bình");
      default:
        return Text("Cao", style: TextStyle(color: Colors.red.withAlpha(180)));
    }
  }
}
