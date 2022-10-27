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
import '../../../../main.dart';

// ignore: must_be_immutable

class StatisticsProceduresWidget extends StatefulWidget {
  final bool animate;

  StatisticsProceduresWidget({this.animate});

  @override
  State<StatefulWidget> createState() {
    return StatisticsProceduresState();
  }
}

class StatisticsProceduresState extends State<StatisticsProceduresWidget> {
  List<charts.Series> seriesList = List();
  List<WfReport> listWfReports = List();
  final _myState = new charts.UserManagedState<String>();
  StreamSubscription listen;
  Widget _listType() {
    return Expanded(
      child: ListView.separated(
        physics: ClampingScrollPhysics(),
        itemCount: listWfReports.length,
        itemBuilder: (context, index) {
          return isNotNullOrEmpty(listWfReports)
              ? _buildItem(listWfReports[index])
              : EmptyScreen();
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget _buildItem(WfReport wfReport) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: wfReport.color.toColor(), shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wfReport.name,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Số lượng : ${wfReport.total} (${(wfReport.total * 100 / _getAllTotal()).toStringAsFixed(1)}%)",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  int _getAllTotal() {
    int total = 0;
    listWfReports.forEach((element) {
      total += element.total;
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    if (isNotNullOrEmpty(AppStore.reportProcedureData)) {
      listWfReports = AppStore.reportProcedureData.wfReport;
      seriesList = _createChartData(listWfReports);
    }
   listen= eventBus.on<ReportProcedureEvent>().listen((event) {
      setState(() {
        listWfReports = event.listWfReport;
        seriesList = _createChartData(listWfReports);
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
                padding: EdgeInsets.only(top: 16,bottom: 8),
                child: Text("THỐNG KÊ QUY TRÌNH",style: TextStyle(fontSize: 16),)),
            Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                    "Hiện tại có ${AppStore?.reportProcedureData?.typeWfTotal ?? 0} loại với ${AppStore?.reportProcedureData?.workflowTotal ?? 0} quy trình")),
            Expanded(
              child: Row(
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
                              arcWidth: 60,
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

  void _onSelectionChanged(charts.SelectionModel model) async {
    LinearSales current = model.selectedDatum[0].datum;
    WfReport report = listWfReports[
        listWfReports.indexWhere((element) => current.index == element.iD)];
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child:
                    Padding(padding: EdgeInsets.all(16), child: Text("Đóng", style: TextStyle(color: Colors.blue),)))
          ],
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "CHI TIẾT THỐNG KÊ QUY TRÌNH",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                _buildRow("Loại QTTT", report.name),
                _buildRow("Số lượng", report.total.toString()),
                _buildRow("Tỷ lệ",
                    '${(current.value.toDouble() * 100 / _getAllTotal()).toStringAsFixed(1)}%'),
              ],
            ),
          ),
        );
      },
    );
    setState(() {});
  }

  List<charts.Series<LinearSales, int>> _createChartData(
      List<WfReport> listWfReports) {
    var data = List();

    data =
        listWfReports.map((e) => LinearSales(e.iD, e.total, e.color)).toList();

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.index,
        measureFn: (LinearSales sales, _) => sales.value,
        colorFn: (LinearSales sales, _) =>
            charts.Color.fromHex(code: sales.color),
        data: data,
        labelAccessorFn: (LinearSales row, _) =>
            '${(row.value.toDouble() * 100 / _getAllTotal()).toStringAsFixed(1)}%',
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int index;
  final int value;
  final String color;

  LinearSales(this.index, this.value, this.color);
}
