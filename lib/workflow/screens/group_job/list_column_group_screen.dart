import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/event/open_filter_task_group_event.dart';
import 'package:workflow_manager/workflow/models/response/list_task_model_response.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/screens/details/details_screen_main/task_details_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/repository/column_group_repository.dart';

import '../../../main.dart';
import 'filter/filter_cloumn_group_screen.dart';

// ignore: must_be_immutable
// Hiển thị danh sách công việc
class ListColumnGroupScreen extends StatefulWidget {
  int idGroup;
  int idGroupCol;
  int idStatus;

  ListColumnGroupScreen({this.idGroup, this.idGroupCol, this.idStatus});

  @override
  State<StatefulWidget> createState() {
    return _ListColumnGroupScreenState();
  }
}

class _ListColumnGroupScreenState extends State<ListColumnGroupScreen>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  ColumnGroupRepository _listTaskRepository = ColumnGroupRepository();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getListTaskGroup();

    if (loginSubscription != null) {
      loginSubscription.cancel();
    }
    loginSubscription = eventBus.on<OpenFilterTaskGroupEvent>().listen((event) {
      this.openFilterScreen();
    });

    eventBus.on<ReloadEventBus>().listen((event) {
      _onRefresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openFilterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FilterColumnGroupScreen(
                idGroupJob: widget.idGroup,
                originRequest: this._listTaskRepository.request,
                onDoneFilter: (result) {
                  this._listTaskRepository.request = result;
                  this._onRefresh();
                },
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _listTaskRepository,
      child: Consumer(
        builder: (context, ColumnGroupRepository repository, _) {
          return Scaffold(
              key: _key,
              body: SafeArea(
                child: Container(
                  child: Column(
                    children: <Widget>[
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
                          onLoading: _onLoading,
                          child: this._buildListView(repository.arrayTaskGroup),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
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
                child: _taskCellItem(_item),
                onTap: () {
                  pushPage(context, TaskDetailsScreen(_item.jobID, null));
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
  }

  Widget _taskCellItem(TaskIndexItem item) {
    String endDate = "";
    if (item.endDate != null) {
      endDate =
          '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item.endDate))}';
    } else {
      endDate = '--';
    }
    String createdName = "";
    createdName = item?.executeName ?? "--";

    String priority = "";
    String priorityColor = "";
    if (item.priority != null) {
      priority = item.priority.priorityName;
      priorityColor = item.priority.color;
    }
    return Row(
      children: [
        Container(
            alignment: Alignment.topCenter,
            width: 70,
            height: 70,
            child: CircularPercentIndicator(
              radius: 30.0,
              lineWidth: 2.0,
              animation: true,
              progressColor: item.colorPercentCompleted.toColor(),
              percent: double.parse(
                  (item.percentCompleted / 100.0).toStringAsFixed(2)),
              center: new Text(
                "${item.percentCompleted.toStringAsFixed(0)}",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 9.0),
              ),
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.jobName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/images/ic-clock.png'),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          endDate,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/images/ic-person.png'),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          createdName,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/images/ic-priority.png'),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          priority,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: priorityColor.toColor()),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getListTaskGroup() async {
    if (isNotNullOrEmpty(this.widget.idStatus)) {
      UserItem idStatus = UserItem();
      idStatus.iD = this.widget.idStatus;
      _listTaskRepository.request.idStatus = idStatus;
    }

    _listTaskRepository.request.idJobGroup = this.widget.idGroup;
    _listTaskRepository.request.idGroupJobCol = this.widget.idGroupCol;
    _listTaskRepository.getListColumnGroup();
  }

  _onRefresh() async {
    _refreshController.refreshCompleted();
    _listTaskRepository.pullToRefreshData();
    _listTaskRepository.request.pageIndex = 1;
    _getListTaskGroup();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
    _getListTaskGroup();
  }
}

class ReloadEventBus {
  ReloadEventBus();
}
