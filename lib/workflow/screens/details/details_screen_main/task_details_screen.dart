import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/ui/widget_screen_mixin.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/manager/auth/auth_repository.dart';
import 'package:workflow_manager/workflow/screens/create_job/create_job_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/tab_controller.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/screens/details/details_screen_main/task_details_screen_provider.dart';
import 'package:workflow_manager/workflow/screens/details/task_details_screen_head/task_details_screen_head.dart';

import '../../../../main.dart';

class TaskDetailsScreen extends StatefulWidget {
  int taskId;
  int typeTask;
  Function _reload;

  reloadData() {
    if (_reload != null) {
      _reload();
    }
  }

  final void Function(int) didDeleteTask;

  TaskDetailsScreen(this.taskId, this.typeTask, {this.didDeleteTask});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen>
    with SingleTickerProviderStateMixin {
  TaskDetailsScreenProvider _taskDetailsScreenProvider =
      TaskDetailsScreenProvider();
  bool isDataChanged = false;
  bool isVisible = false;

  reloadData() async {
    await _taskDetailsScreenProvider.loadById(widget.taskId, widget.typeTask);
    widget.typeTask = _taskDetailsScreenProvider.taskDetailModel.viewType;
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<NotiData>().listen((event) {
      if (isVisible) {
        Navigator.pop(context);
      }
      pushPage(context, TaskDetailsScreen(event.id, null));
    });
    widget._reload = reloadData;
    reloadData();
  }

  Widget _buildMenu(IconData icon, String text) {
    return Row(children: [
      Container(
          alignment: Alignment.centerLeft,
          width: 25,
          height: 25,
          margin: EdgeInsets.only(right: 8),
          child: Icon(
            icon,
            color: Colors.grey,
          )),
      Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      )
    ]);
  }

  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("taskdetail"),
      onVisibilityChanged: (info) {
        isVisible = info.visibleFraction == 1;
      },
      child: ChangeNotifierProvider.value(
          value: _taskDetailsScreenProvider,
          child: Consumer(
            builder: (context,
                TaskDetailsScreenProvider taskDetailsScreenProvider, child) {
              return WillPopScope(
                onWillPop: () {
                  Navigator.pop(context, isDataChanged);
                  return Future.value(false);
                },
                child: Scaffold(
                  key: _key,
                  appBar: AppBar(
                    title: Text(
                      "Chi tiết công việc",
                    ),
                    actions: [
                      Visibility(
                        visible: widget.typeTask == 2,
                        child: PopupMenuButton(
                          padding: EdgeInsets.all(0),
                          offset: Offset(0, 20),
                          child: Container(child: Icon(Icons.more_vert)),
                          onSelected: (value) async {
                            if (value == 0) {
                              // chỉnh sửa công viêc
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (build) {
                                return CreateJobScreen(
                                    false, 0, 0, 0, widget.taskId);
                              }));
                              isDataChanged = true;
                              reloadData();
                            }
                            if (value == 2) {
                              // thực hiện hành động xoá
                              this._showConfirmDialog(this.widget.taskId);
                            }
                          },
                          itemBuilder: (context) {
                            return this._listPopupMenu();
                          },
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            AuthRepository.logout();
                          },
                          child: Text("fff"))
                    ],
                  ),
                  body: SafeArea(
                      child: taskDetailsScreenProvider.taskDetailModel == null
                          ? EmptyScreen()
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanDown: (_) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildListDelegate([
                                      TaskDetailsHeader(
                                        taskDetailsScreenProvider
                                            .taskDetailModel,
                                        onDataChanged: () {
                                          isDataChanged = true;
                                        },
                                      )
                                    ]),
                                  ),
                                  TaskDetailTabController(widget.taskId)
                                ],
                              ),
                            )),
                ),
              );
            },
          )),
    );
  }

  List<PopupMenuItem> _listPopupMenu() {
    List<PopupMenuItem> listMenu = [];
    if (this._taskDetailsScreenProvider.taskDetailModel.isEdit) {
      listMenu.add(PopupMenuItem(
        value: 0,
        child: _buildMenu(Icons.edit, "Chỉnh sửa"),
      ));
    }
    if (this._taskDetailsScreenProvider.taskDetailModel.isDelete) {
      listMenu.add(
        PopupMenuItem(
          value: 2,
          child: _buildMenu(Icons.delete, "Xóa"),
        ),
      );
    }

    return listMenu;
  }

  void _showConfirmDialog(int taskID) {
    ConfirmDialogFunction(
      context: context,
      content: "Bạn có muốn xóa công việc này không?",
      onAccept: () async {
        bool isSuccess = await _taskDetailsScreenProvider.deleteJobById(taskID);
        if (isSuccess) {
          Navigator.pop(context);
        }
      },
    ).showConfirmDialog();
  }

  @override
  void dispose() {
    super.dispose();
    removeScreenName(widget);
  }
}

class TaskDetailParams {
  int jobID;
  int viewType;
  void Function(int) didDeleteTask;

  TaskDetailParams({this.jobID, this.viewType, this.didDeleteTask});
}