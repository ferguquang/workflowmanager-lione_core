import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Simple pie chart example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/states_widget.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/event/register_resolve_event.dart';
import 'package:workflow_manager/procedures/models/event/report_procedure_event.dart';
import 'package:workflow_manager/procedures/models/response/report_procedure_response.dart';
import 'package:workflow_manager/base/extension/string.dart';
import '../../../../main.dart';

// ignore: must_be_immutable

class RegisterResolveWidget extends StatefulWidget {
  final bool animate;

  ReportProcedureData reportProcedureData;

  RegisterResolveWidget(this.reportProcedureData, {this.animate});

  @override
  State<StatefulWidget> createState() {
    return RegisterResolveState();
  }
}

class RegisterResolveState extends State<RegisterResolveWidget> {
  List<charts.Series> seriesList = List();

  List<RecordReport> recordReportList = List();

  Widget _listType() {
    return Expanded(
      child: ListView.separated(
        itemCount: recordReportList.length,
        itemBuilder: (context, index) {
          return isNotNullOrEmpty(recordReportList)
              ? _buildItem(recordReportList[index])
              : EmptyScreen();
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget _buildItem(RecordReport recordReport) {
    return Container(
      height: 36,
      child: Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: recordReport.color.toColor(), shape: BoxShape.circle),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recordReport.name,
                style: TextStyle(fontSize: 14),
              ),
              Text(
                _getAllTotal() > 0
                    ? "Số lượng : ${recordReport.number} (${(recordReport.number * 100 / _getAllTotal()).toStringAsFixed(1)}%)"
                    : "Số lượng : ${recordReport.number}(0%)",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }

  int _getAllTotal() {
    int total = 0;
    if (isNotNullOrEmpty(recordReportList)) {
      recordReportList.forEach((element) {
        total += element.number;
      });
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    recordReportList = widget.reportProcedureData.recordReport;
    if(isNotNullOrEmpty(recordReportList)) {
      seriesList = _createChartData(recordReportList);
    }
    eventBus.on<RegisterResolveEvent>().listen((event) {
      setState(() {
        recordReportList = event.listRecordReport;
        if(isNotNullOrEmpty(recordReportList)) {
          seriesList = _createChartData(recordReportList);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // thỉnh thoảng khi back từ màn lọc, charts không hiển thị nên phải set lại giá trị ở đây
    if(isNotNullOrEmpty(recordReportList)) {
      seriesList = _createChartData(recordReportList);
    }
    return Container(
        height: 100,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 16,bottom: 8),
                child: Text("THỐNG KÊ ĐĂNG KÝ - GIẢI QUYẾT",style: TextStyle(fontSize: 16))),
            Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                    "Hiện tại có ${widget.reportProcedureData.typeCount} loại với ${widget.reportProcedureData.recordTotal} hồ sơ đăng ký")),
            Expanded(
              child: Row(
                      children: [
                        Expanded(
                            child: _getAllTotal() != 0 ? charts.PieChart(seriesList,
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
                                      new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside,)
                                    ])) : EmptyScreen()),
                        _listType()
                      ],
                    ),
            )
          ],
        ));
  }
  void _onSelectionChanged(charts.SelectionModel model) async {
    if (model.selectedDatum.length <= 0) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chi tiết thống kê đăng ký-giải quyết".toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Trạng thái: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${model.selectedDatum.first.datum.title??""}",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Số lượng: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${model.selectedDatum.first.datum.value}",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Tỷ lệ: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${(model.selectedDatum.first.datum.value * 100/ _getAllTotal()).toStringAsFixed(1)}%",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
    setState(() {
      // _myState.selectionModels[charts.SelectionModelType.info] =
      // new charts.UserManagedSelectionModel();
    });
  }


  List<charts.Series<LinearSales, int>> _createChartData(
      List<RecordReport> recordReportList) {
    var data = List();

    data = recordReportList.map((e) {
      var i = recordReportList.indexOf(e);
      return LinearSales(i, e.number, e.color,title: e.name);
    }).toList();

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.index,
        measureFn: (LinearSales sales, _) => sales.value,
        colorFn: (LinearSales sales, _) =>
            charts.Color.fromHex(code: sales.color),
        data: data,
        labelAccessorFn: (LinearSales row, _) => _getAllTotal() > 0
            ? '${(row.value * 100 / _getAllTotal()).toStringAsFixed(1)}%'
            : "0%",
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final String title;
  final int index;
  final int value;
  final String color;

  LinearSales(this.index, this.value, this.color, {this.title});
}
