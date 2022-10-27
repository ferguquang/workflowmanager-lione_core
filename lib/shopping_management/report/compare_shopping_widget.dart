import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/manager/widgets/radio_text_widget.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/procedures/models/event/report_procedure_event.dart';
import 'package:workflow_manager/procedures/models/response/report_procedure_response.dart';
import 'package:workflow_manager/shopping_management/model/event/choice_report_shopping_event.dart';
import 'package:workflow_manager/shopping_management/model/event/report_shopping_event.dart';
import 'package:workflow_manager/shopping_management/response/shopping_dashboard_response.dart';

import '../../main.dart';

class CompareShoppingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompareShoppingState();
  }
}

class _CompareShoppingState extends State<CompareShoppingWidget> {
  List<charts.Series> seriesList;

  bool animate;

  List<ProgressChart> progressCharts;

  final _myState = new charts.UserManagedState<String>();

  @override
  void initState() {
    super.initState();
    animate = true;
    if(isNotNullOrEmpty(AppStore.reportShoppingData)) {
      this.progressCharts =
          AppStore.reportShoppingData.progressCharts;
      setState(() {
        seriesList = _createData(progressCharts);
      });
    }

    eventBus.on<ReportShoppingEvent>().listen((event) {
      this.progressCharts =
          event.data.progressCharts;
      setState(() {
        seriesList = _createData(progressCharts);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 32, top: 16, right: 32),
            child: Text(
              "Biểu đồ mua sắm thực tế so với kế hoạch".toUpperCase(),
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: isNullOrEmpty(seriesList)
                ? EmptyScreen()
                : Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                "Triệu(VNĐ)",
                                style: TextStyle(fontSize: 12),
                              ))),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: progressCharts.length *
                                (Constant.CHART_WIDTH * 2 +
                                    Constant.CHART_DISTANCE),
                            padding: EdgeInsets.all(8),
                            child: charts.BarChart(seriesList,
                                animate: animate,
                                userManagedState: _myState,
                                barGroupingType: charts.BarGroupingType.grouped,
                                selectionModels: [
                                  new charts.SelectionModelConfig(
                                    type: charts.SelectionModelType.info,
                                    changedListener: _onSelectionChanged,
                                  )
                                ]
                                // barGroupingType: charts.BarGroupingType.stacked,
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
          Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RadioTextWidget(
                        isNotNullOrEmpty(progressCharts)
                            ? progressCharts[0].actual.color.toColor()
                            : "EAD189".toColor(),
                        "Thực tế"),
                    Padding(
                      padding: EdgeInsets.all(16),
                    ),
                    RadioTextWidget(
                        isNotNullOrEmpty(progressCharts)
                            ? progressCharts[0].plan.color.toColor()
                            : "A0D468".toColor(),
                        "Kế hoạch"),
                  ],
                ),
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

  _shortName(String name) {
    if(name.length > 10) {
      return name.substring(0, 10) + "...";
    }
    return name;
  }

  _requestLoadListReport(int categoryId, String categoryName) {
    ChoiceReportShoppingEvent event = ChoiceReportShoppingEvent();
    event.categoryId = categoryId;
    event.categoryName = categoryName;
    eventBus.fire(event);
  }

  _onSelectionChanged(charts.SelectionModel model) {
    if (model.selectedDatum.length <= 0) return;
    _requestLoadListReport(model.selectedDatum.first.datum.iD, model.selectedDatum.first.datum.name);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${model.selectedDatum.first.datum.name}"),
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
                    // Text("${model.selectedDatum.first.datum.actual.value}"),
                    Text(
                        "${getCurrencyFormat("${model.selectedDatum.first.datum.actual.value}".replaceAll(",", "."))} triệu")
                  ],
                ),
              ),
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
                    // Text("${model.selectedDatum.first.datum.plan.value}")
                    Text(
                        "${getCurrencyFormat("${model.selectedDatum.first.datum.plan.value}".replaceAll(",", "."))} triệu")
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

  // RadioTextWidget(isNotNullOrEmpty(progressCharts) ? progressCharts[0].actual.color.toColor() : "EAD189".toColor(), "Thực tế"),
  // Padding(
  // padding: EdgeInsets.all(16),
  // ),
  // RadioTextWidget(isNotNullOrEmpty(progressCharts) ? progressCharts[0].plan.color.toColor() : "A0D468".toColor(), "Kế hoạch"),

  /// Create one series with sample hard coded data.
  List<charts.Series<ProgressChart, String>> _createData(
      List<ProgressChart> progressCharts) {
    return [
      new charts.Series<ProgressChart, String>(
        id: 'Sales',
        colorFn: (_, __) {
          return charts.Color.fromHex(
              code: isNotNullOrEmpty(progressCharts)
                  ? progressCharts[0].actual.color
                  : "EAD189");
        },
        domainFn: (ProgressChart progressChart, _) =>
            _shortName(progressChart.name),
        measureFn: (ProgressChart progressChart, _) =>
            progressChart.actual.value,
        data: progressCharts,
      ),
      new charts.Series<ProgressChart, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(
            code: isNotNullOrEmpty(progressCharts)
                ? progressCharts[0].plan.color
                : "A0D468"),
        domainFn: (ProgressChart progressChart, _) =>
            _shortName(progressChart.name),
        measureFn: (ProgressChart progressChart, _) => progressChart.plan.value,
        data: progressCharts,
      ),
    ];
  }
}
