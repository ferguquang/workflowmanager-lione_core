import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/chart/gauge_chart_screen.dart';
import 'package:workflow_manager/base/ui/chart/line_chart_screen.dart';
import 'package:workflow_manager/base/ui/chart/pie_chart_multi_level_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/models/params/group_task_request.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/details/repository/statistic_group_details_repository.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/details/tab_statistic_group_detail_screen.dart';

import '../../filter_statistic_screen.dart';

class StatisticGroupDetailsScreen extends StatefulWidget {
  String titleNav = "";
  int idJobGroup;

  StatisticGroupDetailsScreen({this.titleNav, this.idJobGroup});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StatisticGroupDetailsScreen();
  }
}

class _StatisticGroupDetailsScreen extends State<StatisticGroupDetailsScreen> {
  StatisticGroupDetailsRepository _statisticGroupDetailsRepository =
      StatisticGroupDetailsRepository();

  Chart _childrenStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this
        ._statisticGroupDetailsRepository
        .getDataDetailGroupJobReport(this.widget.idJobGroup);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: this._statisticGroupDetailsRepository,
      child: Consumer(
        builder: (context, StatisticGroupDetailsRepository repository, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(this.widget.titleNav),
            ),
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      this._buildTopView(),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      this._buildAmountChartView(),
                    ],
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  this._buildStatusChartView(),
                ])),
                SliverGrid.count(
                  crossAxisCount: 2,
                  childAspectRatio: 5,
                  children: this._buildActionPieChart(),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  this._buildChildStatisView(),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  this._buildPerformanceChartView(),
                ])),
                TabStatisticGroupDetailScreen(
                  members: this._statisticGroupDetailsRepository.members,
                  listJob: this._statisticGroupDetailsRepository.listJob,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopView() {
    String textFilter = "Lọc/ Tìm kiếm";
    String jobName = "";
    String filterDate = "";
    if (this._statisticGroupDetailsRepository.request.startDate != null) {
      filterDate =
          "${this._statisticGroupDetailsRepository.request.startDate} -";
    }
    if (this._statisticGroupDetailsRepository.request.endDate != null) {
      filterDate = filterDate +
          "${this._statisticGroupDetailsRepository.request.endDate}";
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
                this._statisticGroupDetailsRepository.resetFilter();
                // // Call APIs
                this
                    ._statisticGroupDetailsRepository
                    .getDataDetailGroupJobReport(this.widget.idJobGroup);
              },
              child: Icon(
                Icons.clear_sharp,
                color: "#6C757D".toColor(),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            // height: 60,
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
              "Số lượng công việc".toUpperCase(),
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
                                      ._statisticGroupDetailsRepository
                                      .listDataChartLine ==
                                  null ||
                              this
                                      ._statisticGroupDetailsRepository
                                      .listDataChartLine
                                      .length ==
                                  0
                          ? EmptyScreen()
                          : Container(
                              padding: EdgeInsets.only(left: 8, right: 16),
                              child: LineChartScreen(
                                listDataChartLine: this
                                    ._statisticGroupDetailsRepository
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
          border: Border(
            top: BorderSide(color: Colors.grey[200], width: 4),
            bottom: BorderSide(color: Colors.grey[200], width: 4),
          )),
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
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: this
                            ._statisticGroupDetailsRepository
                            .performanceJobGroupData ==
                        null
                    ? EmptyScreen()
                    : GaugeChartScreen(
                        performanceJobGroupData: this
                            ._statisticGroupDetailsRepository
                            .performanceJobGroupData,
                      ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0, top: 10),
                            child: Text(
                              'Đánh giá: '.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 11),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              this
                                  ._statisticGroupDetailsRepository
                                  .performanceRank,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: "#00689D".toColor()),
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
                                    ._statisticGroupDetailsRepository
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
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionPieChart() {
    List<Widget> _listStatus = [];
    if (this._statisticGroupDetailsRepository.pieChart == null) {
      return _listStatus;
    }
    for (int i = 0;
        i < this._statisticGroupDetailsRepository.pieChart.chart.length;
        i++) {
      Chart _chart = this._statisticGroupDetailsRepository.pieChart.chart[i];
      int _percent = _chart.count == 0
          ? 0
          : ((_chart.count /
                      this
                          ._statisticGroupDetailsRepository
                          .pieChart
                          .totalCount) *
                  100)
              .round();
      _listStatus.add(Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: this._childrenStatus?.label == _chart.label
                    ? Colors.blue
                    : Colors.white,
                width: this._childrenStatus?.label == _chart.label ? 1 : 0,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (this._childrenStatus?.label == _chart.label) {
                    this._childrenStatus = null;
                  } else {
                    this._childrenStatus = _chart;
                  }
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 16)),
                      Icon(
                        Icons.circle,
                        color: _chart.fill.toColor(),
                        size: 10,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        "${_percent}%",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Text(
                    _chart.label,
                    style: TextStyle(fontSize: 12),
                  )),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 15,
                  ),
                  Padding(padding: EdgeInsets.only(right: 16)),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    return _listStatus;
  }

  Widget _buildStatusChartView() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Trạng thái công việc".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: this._statisticGroupDetailsRepository.pieChart == null
                      ? EmptyScreen()
                      : PieChartMultiLevelScreen(
                          pieChart:
                              this._statisticGroupDetailsRepository.pieChart,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChildStatisView() {
    return Visibility(
        visible: this._childrenStatus != null,
        child: Container(
          color: Colors.white,
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: "#DDDDDD".toColor(),
                  width: 1,
                ),
                color: "#F5F6FA".toColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: this._buildContentChildStatusView(),
              ),
            ),
          ),
        ));
  }

  List<Widget> _buildContentChildStatusView() {
    List<Widget> _contents = [];
    if (this._childrenStatus == null) {
      return [];
    }
    for (int i = 0; i < this._childrenStatus.children.length; i++) {
      Children _children = this._childrenStatus.children[i];
      int _percent = 0;
      if (_children.count > 0) {
        _percent =
            ((_children.count / this._childrenStatus.count) * 100).round();
      }
      _contents.add(Expanded(
          child: Container(
        padding: EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "${_percent}%",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
                Icon(
                  Icons.horizontal_rule,
                  size: 25,
                  color: "${_children.fill}".toColor(),
                ),
              ],
            ),
            Text(
              "${_children.label}",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      )));
    }
    return _contents;
  }

  void _showFilter() {
    GroupTaskRequest request = GroupTaskRequest();
    // request.jobGroupName =
    // this._statisticGroupDetailsRepository.request.jobGroupName;
    request.startDate = this._statisticGroupDetailsRepository.request.startDate;
    request.endDate = this._statisticGroupDetailsRepository.request.endDate;
    showModalBottomSheet(
        context: context,
        builder: (context) => FilterStatisticScreen(
              originalRequest: request,
              onFilter: (filter) {
                // Set params
                this._statisticGroupDetailsRepository.request.startDate =
                    filter.startDate;
                this._statisticGroupDetailsRepository.request.endDate =
                    filter.endDate;
                // // Call APIs
                this
                    ._statisticGroupDetailsRepository
                    .getDataDetailGroupJobReport(this.widget.idJobGroup);
              },
            ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }
}
