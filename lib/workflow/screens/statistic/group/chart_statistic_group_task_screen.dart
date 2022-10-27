import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/chart/gauge_chart_screen.dart';
import 'package:workflow_manager/base/ui/chart/line_chart_screen.dart';
import 'package:workflow_manager/base/ui/chart/pie_chart_screen.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/models/params/group_task_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_response.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/details/statistic_group_details_screen.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/repository/chart_statistic_group_task_repository.dart';

import '../filter_statistic_screen.dart';
import 'cells/statistic_group_task_cell.dart';

class ChartStatisticGroupTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChartStatisticGroupTaskScreen();
  }
}

class _ChartStatisticGroupTaskScreen
    extends State<ChartStatisticGroupTaskScreen>
    with AutomaticKeepAliveClientMixin {
  ChartStatisticGroupTaskRepository _chartStatisticGroupTaskRepository =
      new ChartStatisticGroupTaskRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getListTask();
    this._chartStatisticGroupTaskRepository.getDataGroupJobReport();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: this._chartStatisticGroupTaskRepository,
      child: Consumer(
        builder: (context, ChartStatisticGroupTaskRepository repository, _) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    this._buildTopView(),
                    this._buildAmountChartView(),
                    this._buildStatusChartView(),
                    this._buildPerformanceChartView(),
                    this._buildTopListView(),
                    this._buildListView(repository.listGroupJob),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopView() {
    String textFilter = "Lọc/ Tìm kiếm nhóm công việc";
    String filterDate = "";
    if (this._chartStatisticGroupTaskRepository.request.startDate != null) {
      filterDate =
          "${this._chartStatisticGroupTaskRepository.request.startDate} -";
    }
    if (this._chartStatisticGroupTaskRepository.request.endDate != null) {
      filterDate = filterDate +
          "${this._chartStatisticGroupTaskRepository.request.endDate}";
    }
    if (filterDate.length > 0) {
      textFilter = "${filterDate}";
    }
    return Container(
      color: "#F5F6FA".toColor(),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                textFilter,
                style: TextStyle(fontSize: 14, color: "#555555".toColor()),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: FlatButton(
              onPressed: () {
                this._chartStatisticGroupTaskRepository.resetFilter();
                this._chartStatisticGroupTaskRepository.getDataGroupJobReport();
                this._getListTask();
              },
              child: Icon(
                Icons.clear_sharp,
                color: "#6C757D".toColor(),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: FlatButton(
                onPressed: () {
                  this._showFilter();
                },
                child: Image.asset('assets/images/ic-filter.png')),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChartView() {
    return Container(
      padding: EdgeInsets.only(right: 16),
      // color: Colors.white,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Colors.grey[200], width: 4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Số lượng công việc nhóm".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    "Số lượng công việc",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return this
                                      ._chartStatisticGroupTaskRepository
                                      .listDataChartLine ==
                                  null ||
                              this
                                      ._chartStatisticGroupTaskRepository
                                      .listDataChartLine
                                      .length ==
                                  0
                          ? EmptyScreen()
                          : Container(
                              padding: EdgeInsets.only(left: 8, right: 16),
                              child: LineChartScreen(
                                listDataChartLine: this
                                    ._chartStatisticGroupTaskRepository
                                    .listDataChartLine,
                              ),
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChartView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Colors.grey[200], width: 4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Hiệu suất".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                child: this
                            ._chartStatisticGroupTaskRepository
                            .performanceJobGroupData ==
                        null
                    ? EmptyScreen()
                    : GaugeChartScreen(
                        performanceJobGroupData: this
                            ._chartStatisticGroupTaskRepository
                            .performanceJobGroupData,
                      ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0, top: 10),
                            child: Text(
                              'Đánh giá: '.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                              width: 90,
                              child: Text(
                                this
                                    ._chartStatisticGroupTaskRepository
                                    .performanceRank,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: "#00689D".toColor()),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 0, top: 0, bottom: 0),
                            child: Container(
                              width: 100,
                              height: 50,
                              child: RatingBar.builder(
                                itemSize: 20,
                                initialRating: this
                                    ._chartStatisticGroupTaskRepository
                                    .rateNumber,
                                itemCount: 5,
                                itemPadding: EdgeInsets.all(0),
                                direction: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChartView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Colors.grey[200], width: 4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Trạng thái nhóm công việc".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            height: 200,
            child: this._chartStatisticGroupTaskRepository.pieChart == null
                ? EmptyScreen()
                : PieChartScreen(
                    pieChart: this._chartStatisticGroupTaskRepository.pieChart,
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildTopListView() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: "#E9ECEF".toColor(),
          border:
              Border(bottom: BorderSide(color: "#DDDDDD".toColor(), width: 1))),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
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
              'Đánh giá',
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
            primary: false,
            shrinkWrap: true,
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) {
              DataGroupJobItem _item = data[index];
              return InkWell(
                child: StatisticGroupTaskCell(
                  item: _item,
                ),
                onTap: () {
                  print("${_item.id}");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StatisticGroupDetailsScreen(
                            titleNav: _item.jobGroupName,
                            idJobGroup: _item.id,
                          )));
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
    this._chartStatisticGroupTaskRepository.getDataForListGroupJob();
  }

  void _showFilter() {
    GroupTaskRequest request = GroupTaskRequest();
    request.jobGroupName =
        this._chartStatisticGroupTaskRepository.request.jobGroupName;
    request.startDate =
        this._chartStatisticGroupTaskRepository.request.startDate;
    request.endDate = this._chartStatisticGroupTaskRepository.request.endDate;
    showModalBottomSheet(
        context: context,
        builder: (context) => FilterStatisticScreen(
              originalRequest: request,
              onFilter: (filter) {
                // Set params
                this._chartStatisticGroupTaskRepository.request.jobGroupName =
                    filter.jobGroupName;
                this._chartStatisticGroupTaskRepository.request.startDate =
                    filter.startDate;
                this._chartStatisticGroupTaskRepository.request.endDate =
                    filter.endDate;
                this._chartStatisticGroupTaskRepository.request.idJobGroup =
                    filter.idJobGroup;
                // Call APIs
                this._chartStatisticGroupTaskRepository.getDataGroupJobReport();
                this._getListTask();
              },
            ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }
}
