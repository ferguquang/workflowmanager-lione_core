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

class InternalShoppingWidget extends StatefulWidget {
  final bool animate;

  InternalShoppingWidget({this.animate});

  @override
  State<StatefulWidget> createState() {
    return InternalShoppingState();
  }
}

class InternalShoppingState extends State<InternalShoppingWidget> {
  List<charts.Series> seriesList = List();

  List<InternalChart> internalCharts = List();

  StreamSubscription listen;

  Widget _listType() {
    return Expanded(
      child: ListView.separated(
        physics: ClampingScrollPhysics(),
        itemCount: internalCharts.length,
        itemBuilder: (context, index) {
          return isNotNullOrEmpty(internalCharts)
              ? _buildItem(internalCharts[index])
              : EmptyScreen();
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget _buildItem(InternalChart internalChart) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: internalChart.color.toColor(), shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  internalChart.name,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Tổng tiền: ${double.parse((internalChart.value).toStringAsFixed(1))} triệu VNĐ (${double.parse((internalChart.percent).toStringAsFixed(1))}%)",
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
      internalCharts = AppStore.reportShoppingData.internalCharts;
      seriesList = _createChartData(internalCharts);
    }
    listen = eventBus.on<ReportShoppingEvent>().listen((event) {
      setState(() {
        internalCharts = event.data.internalCharts;
        seriesList = _createChartData(internalCharts);
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
                  "Mua sắm nội bộ".toUpperCase(),
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

    InternalChart current = model.selectedDatum[0].datum;
    InternalChart report = internalCharts[
        internalCharts.indexWhere((element) => current.iD == element.iD)];
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
                    "Mua sắm nội bộ",
                    style: TextStyle(fontSize: 16),
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

  List<charts.Series<InternalChart, int>> _createChartData(
      List<InternalChart> internalCharts) {
    return [
      new charts.Series<InternalChart, int>(
        id: 'Sales',
        domainFn: (InternalChart internalChart, _) => internalChart.iD,
        measureFn: (InternalChart internalChart, _) => internalChart.percent,
        colorFn: (InternalChart internalChart, _) =>
            charts.Color.fromHex(code: internalChart.color),
        data: internalCharts,
        labelAccessorFn: (InternalChart internalChart, _) => "${double.parse((internalChart.percent).toStringAsFixed(1))}%",
      )
    ];
  }
}
