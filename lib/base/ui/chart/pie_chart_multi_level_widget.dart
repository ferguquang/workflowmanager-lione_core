import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';

class PieChartMultiLevelScreen extends StatefulWidget {
  ListDataChart pieChart = new ListDataChart();

  PieChartMultiLevelScreen({this.pieChart});

  @override
  State<StatefulWidget> createState() => _PieChartMultiLevelScreen();
}

class _PieChartMultiLevelScreen extends State<PieChartMultiLevelScreen> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 250,
            child: PieChart(
              PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    setState(() {
                      if (pieTouchResponse.touchInput is FlLongPressEnd ||
                          pieTouchResponse.touchInput is FlPanEnd) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse.touchedSectionIndex;
                      }
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections()),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> _pieChartData = [];
    bool _isHasData = false;
    if (this.widget.pieChart.chart.length != null) {
      for (int i = 0; i < this.widget.pieChart.chart.length; i++) {
        if (this.widget.pieChart.chart[i].count > 0) {
          _isHasData = true;
        }
        PieChartSectionData _sectionData = PieChartSectionData(
            color: this.widget.pieChart.chart[i].fill.toColor(),
            value: (this.widget.pieChart.chart[i].count /
                    this.widget.pieChart.totalCount) *
                100,
            title: '');
        _pieChartData.add(_sectionData);
      }
    }
    if (_isHasData == false) {
      _pieChartData.clear();
      PieChartSectionData _sectionData =
          PieChartSectionData(color: Colors.grey[350], value: 100, title: '');
      _pieChartData.add(_sectionData);
    }
    return _pieChartData;
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final double percent;
  final Color textColor;

  const Indicator(
      {Key key,
      this.color,
      this.text,
      this.isSquare,
      this.size = 8,
      this.textColor = const Color(0xff505050),
      this.percent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '${percent.isNaN == true ? 0 : percent.toInt()}%',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: "#55555".toColor()),
        ),
        Padding(padding: EdgeInsets.only(left: 8)),
        Text(
          text, //
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: "#55555".toColor()),
        )
      ],
    );
  }
}
