import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/models/response/get_data_group_job_report_response.dart';

class PieChartScreen extends StatefulWidget {
  ListDataChart pieChart = new ListDataChart();

  PieChartScreen({this.pieChart});

  @override
  State<StatefulWidget> createState() => _PieChartScreen();
}

class _PieChartScreen extends State<PieChartScreen> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
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
              )),
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: this._buildIndicator(),
                ),
              )),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> _pieChartData = [];
    bool _isHasData = false;
    if (this.widget.pieChart.chart.length != null) {
      for (int i = 0; i < this.widget.pieChart.chart.length; i++) {
        double percent = 0;
        if (this.widget.pieChart.chart[i].count > 0) {
          _isHasData = true;
          percent = ((this.widget.pieChart.chart[i].count /
                  this.widget.pieChart.totalCount) *
              100);
        }
        PieChartSectionData _sectionData = PieChartSectionData(
            color: this.widget.pieChart.chart[i].fill.toColor(),
            value: percent,
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

  List<Widget> _buildIndicator() {
    List<Indicator> _listIndicator = [];
    for (int i = 0; i < this.widget.pieChart.chart.length; i++) {
      Indicator _indicator = Indicator(
        color: this.widget.pieChart.chart[i].fill.toColor(),
        text: this.widget.pieChart.chart[i].label,
        percent: (this.widget.pieChart.chart[i].count /
                this.widget.pieChart.totalCount) *
            100,
        isSquare: true,
      );
      _listIndicator.add(_indicator);
    }
    return _listIndicator;
    // Indicator(
    //   color: Color(0xff0293ee),
    //   text: 'First',
    //   isSquare: true,
    // )
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
          '${percent.isNaN == true ? 0 : percent.round()} %',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            /*color: "#55555".toColor()*/
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 5)),
        Text(
          text, //
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
