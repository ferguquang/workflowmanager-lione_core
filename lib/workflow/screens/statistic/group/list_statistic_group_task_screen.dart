import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_response.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/cells/statistic_group_task_cell.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/manager/main_statistic_manager_task_screen.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/personal/main_statistic_personal_task_screen.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/repository/list_statistic_group_task_repository.dart';

class ListStatisticGroupTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListStatisticGroupTaskScreen();
  }
}

class _ListStatisticGroupTaskScreen extends State<ListStatisticGroupTaskScreen>
    with AutomaticKeepAliveClientMixin {
  ListStatisticGroupTaskRepository _listStatisticGroupTaskRepository =
      ListStatisticGroupTaskRepository();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getListTask();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: this._listStatisticGroupTaskRepository,
      child: Consumer(
        builder: (context, ListStatisticGroupTaskRepository repository, _) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  this._buildTopView(),
                  this._buildTopListView(),
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
                      controller: this._refreshController,
                      onRefresh: this._onRefresh,
                      onLoading: this._onLoading,
                      child: this._buildListView(repository.listGroupJob),
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

  // UIs
  Widget _buildTopView() {
    return Container(
      color: "#F5F6FA".toColor(),
      height: 32,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: <Widget>[
                  Text(
                    'Trạng thái: ',
                    style: TextStyle(fontSize: 14, color: "#555555".toColor()),
                  ),
                  Text(
                    'Chưa hoạt động',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: "#555555".toColor()),
                  ),
                ],
              ),
            ),
          ),
          // FlatButton(onPressed: () {}, child: Icon(Icons.more_vert)),
        ],
      ),
    );
  }

  Widget _buildTopListView() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: "#DDDDDD".toColor(), width: 1))),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                'Tên nhóm',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                'Thành viên',
                style: TextStyle(fontSize: 12),
              )),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              'Hiệu suất',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Tổng số công việc',
                  style: TextStyle(fontSize: 12),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildListView(data) {
    return data?.length == 0
        ? EmptyScreen()
        : ListView.separated(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) {
        DataGroupJobItem _item = data[index];
        return InkWell(
          child: StatisticGroupTaskCell(
            item: _item,
          ),
          onTap: () {
            print("${_item.id}");
                  if (_item.isManager) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MainStatisticManagerTaskScreen(
                              idJobGroup: _item.id,
                            )));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MainStatisticPersonalTaskScreen(
                              idJobGroup: _item.id,
                            )));
                  }
                },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // Handle data
  Future<void> _getListTask() async {
    this._listStatisticGroupTaskRepository.getDataForListGroupJob();
  }

  void _onRefresh() async {
    this._refreshController.refreshCompleted();
    this._listStatisticGroupTaskRepository.pageIndex = 1;
    // this._listStatisticGroupTaskRepository.pullToRefreshData();
    this._getListTask();
  }

  void _onLoading() async {
    this._refreshController.loadComplete();
    this._getListTask();
  }
}
