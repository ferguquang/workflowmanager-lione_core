import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/chart/gauge_chart_screen.dart';
import 'package:workflow_manager/base/ui/chart/line_chart_screen.dart';
import 'package:workflow_manager/base/ui/chart/pie_chart_screen.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/manager/repository/chart_statistic_manager_task_repository.dart';

class ChartStatisticManagerTaskScreen extends StatefulWidget {
  int idGroupJob;

  ChartStatisticManagerTaskScreen({this.idGroupJob});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChartStatisticManagerTaskScreen();
  }
}

class _ChartStatisticManagerTaskScreen
    extends State<ChartStatisticManagerTaskScreen>
    with AutomaticKeepAliveClientMixin {
  ChartStatisticManagerTaskRepository _chartStatisticManagerTaskRepository =
      new ChartStatisticManagerTaskRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this
        ._chartStatisticManagerTaskRepository
        .getDataGroupJobReport(this.widget.idGroupJob);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: this._chartStatisticManagerTaskRepository,
      child: Consumer(
        builder: (context, ChartStatisticManagerTaskRepository repository, _) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // this._buildTopView(),
                    this._buildRateView(),
                    this._buildAmountChartView(),
                    this._buildStatusChartView(),
                    this._buildPerformanceChartView(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildTopView() {
  //   return Container(
  //     color: "#F5F6FA".toColor(),
  //     height: 32,
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 16),
  //             child: Text(
  //               'Lọc/ Tìm kiếm nhóm công việc',
  //               style: TextStyle(fontSize: 14, color: "#555555".toColor()),
  //             ),
  //           ),
  //         ),
  //         FlatButton(
  //             onPressed: () {
  //
  //             },
  //             child: Icon(Icons.more_vert)),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRateView() {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: "#DDDDDD".toColor(), width: 1))),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10),
                child: Text(
                  'Đánh giá: '.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  this._chartStatisticManagerTaskRepository.performanceRank ??
                      "",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: "#00689D".toColor()),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                child: FittedBox(
                  child: RatingBar.builder(
                    initialRating:
                        this._chartStatisticManagerTaskRepository.rateNumber ??
                            0,
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
    );
  }

  Widget _buildAmountChartView() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
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
                  child: Text("Số lượng công việc"),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return this
                                      ._chartStatisticManagerTaskRepository
                                      .listDataChartLine ==
                                  null ||
                              this
                                      ._chartStatisticManagerTaskRepository
                                      .listDataChartLine
                                      .length ==
                                  0
                          ? EmptyScreen()
                          : Container(
                              padding: EdgeInsets.only(left: 8, right: 16),
                              child: LineChartScreen(
                                listDataChartLine: this
                                    ._chartStatisticManagerTaskRepository
                                    .listDataChartLine,
                              ),
                            );
                    },
                  ),
                ),
              ),
              // LineChartScreen(
              //   listDataChartLine:
              //       this._chartStatisticManagerTaskRepository.listDataChartLine,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChartView() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Hiệu suất nhóm công việc".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          this._chartStatisticManagerTaskRepository.performanceJobGroupData ==
                  null
              ? EmptyScreen()
              : GaugeChartScreen(
                  performanceJobGroupData: this
                      ._chartStatisticManagerTaskRepository
                      .performanceJobGroupData,
                ),
        ],
      ),
    );
  }

  Widget _buildStatusChartView() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      // height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Trạng thái nhóm công việc".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          this._chartStatisticManagerTaskRepository.pieChart == null
              ? EmptyScreen()
              : PieChartScreen(
                  pieChart: this._chartStatisticManagerTaskRepository.pieChart,
                ),
        ],
      ),
    );
  }
}
