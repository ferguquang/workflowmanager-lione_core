import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/manager/models/response/home_index_response.dart';
import 'package:workflow_manager/manager/widgets/radio_text_widget.dart';

import 'number_statistics_widget.dart';

class DocumentStatisticsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DocumentStatisticsWidgetState();
  }
}

class _DocumentStatisticsWidgetState extends State<DocumentStatisticsWidget> {
  List<charts.Series> seriesList;

  bool animate;

  ReportStgDoc reportStgDoc;
  int total;
  String usePercent = "0";
  double remainPercent;

  @override
  void initState() {
    super.initState();
    animate = true;
    reportStgDoc = AppStore.homeIndexData.reportStgDoc;
    ReportSize reportSize = reportStgDoc.reportSize;
    total = reportSize.total;
    if(total != 0) {
      usePercent = (reportSize.size * 100 / total).toStringAsFixed(2);
    }
    remainPercent = 100.0 - double.parse(usePercent);
    setState(() {
      seriesList = _createData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Thống kê tài liệu".toUpperCase(),
                style: TextStyle(fontSize: 14),
              )),
          Expanded(
            child: Container(
              color: Colors.white,
              child: charts.PieChart(seriesList,
                  animate: animate,
                  defaultRenderer: charts.ArcRendererConfig(
                      arcRatio: 1 / 2, arcWidth: 30, startAngle: 0 * pi)),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Đã sử dụng:"),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Text("${usePercent}%")
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioTextWidget(Colors.lightBlue, "Đã sử dụng"),
                Padding(
                  padding: EdgeInsets.all(16),
                ),
                RadioTextWidget(Colors.orange, "Còn lại")
              ],
            ),
          ),
          Container(
            height: 48,
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberStatisticsWidget("assets/images/icon_doc.png",
                    "TỔNG SỐ TL", reportStgDoc.totalFile.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/icon_type_doc.png",
                    "TỔNG SỐ LOẠI", reportStgDoc.totalDoctype.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/icon_capacity.png",
                    "DUNG LƯỢNG", reportStgDoc.totalSize.toString()),
                VerticalDivider(),
                NumberStatisticsWidget("assets/images/ic_person.png",
                    "NGƯỜI SỬ DỤNG", reportStgDoc.totalUser.toString()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
          )
        ],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<GaugeSegment, String>> _createData() {
    final data = [
      new GaugeSegment('Size', double.parse(usePercent),
          charts.MaterialPalette.blue.shadeDefault),
      new GaugeSegment('Acceptable', remainPercent,
          charts.MaterialPalette.deepOrange.shadeDefault.lighter),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        colorFn: (GaugeSegment segment, _) => segment.color,
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class GaugeSegment {
  final String segment;
  final double size;
  final charts.Color color;

  GaugeSegment(this.segment, this.size, this.color);
}
