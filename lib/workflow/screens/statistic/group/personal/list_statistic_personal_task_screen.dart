import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_personal_response.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/personal/cells/report_performance_cell.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/personal/repository/list_statistic_personal_task_repository.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';

class ListStatisticPersonalTaskScreen extends StatefulWidget {
  int idJobGroup;

  ListStatisticPersonalTaskScreen({this.idJobGroup});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListStatisticPersonalTaskScreen();
  }
}

class _ListStatisticPersonalTaskScreen
    extends State<ListStatisticPersonalTaskScreen>
    with AutomaticKeepAliveClientMixin {

  ListStatisticPersonalTaskRepository _listStatisticGroupTaskRepository = ListStatisticPersonalTaskRepository();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._listStatisticGroupTaskRepository.getDataForListGroupJob(
        this.widget.idJobGroup);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: this._listStatisticGroupTaskRepository,
      child: Consumer(
        builder: (context, ListStatisticPersonalTaskRepository repository, _) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  this._buildTopView(),
                  this._buildTopListView(),
                  Expanded(
                    child: this._buildListView(repository.dataGroupJobs),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
          FlatButton(onPressed: () {}, child: Icon(Icons.more_vert)),
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
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Tên công việc',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                'Đánh giá',
                style: TextStyle(fontSize: 12),
              )),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              'Hiệu suất',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(data) {
    return data?.length == 0
        ? EmptyScreen()
        : ListView.separated(
      itemCount: data?.length,
      itemBuilder: (context, index) {
        DataGroupJobPersonal _item = data[index];
        return InkWell(
          child: ReportPerformanceCell(item: _item,),
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

}
