import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Simple pie chart example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/event/report_procedure_event.dart';
import 'package:workflow_manager/procedures/models/response/report_procedure_response.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/shopping_management/model/event/choice_report_shopping_event.dart';
import 'package:workflow_manager/shopping_management/model/event/report_shopping_event.dart';
import 'package:workflow_manager/shopping_management/response/shopping_dashboard_response.dart';
import '../../main.dart';

// ignore: must_be_immutable

class ProjectShoppingWidget extends StatefulWidget {
  final bool animate;

  ProjectShoppingWidget({this.animate});

  @override
  State<StatefulWidget> createState() {
    return _ProjectShoppingState();
  }
}

class _ProjectShoppingState extends State<ProjectShoppingWidget> {
  List<charts.Series> seriesList = List();

  List<ProjectChart> projectCharts = List();

  StreamSubscription listen;

  Widget _listType() {
    return Expanded(
      child: ListView.separated(
        physics: ClampingScrollPhysics(),
        itemCount: projectCharts.length,
        itemBuilder: (context, index) {
          return isNotNullOrEmpty(projectCharts)
              ? _buildItem(projectCharts[index])
              : EmptyScreen();
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget _buildItem(ProjectChart projectChart) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: projectChart.color.toColor(), shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectChart.name,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Tổng tiền: ${double.parse((projectChart.value).toStringAsFixed(1))} triệu VNĐ (${double.parse((projectChart.percent).toStringAsFixed(1))}%)",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (isNotNullOrEmpty(AppStore.reportShoppingData)) {
      projectCharts = AppStore.reportShoppingData.projectCharts;
      seriesList = _createChartData(projectCharts);
    }
    listen = eventBus.on<ReportShoppingEvent>().listen((event) {
      setState(() {
        projectCharts = event.data.projectCharts;
        seriesList = _createChartData(projectCharts);
      });
    });
  }

  @override
  void dispose() {
    listen.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  "Mua sắm dự án".toUpperCase(),
                  style: TextStyle(fontSize: 14),
                )),
            Expanded(
              child: isNullOrEmpty(seriesList)
                  ? Center(
                      child: Text("Không có dữ liệu"),
                    )
                  : Row(
                      children: [
                        Expanded(
                            child: charts.PieChart(seriesList,
                                animate: false,
                                selectionModels: [
                                  charts.SelectionModelConfig(
                                    type: charts.SelectionModelType.info,
                                    changedListener: _onSelectionChanged,
                                  )
                                ],
                                defaultRenderer: new charts.ArcRendererConfig(
                              arcRendererDecorators: [
                                new charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside,
                                ),
                              ]))),
                  _listType()
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            label ?? "",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: Text(
              content ?? "",
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }

  _requestLoadListReport(int categoryId, String categoryName) {
    print("XcategoryId = ${categoryId}");
    ChoiceReportShoppingEvent event = ChoiceReportShoppingEvent();
    event.categoryId = categoryId;
    event.categoryName = categoryName;
    eventBus.fire(event);
  }

  void _onSelectionChanged(charts.SelectionModel model) async {
    ProjectChart current = model.selectedDatum[0].datum;
    ProjectChart report = projectCharts[
        projectCharts.indexWhere((element) => current.iD == element.iD)];
    _requestLoadListReport(report.iD, report.name);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Đóng",
                      style: TextStyle(color: Colors.blue),
                    )))
          ],
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Mua sắm dự án",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                _buildRow("Danh mục hàng hoá", "${report.name}"),
                _buildRow("Tổng tiền:", "${double.parse((report.value).toStringAsFixed(1))} triệu VNĐ"),
                _buildRow("Tỷ lệ:", "${double.parse((report.percent).toStringAsFixed(1))}%"),
              ],
            ),
          ),
        );
      },
    );
    setState(() {});
  }

  List<charts.Series<ProjectChart, int>> _createChartData(
      List<ProjectChart> projectCharts) {
    return [
      new charts.Series<ProjectChart, int>(
        id: 'Sales',
        domainFn: (ProjectChart projectChart, _) => projectChart.iD,
        measureFn: (ProjectChart projectChart, _) => projectChart.percent,
        colorFn: (ProjectChart projectChart, _) =>
            charts.Color.fromHex(code: projectChart.color),
        data: projectCharts,
        labelAccessorFn: (ProjectChart projectChart, _) => "${double.parse((projectChart.percent).toStringAsFixed(1))}%",
      )
    ];
  }
}
