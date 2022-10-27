import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';
import 'package:workflow_manager/base/extension/string.dart';

class GaugeChartScreen extends StatefulWidget {
  PerformanceJobGroupAPI performanceJobGroupData = new PerformanceJobGroupAPI();

  GaugeChartScreen({this.performanceJobGroupData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GaugeChartScreen();
  }
}

class _GaugeChartScreen extends State<GaugeChartScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                          } else {
                            // touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 25,
                      sections: showingSections()),
                ),
                Text(
                  '${this.widget.performanceJobGroupData.performance}%',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    Color chartColor = Colors.white;
    if (this.widget.performanceJobGroupData.performance <= 30) {
      chartColor = Colors.red;
    } else if (this.widget.performanceJobGroupData.performance > 30 && this.widget.performanceJobGroupData.performance <= 60) {
      chartColor = Colors.orange;
    } else {
      chartColor = Colors.green;
    }
    return List.generate(2, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: chartColor,
            value: this.widget.performanceJobGroupData.performance.roundToDouble(),
            title: '',
            radius: 60,
            titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: "#DDDDDD".toColor(),
            value: 100 -
                this.widget.performanceJobGroupData.performance.toDouble(),
            title: '',
            radius: 60,
            titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
