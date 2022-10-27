import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_statistic_response.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:workflow_manager/manager/widgets/radio_text_widget.dart';
import 'package:workflow_manager/base/extension/string.dart';

class StatisticAmountDocScreen extends StatefulWidget {
  List<ReportAmounts> listAmounts;

  StatisticAmountDocScreen({this.listAmounts});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StatisticAmountDocScreen();
  }
}

class _StatisticAmountDocScreen extends State<StatisticAmountDocScreen> {
  List<charts.Series> seriesList = List();
  final _myState = new charts.UserManagedState<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      seriesList = _createData(this.widget.listAmounts);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text("Thống kê số lượng mượn".toUpperCase()),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
            ),
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
                          child: Container(
                            height: 250,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: 1000,
                                padding: EdgeInsets.all(8),
                                child: charts.BarChart(seriesList,
                                    animate: true,
                                    userManagedState: _myState,
                                    barGroupingType:
                                        charts.BarGroupingType.grouped,
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
                          ),
                        ),
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
                      RadioTextWidget("A0D468".toColor(), "Tổng số tài liệu"),
                      Padding(
                        padding: EdgeInsets.all(16),
                      ),
                      RadioTextWidget("EAD189".toColor(), "Người mượn"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 8,
              color: Colors.grey[200],
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text(
                      'Tháng',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 12,
                            height: 12,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.green[200],
                                shape: BoxShape.circle),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 32),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.amber[300],
                                shape: BoxShape.circle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              child: _buildListAmountWidget(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListAmountWidget() {
    if (isNullOrEmpty(this.widget.listAmounts)) {
      return EmptyScreen();
    }
    return Container(
      padding: EdgeInsets.only(top: 18),
      child: ListView.separated(
        itemCount: this.widget.listAmounts.length,
        itemBuilder: (context, index) {
          return Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Text(
                    this.widget.listAmounts[index].title,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "${this.widget.listAmounts[index].total}",
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 52),
                        ),
                        Text("${this.widget.listAmounts[index].totalUser}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<ReportAmounts, String>> _createData(
      List<ReportAmounts> wfServiceTypeRecords) {
    return [
      new charts.Series<ReportAmounts, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: "xA0D468"),
        domainFn: (ReportAmounts typeRecords, _) => typeRecords.title,
        measureFn: (ReportAmounts typeRecords, _) => typeRecords.total,
        data: wfServiceTypeRecords,
      ),
      new charts.Series<ReportAmounts, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: "xEAD189"),
        domainFn: (ReportAmounts typeRecords, _) => typeRecords.title,
        measureFn: (ReportAmounts typeRecords, _) => typeRecords.totalUser,
        data: wfServiceTypeRecords,
      ),
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
              Text(
                "Thống kê chi tiết ${model.selectedDatum.first.datum.title}".toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Tổng số tài liệu: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                      "${model.selectedDatum.first.datum.total}",
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
                    "Số người mượn: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${model.selectedDatum.first.datum.totalUser}",
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