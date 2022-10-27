import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/event/refresh_list_task_event.dart';
import 'package:workflow_manager/workflow/models/event/view_mode_event.dart';
import 'package:workflow_manager/workflow/models/response/list_task_model_response.dart';
import 'package:workflow_manager/workflow/screens/details/details_screen_main/task_details_screen.dart';
import 'package:workflow_manager/workflow/screens/details/task_details_screen_head/task_details_screen_head.dart';
import 'package:workflow_manager/workflow/screens/tasks/cells/task_cell.dart';
import 'package:workflow_manager/workflow/screens/tasks/filter_task_screen.dart';
import 'package:workflow_manager/workflow/screens/tasks/repository/list_task_repository.dart';

import '../../../main.dart';

// ignore: must_be_immutable
// Hiển thị danh sách công việc
class ListTasksScreen extends StatefulWidget {
  int viewType;

  int idStatus;
  bool isNeedToRefresh = false;

  ListTasksScreen({this.viewType, this.idStatus}) : super(key: GlobalKey()) {
    if ((key as GlobalKey).currentState != null)
      ((key as GlobalKey).currentState as _ListTasksTabItemScreen)
          ._reloadData();
  }

  @override
  State<StatefulWidget> createState() {
    return _ListTasksTabItemScreen();
  }
}

class _ListTasksTabItemScreen extends State<ListTasksScreen>
    with AutomaticKeepAliveClientMixin {
  ListTaskRepository _listTaskRepository = ListTaskRepository();

  _ListTasksTabItemScreen();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  searchTask(String text) {
    _listTaskRepository.request.jobName = text;
    _listTaskRepository.request.isDeadLine = AppStore.isViewDeadLine;
    _listTaskRepository.page = 1;
    _listTaskRepository.getListTaskIndex();
  }

  @override
  bool get wantKeepAlive => true;

  void _reloadData() {
    _listTaskRepository.pullToRefreshData();
    _getListTask();
  }

  Future<void> _getListTask() async {
    _listTaskRepository.request.viewType = this.widget.viewType;
    _listTaskRepository.request.isDeadLine = AppStore.isViewDeadLine;
    if (AppStore.isViewDeadLine == 0) {
      _listTaskRepository.request.idStatus = this.widget.idStatus;
    } else {
      _listTaskRepository.request.typeDeadLine = this.widget.idStatus;
    }
    _listTaskRepository.getListTaskIndex();
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
    _listTaskRepository.pullToRefreshData();
    _getListTask();
  }

  void _onLoadMore() async {
    _refreshController.loadComplete();
    _getListTask();
  }

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _listTaskRepository,
      child: Consumer(
        builder: (context, ListTaskRepository repository, _) {
          return SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  // this._buildSearchView(),
                  this._buildCountTaskView(repository.taskData.jobCount),
                  Expanded(
                    child: SmartRefresher(
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
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoadMore,
                      child: this._buildListView(repository.arrayTask),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCountTaskView(taskCount) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 16, bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]),
        ),
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Text(
              'Tổng số công việc: ',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              "${this._listTaskRepository?.totalCount}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.filter_list),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FilterTaskScreen(
                                viewType: this.widget.viewType,
                                originRequest: this._listTaskRepository.request,
                                onDoneFilter: (result) {
                                  this._listTaskRepository.request = result;
                                  _onRefresh();
                                },
                              )),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListView(data) {
    return data?.length == 0
        ? EmptyScreen()
        : ListView.separated(
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) {
              TaskIndexItem _item = data[index];
              return InkWell(
                child: TaskCell(
                  item: _item,
                  viewType: this.widget.viewType,
                  onStatusChanged: () {
                    // this._getListStatus(_item);
                  },
                ),
                onTap: () async {
                  var result = await pushPage(
                      context,
                      TaskDetailsScreen(
                        _item.jobID,
                        widget.viewType,
                        didDeleteTask: (id) {
                          this._listTaskRepository.deleteTaskInList(id);
                        },
                      ));
                  if (result == true) {
                    eventBus.fire(OnJobStatusChanged(widget.viewType));
                  }
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
  }
}
