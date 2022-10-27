import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/ui/text_action.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/event/create_group_event.dart';
import 'package:workflow_manager/workflow/models/params/group_task_request.dart';
import 'package:workflow_manager/workflow/models/response/list_group_task_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/change_status/change_status_dialog.dart';
import 'package:workflow_manager/workflow/screens/group_job/event/event_group_task.dart';
import 'package:workflow_manager/workflow/screens/group_job/filter/filter_group_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/repository/group_task_repository.dart';

import 'group_task_item.dart';
import 'list_column_group_tab_screen.dart';

class ListGroupTaskWidget extends StatefulWidget {
  int status;
  List<StatusGroup> statusGroups;
  List<StatusGroup> statusGroupsFilter = [];

  ListGroupTaskWidget({@required this.status, this.statusGroups});

  @override
  State<StatefulWidget> createState() {
    return _ListGroupTaskWidgetState();
  }
}

class _ListGroupTaskWidgetState extends State<ListGroupTaskWidget> {
  GroupTaskRepository groupTaskRepository = GroupTaskRepository();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<GroupTask> listGroup = [];

  @override
  void initState() {
    super.initState();
    _getListGroup();
    groupTaskRepository.getListStatusChange(widget.status);
    eventBus.on<EventSelectGroup>().listen((event) {
      if (listGroup.length == 0) {
        groupTaskRepository.updateShowFunction(false);
      } else {
        groupTaskRepository.updateShowFunction(true);
      }
    });

    eventBus.on<CreateGroupEvent>().listen((event) {
      if (widget.status == event.status) {
        groupTaskRepository.pullToRefreshData();
        _getListGroup();
      }
    });
  }

  void _getListGroup() async {
    groupTaskRepository.groupTaskRequest.status = widget.status;
    groupTaskRepository.getListGroup();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return groupTaskRepository;
      },
      child: Consumer<GroupTaskRepository>(builder:
          (BuildContext context, GroupTaskRepository repository, Widget child) {
        widget.statusGroupsFilter = repository.statusFilter;
        listGroup = repository.list;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Tổng số nhóm công việc: ',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        "${repository?.totalJobGroup ?? ''}",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: SVGImage(
                              svgName: 'ic_filter',
                              onTap: () {
                                pushPage(
                                    context,
                                    FilterGroupScreen(
                                        originalRequest: groupTaskRepository
                                            .groupTaskRequest,
                                        onFilter: (GroupTaskRequest
                                            groupTaskRequest) {
                                          groupTaskRepository.groupTaskRequest =
                                              groupTaskRequest;
                                          groupTaskRepository
                                              .pullToRefreshData();
                                          groupTaskRepository.getListGroup();
                                        }));
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                Expanded(
                    child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                      } else if (mode == LoadStatus.canLoading) {
                      } else {}
                      return Container(
                        height: 55.0,
                        child: Center(
                          child: body,
                        ),
                      );
                    },
                  ),
                  onRefresh: () {
                    _refreshController.refreshCompleted();
                    groupTaskRepository.pullToRefreshData();
                    _getListGroup();
                  },
                  onLoading: () {
                    _refreshController.loadComplete();
                    _getListGroup();
                  },
                  child: this._buildListViewGroupJob(repository.list),
                )),
                Visibility(
                  visible: repository.getShowFunction(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Expanded(
                          child: TextAction(
                            title: 'Hủy chọn',
                            onTap: () {
                              groupTaskRepository.updateShowFunction(false);
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.status != 5,
                          child: TextAction(
                              onTap: () {
                                List<GroupTask> listSelected = [];
                                for (int i = 0;
                                    i < repository.list.length;
                                    i++) {
                                  if (repository.list[i].isSelected) {
                                    listSelected.add(repository.list[i]);
                                  }
                                }

                                String idSelecteds = listSelected
                                    .map((e) => e.iD)
                                    .toList()
                                    .toString();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ChangeStatusDialog(
                                        statusGroups: widget.statusGroupsFilter,
                                        idSelecteds: idSelecteds,
                                        onAccept: (int idStatusSelected,
                                            String idSelects) {
                                          groupTaskRepository
                                              .changeStatusForList(
                                                  idSelects, idStatusSelected);
                                          groupTaskRepository
                                              .updateShowFunction(false);
                                        },
                                      );
                                    });
                              },
                              fontSize: 16,
                              color: Colors.blue,
                              title: 'Chuyển trạng thái   '),
                        ),
                        TextAction(
                            onTap: () {
                              ConfirmDialogFunction(
                                  context: context,
                                  content:
                                      'Bạn có muốn xóa những nhóm này không?',
                                  onAccept: () {
                                    List<GroupTask> listSelected = [];
                                    for (int i = 0;
                                        i < repository.list.length;
                                        i++) {
                                      if (repository.list[i].isSelected) {
                                        listSelected.add(repository.list[i]);
                                      }
                                    }

                                    String idSelecteds = listSelected
                                        .map((e) => e.iD)
                                        .toList()
                                        .toString();
                                    groupTaskRepository.deleteGroupTask(
                                        idSelecteds, listSelected);
                                    groupTaskRepository
                                        .updateShowFunction(false);
                                  }).showConfirmDialog();
                            },
                            fontSize: 16,
                            color: Colors.blue,
                            title: '   Xóa')
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildListViewGroupJob(List<GroupTask> list) {
    return list?.length == 0
        ? EmptyScreen()
        : ListView.separated(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: GroupTaskItem(
                  groupTask: list[index],
                  position: index,
                  onUpdate: (GroupTask groupTask, int position) {
                    groupTaskRepository.updateSelected(groupTask, position);
                  },
                ),
                onTap: () {
                  pushPage(
                      context,
                      ListColumnGroupTabScreen(
                          idGroup: list[index].iD,
                          nameGroupJob: list[index].name));
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          );
  }
}
