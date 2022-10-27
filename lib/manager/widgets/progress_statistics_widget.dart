import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/manager/models/response/home_index_response.dart';
import 'package:workflow_manager/manager/widgets/radio_text_widget.dart';

import 'number_statistics_widget.dart';

class ProgressStatisticsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProgressStatisticsWidgetState();
  }
}

class _ProgressStatisticsWidgetState extends State<ProgressStatisticsWidget> {
  List<charts.Series> seriesList;

  bool animate;

  ReportJob reportJob;

  final _myState = new charts.UserManagedState<String>();

  @override
  void initState() {
    super.initState();
    animate = true;
    this.reportJob = AppStore.homeIndexData.reportJob;
    setState(() {
      seriesList = _createData(reportJob);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Thống kê tiến độ công việc".toUpperCase(),
                style: TextStyle(fontSize: 14),
              )),
          Expanded(
            child: seriesList == null
                ? EmptyScreen()
                : Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                "Số lượng",
                                style: TextStyle(fontSize: 12),
                              ))),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: this.reportJob.reportStatus.length * (Constant.CHART_WIDTH * 3 + Constant.CHART_DISTANCE),
                            child: charts.BarChart(
                              seriesList,
                              animate: animate,
                              userManagedState: _myState,
                              behaviors: [],
                              selectionModels: [
                                new charts.SelectionModelConfig(
                                  type: charts.SelectionModelType.info,
                                  changedListener: _onSelectionChanged,
                                )
                              ],
                              // barGroupingType: charts.BarGroupingType.stacked,
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioTextWidget(Colors.lightGreen, "Trong thời hạn"),
                Padding(
                  padding: EdgeInsets.all(16),
                ),
                RadioTextWidget(Colors.orange, "Sắp hết hạn"),
                Padding(
                  padding: EdgeInsets.all(16),
                ),
                RadioTextWidget(Colors.red, "Quá hạn")
              ],
            ),
          ),
          Container(
            height: 48,
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberStatisticsWidget("assets/images/jobs.png", "Tổng SỐ CV",
                    reportJob.jobCount.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/stick.png",
                    "Đã hoàn thành", reportJob.jobDone.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/unfinish.png",
                    "Chưa hoàn thành", reportJob.jobProgress.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/exprite.png", "Qúa hạn",
                    reportJob.jobExpried.toString()),
                VerticalDivider(),
                NumberStatisticsWidget(
                    "assets/images/ratio.png",
                    "Tỉ lệ hoàn thành",
                    "${reportJob.percentSussess.toString()}%"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
          )
        ],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<ReportStatus, String>> _createData(ReportJob reportJob) {
    var reportStatus = reportJob.reportStatus;
    return [
      new charts.Series<ReportStatus, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ReportStatus reportStatus, _) => reportStatus.title,
        measureFn: (ReportStatus reportStatus, _) => reportStatus.intime,
        data: reportStatus,
      ),
      new charts.Series<ReportStatus, String>(
        id: 'Sales',
        colorFn: (_, __) =>
            charts.MaterialPalette.deepOrange.shadeDefault.lighter,
        domainFn: (ReportStatus reportStatus, _) => reportStatus.title,
        measureFn: (ReportStatus reportStatus, _) => reportStatus.warningtime,
        data: reportStatus,
      ),
      new charts.Series<ReportStatus, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (ReportStatus reportStatus, _) => reportStatus.title,
        measureFn: (ReportStatus reportStatus, _) => reportStatus.overtime,
        data: reportStatus,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    if (model.selectedDatum.length <= 0) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Tình trạng:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                  ),
                  Text("${model.selectedDatum.first.datum.title}")
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Trong thời hạn:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.intime}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Sắp hết hạn:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.warningtime}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Quá hạn:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.overtime}")
                  ],
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _myState.selectionModels[charts.SelectionModelType.info] =
                      new charts.UserManagedSelectionModel();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
