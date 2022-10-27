
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/borrowPayDocument/model/event/event_load_purposes_pie_chart.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_statistic_response.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/screens/report/register_resolve/register_resolve_widget.dart';
import 'package:workflow_manager/base/extension/string.dart';

class StatisticPurposeDocScreen extends StatefulWidget {

  List<ReportPurposes> listPurposes;

  StatisticPurposeDocScreen({this.listPurposes});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StatisticPurposeDocScreen();
  }
}

class _StatisticPurposeDocScreen extends State<StatisticPurposeDocScreen> {

  List<charts.Series> seriesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      seriesList = _createChartData(this.widget.listPurposes);

    eventBus.on<EventLoadPurposesPieChart>().listen((event) {
      setState(() {
          seriesList = _createChartData(event.listPurposes);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        // height: 250,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text("Thống kê mục đích mượn".toUpperCase()),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
            ),
            Container(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                      child: charts.PieChart(seriesList,
                          animate: false,
                          defaultRenderer: new charts.ArcRendererConfig(
                              arcWidth: 100,
                              arcRendererDecorators: [
                                new charts.ArcLabelDecorator(
                                    labelPosition: charts.ArcLabelPosition.inside,
                                    insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 12, color:
                                    charts.Color.fromHex(code: "#FFFFFF")))
                              ]),
                          selectionModels: [
                            new charts.SelectionModelConfig(
                              type: charts.SelectionModelType.info,
                              changedListener: _onSelectionChanged,
                            )
                          ]
                      ),
                  ),
                  _listType()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
            ),
            Container(
              height: 8,
              color: Colors.grey[200],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      '${this.widget.listPurposes.length} mục đích',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(right: 16, top: 8),
                      child: Text(
                        'Số lượng (${_getAllTotal()})',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
              _buildListPurposeWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // build widget
// Hiển thị mô tả biểu đồ
  Widget _listType() {
    return Expanded(
      child: ListView.separated(
        itemCount: this.widget.listPurposes.length,
        itemBuilder: (context, index) {
          return isNotNullOrEmpty(this.widget.listPurposes)
              ? _buildItemType(this.widget.listPurposes[index])
              : EmptyScreen();
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  // Hiển thị item mô tả biểu đồ
  Widget _buildItemType(ReportPurposes reports) {
    return Container(
      height: 36,
      child: Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: reports.color.toColor(), shape: BoxShape.circle),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reports.title, style: TextStyle(fontSize: 14),),
              Text("Tỷ lệ: ${(reports.total ?? 0 * 100/ _getAllTotal()).toStringAsFixed(1)}%", style: TextStyle(fontSize: 12),)
            ],
          )
        ],
      ),
    );
  }

  // Hiển thị danh sách mục đích
  Widget _buildListPurposeWidget() {
    if (isNullOrEmpty(this.widget.listPurposes)) {
      return EmptyScreen();
    }
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: ListView.separated(
        itemCount: this.widget.listPurposes.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {

            },
            child: Container(
              // padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 8,
                    margin:
                        EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
                    decoration: BoxDecoration(
                        color: this.widget.listPurposes[index].color.toColor(),
                        shape: BoxShape.circle),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      '${this.widget.listPurposes[index].title}',
                      style: TextStyle(
                          fontSize: 14,),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text(
                        '${this.widget.listPurposes[index].total}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
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
              Text(
                "Chi tiết thống kê mục đích mượn".toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Mục đích mượn: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${model.selectedDatum.first.datum.title}",
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
                    "${(model.selectedDatum.first.datum.value ?? 0 * 100/ _getAllTotal()).toStringAsFixed(1)}%",
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
                setState(() {
                  // _myState.selectionModels[charts.SelectionModelType.info] =
                  // new charts.UserManagedSelectionModel();
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Tạo dữ liệu biểu đồ
  List<charts.Series<LinearSales, int>> _createChartData(
      List<ReportPurposes> listReports) {
    List<LinearSales> data = [];

    for (int i = 0; i < listReports.length; i++) {
        data.add(LinearSales(i, listReports[i].total, listReports[i].color, title: listReports[i].title));
    }
    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.index,
        measureFn: (LinearSales sales, _) => sales.value,
        colorFn: (LinearSales sales, _) =>
            charts.Color.fromHex(code: sales.color == "" ? "#cecece" : sales.color),
        data: data,
        labelAccessorFn: (LinearSales row, _) => '${(row.value * 100/ _getAllTotal()).toStringAsFixed(1)}%',
      )
    ];
  }

  // Lấy tổng số lượng
  int _getAllTotal() {
    int total = 0;
    this.widget.listPurposes.forEach((element) {
      total += element.total ?? 0;
    });
    return total;
  }

}