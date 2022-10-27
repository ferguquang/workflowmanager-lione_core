import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';

import '../back_detail_data.dart';
import 'todo_work_provider.dart';

class ToDoWorkScreen extends StatefulWidget {
  int taskId;
  int taskType;

  ToDoWorkScreen(this.taskId, this.taskType);

  @override
  State<StatefulWidget> createState() {
    return _ToDoWorkScreenState();
  }
}

class _ToDoWorkScreenState extends State<ToDoWorkScreen> {
  TextEditingController _controller = TextEditingController();
  ToDoWorkProvider _toDoWorkProvider = ToDoWorkProvider();

  @override
  void initState() {
    super.initState();
    _toDoWorkProvider.loadById(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context,
              BackDetailData(totalTodo: _toDoWorkProvider.toDoList.length));
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Công việc cần làm"),
              actions: [
                Visibility(
                    visible: widget.taskType == 1,
                    child: InkWell(
                      onTap: () {
                        _toDoWorkProvider.showEdit();
                      },
                      child: Container(
                          margin: EdgeInsets.all(10), child: Icon(Icons.add)),
                    ))
              ],
            ),
            body: Padding(
                padding: EdgeInsets.all(10),
                child: ChangeNotifierProvider.value(
                    value: _toDoWorkProvider,
                    child: Consumer(builder:
                        (context, ToDoWorkProvider toDoWorkProvider, child) {
                      _toDoWorkProvider = toDoWorkProvider;
                      return Column(children: [
                        Visibility(
                          visible: toDoWorkProvider.isShowEdit,
                          child: Container(
                              margin: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: TextField(
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        controller: _controller,
                                        decoration: InputDecoration(
                                          suffixIcon: Visibility(
                                              visible:
                                                  _controller.text.length > 0,
                                              child: IconButton(
                                                  onPressed: () async {
                                                    if (isNotNullOrEmpty(
                                                        _controller.text)) {
                                                      await toDoWorkProvider
                                                          .add(_controller.text,
                                                              widget.taskId);
                                                      _toDoWorkProvider
                                                          .hideEdit();
                                                      _controller.text = "";
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.blue,
                                                  ))),
                                          hintText: "Nhập tên công việc",
                                          border: OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.blue,
                                                  width: 3)),
                                        )),
                                  ))
                                ],
                              )),
                        ),
                        Flexible(
                            fit: FlexFit.loose,
                            child: toDoWorkProvider.toDoList.length == 0
                                ? EmptyScreen()
                                : ListView.builder(
                                    itemCount: toDoWorkProvider.toDoList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(6),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: "F5F6FA".toColor(),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7))),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Visibility(
                                              visible: widget.taskType == 1,
                                              child: Checkbox(
                                                value: toDoWorkProvider
                                                    .toDoList[index].isComplete,
                                                onChanged: (value) {
                                                  if (value) {
                                                    toDoWorkProvider
                                                        .completeById(
                                                            toDoWorkProvider
                                                                .toDoList[index]
                                                                .iD);
                                                  } else {
                                                    toDoWorkProvider
                                                        .uncompleteById(
                                                            toDoWorkProvider
                                                                .toDoList[index]
                                                                .iD);
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
                                                child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                              child: Text(
                                                toDoWorkProvider
                                                    .toDoList[index].name,
                                                style: TextStyle(
                                                    color: "00689D".toColor(),
                                                    decoration: toDoWorkProvider
                                                            .toDoList[index]
                                                            .isComplete
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none),
                                              ),
                                            )),
                                            Visibility(
                                                visible: widget.taskType == 1 && !toDoWorkProvider
                                                    .toDoList[index].isComplete,
                                                child: InkWell(
                                                    onTap: () {
                                                      toDoWorkProvider
                                                          .deleteById(
                                                              toDoWorkProvider
                                                                  .toDoList[
                                                                      index]
                                                                  .iD);
                                                    },
                                                    child: Icon(Icons.close)))
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                      ]);
                    })))));
  }
}
