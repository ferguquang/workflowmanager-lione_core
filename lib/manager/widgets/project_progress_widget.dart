import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/manager/home/manager_repository.dart';
import 'package:workflow_manager/manager/models/response/home_index_response.dart';
import 'package:workflow_manager/manager/widgets/progress_statistics_widget.dart';
import 'package:workflow_manager/manager/widgets/radio_text_widget.dart';

import 'number_statistics_widget.dart';

class ProjectProgressWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProjectProgressWidgetState();
  }
}

class _ProjectProgressWidgetState extends State<ProjectProgressWidget> {
  List<charts.Series> seriesList;

  bool animate;

  ReportProjectPlan reportProjectPlan;

  final _myState = new charts.UserManagedState<String>();

  @override
  void initState() {
    super.initState();
    animate = true;
    this.reportProjectPlan = AppStore.homeIndexData.reportProjectPlan;
    setState(() {
      seriesList = _createData(reportProjectPlan);
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
                "Tiến độ dự án theo kế hoạch".toUpperCase(),
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
                          "Doanh số (Tỷ đồng)",
                          style: TextStyle(fontSize: 12),
                        ))),
                Expanded(
                  child: charts.BarChart(seriesList,
                      animate: animate,
                      userManagedState: _myState,
                      selectionModels: [
                        new charts.SelectionModelConfig(
                          type: charts.SelectionModelType.info,
                          changedListener: _onSelectionChanged,
                        )
                      ]
                    // barGroupingType: charts.BarGroupingType.stacked,
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
                RadioTextWidget(Colors.lightBlue, "Thực tế"),
                Padding(
                  padding: EdgeInsets.all(16),
                ),
                RadioTextWidget(Colors.lightGreen, "Doanh thu")
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
                NumberStatisticsWidget(
                    "assets/images/total_project.png",
                    "Tổng SỐ DA",
                    reportProjectPlan.projectPlanTotal.toString()),
                VerticalDivider(),
                NumberStatisticsWidget(
                    "assets/images/money.png",
                    "Tổng giá trị",
                    reportProjectPlan.planTotalMoney.toString()),
                VerticalDivider(),
                NumberStatisticsWidget(
                    "assets/images/stick.png",
                    "Đã hoàn thành",
                    reportProjectPlan.projectActualTotal.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/money.png", "Doanh thu",
                    reportProjectPlan.actualTotalMoney.toInt().toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/money.png", "Gía trị huỷ",
                    reportProjectPlan.totalProjectFail.toInt().toString()),
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
  List<charts.Series<ReportQuater, String>> _createData(
      ReportProjectPlan reportProjectPlan) {
    var reportQuaters = reportProjectPlan.reportQuater;
    return [
      new charts.Series<ReportQuater, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ReportQuater reportQuater, _) => reportQuater.title,
        measureFn: (ReportQuater reportQuater, _) => reportQuater.plan,
        data: reportQuaters,
      ),
      new charts.Series<ReportQuater, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ReportQuater reportQuater, _) => reportQuater.title,
        measureFn: (ReportQuater reportQuater, _) => reportQuater.actual,
        data: reportQuaters,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    if (model.selectedDatum.length <= 0) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${model.selectedDatum.first.datum.title}"),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Kế hoạch:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.plan}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Thực tế:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.actual}")
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

