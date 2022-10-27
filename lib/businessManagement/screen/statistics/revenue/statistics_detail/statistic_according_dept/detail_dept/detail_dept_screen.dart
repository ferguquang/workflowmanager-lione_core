import 'package:charts_common/common.dart' as commonCharts;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/statistic_detail_response.dart';

import '../../../item_build_row_dialog.dart';
import '../item_body_according_dept.dart';

class DetailDeptScreen extends StatefulWidget {
  Cate cate;
  String title;
  String colors;
  String nameCate;
  String year;

  DetailDeptScreen(
      this.cate, this.title, this.colors, this.nameCate, this.year);

  @override
  _DetailDeptScreenState createState() => _DetailDeptScreenState();
}

class _DetailDeptScreenState extends State<DetailDeptScreen> {
  List<charts.Series> seriesList = List();
  final _myState = new charts.UserManagedState<String>();
  String headerName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      seriesList = _createData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 32),
            ),
            _getDataChartWidgets(),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16),
                  height: 10,
                  width: double.infinity,
                  color: Colors.grey[200],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text(
                          '${widget.cate.name} ${widget.year}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Doanh thu",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _getListDataWidgets(),
          ],
        ),
      ),
    );
  }

  // biểu đồ
  _getDataChartWidgets() {
    return Row(
      children: [
        const Padding(
            padding: EdgeInsets.all(16),
            child: RotatedBox(
                quarterTurns: -1,
                child: Text(
                  "Doanh số (Tỷ đồng)",
                  style: TextStyle(fontSize: 12),
                ))),
        Expanded(
          child: seriesList.length == 0
              ? EmptyScreen()
              : Container(
                  height: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: this.widget.cate.series.length *
                          (Constant.CHART_WIDTH * seriesList?.length +
                              Constant.CHART_DISTANCE4),
                      padding: EdgeInsets.all(8),
                      child: charts.BarChart(seriesList,
                          animate: true,
                          domainAxis: charts.OrdinalAxisSpec(
                            scaleSpec:
                                commonCharts.FixedPixelOrdinalScaleSpec(45),
                          ),
                          userManagedState: _myState,
                          barGroupingType: charts.BarGroupingType.grouped,
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
    );
  }

  _getListDataWidgets() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.cate.series.length,
      itemBuilder: (context, index) {
        SeriesDept item = widget.cate.series[index];
        return ItemBodyAccordingDept(item.name, item.data);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<SeriesDept, String>> _createData() {
    List<charts.Series<SeriesDept, String>> listColumns = [];
    if (isNullOrEmpty(widget.cate.series)) return [];

    print(listColumns.length.toString());
    return [
      charts.Series<SeriesDept, String>(
        id: 'Statistics',
        colorFn: (_, __) => charts.Color.fromHex(code: widget.colors),
        domainFn: (SeriesDept dataType, __) => dataType.name.length > 15
            ? dataType.name.substring(0, 15) + '...'
            : dataType.name,
        measureFn: (SeriesDept dataType, __) => dataType.data,
        data: widget.cate?.series,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) /*async*/ {
    if (model.selectedDatum.length <= 0) return;

    CustomDialogWidget(
            context,
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ItemBuildRowDialog('${widget.nameCate}',
                      '${widget.cate.name} ${widget.year}'),
                  ItemBuildRowDialog('Loại sản phẩm',
                      '${model.selectedDatum.first.datum.name}'),
                  ItemBuildRowDialog('Doanh thu',
                      '${model.selectedDatum.first.datum.data} tỷ'),
                ],
              ),
            ),
            isClickOutWidget: true)
        .show();

    setState(() {
      _myState.selectionModels[charts.SelectionModelType.info] =
          new charts.UserManagedSelectionModel();
    });
  }
}
