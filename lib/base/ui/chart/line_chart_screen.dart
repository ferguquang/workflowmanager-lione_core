import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';

class LineChartScreen extends StatefulWidget {
  List<ListDataChartLine> listDataChartLine = [];

  LineChartScreen({this.listDataChartLine});

  @override
  State<StatefulWidget> createState() => _LineChartScreen();
}

class _LineChartScreen extends State<LineChartScreen> {


  void _loadData() async {
    await Future.delayed(Duration(seconds: 0));
    // final String data =
    //     '[{"Day":1,"Value":"5"},{"Day":2,"Value":"2"},{"Day":3,"Value":"6"},{"Day":4,"Value":"8"}]';
    // final List list = json.decode(data);

  }

  @override
  void initState() {
    // _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthChart = 0.0;
    int periodNumber = 2;
    List<ListDataChartLine> temp = [];
    temp.addAll(this.widget.listDataChartLine);
    temp.sort((a, b) => b.x.compareTo(a.x));
    if (temp.first.x > 20 && temp.first.x < 50) {
      periodNumber = 5;
    } else if (temp.first.x > 50 && temp.first.x < 100) {
      periodNumber = 10;
    } else if (temp.first.x > 100) {
      periodNumber = 20;
    }
    if (this.widget.listDataChartLine.length < 6) {
      widthChart = (6 * 50).toDouble();
    } else {
      widthChart = (50 * this.widget.listDataChartLine.length).toDouble();
    }
    return Container(
      padding: EdgeInsets.only(top: 42, left: 0),
      width: widthChart,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(enabled: true),
          lineBarsData: [
            LineChartBarData(
              spots: this._buildXPoint(),
              isCurved: false,
              barWidth: 2,
              colors: [
                Colors.orange,
              ],
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                getTitles: (value) {
                  print(
                      "===> ${this.widget.listDataChartLine[value.toInt()].y}");
                  // print("====>${value.toInt()} - ${this.widget.listDataChartLine[value.toInt()].y}");
                  return this.widget.listDataChartLine[value.toInt()].y;
                }),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                if (value % periodNumber == 0) {
                  return '${value.toInt()}';
                }
                return '';
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (double value) {
              return value % periodNumber == 0;
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _buildXPoint() {
    List<FlSpot> arrayPoint = [];
    for (int i = 0; i < this.widget.listDataChartLine.length; i++) {
      FlSpot spot = FlSpot(
          i.toDouble(), this.widget.listDataChartLine[i].x.toDouble());
      arrayPoint.add(spot);
    }
    return arrayPoint;
  }
}
