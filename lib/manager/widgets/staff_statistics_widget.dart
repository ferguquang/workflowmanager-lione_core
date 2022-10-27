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
import 'package:workflow_manager/base/extension/string.dart';

import 'number_statistics_widget.dart';

class StaffStatisticsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StaffStatisticsWidgetState();
  }
}

class _StaffStatisticsWidgetState extends State<StaffStatisticsWidget> {
  List<charts.Series> seriesList;

  bool animate;

  ReportEmp reportEmp;

  final _myState = new charts.UserManagedState<String>();

  @override
  void initState() {
    super.initState();
    animate = true;
    this.reportEmp = AppStore.homeIndexData.reportEmp;
    setState(() {
      seriesList = _createData(reportEmp);
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
                "Thống kê nhân sự theo độ tuổi".toUpperCase(),
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
                RadioTextWidget(Colors.lightGreen, "Nam"),
                Padding(
                  padding: EdgeInsets.all(16),
                ),
                RadioTextWidget(Colors.orange, "Nữ")
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
                NumberStatisticsWidget("assets/images/ic_person.png",
                    "Tổng SỐ NS", reportEmp.sumEmp.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/men.png", "NAM",
                    reportEmp.sumMale.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/humen.png", "NỮ",
                    reportEmp.sumFemale.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/average.png",
                    "ĐỘ TUỔI TB", reportEmp.averageAge.toInt().toString()),
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
  List<charts.Series<ReportAges, String>> _createData(ReportEmp reportEmp) {
    var reportAges = reportEmp.reportAges;
    return [
      new charts.Series<ReportAges, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ReportAges reportAges, _) => reportAges.name,
        measureFn: (ReportAges reportAges, _) => reportAges.male,
        data: reportAges,
      ),
      new charts.Series<ReportAges, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault.lighter,
        domainFn: (ReportAges reportAges, _) => reportAges.name,
        measureFn: (ReportAges reportAges, _) => reportAges.female,
        data: reportAges,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    if(model.selectedDatum.length <= 0) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Độ tuổi:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.name}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Nam:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.male}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Nữ:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.female}")
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
