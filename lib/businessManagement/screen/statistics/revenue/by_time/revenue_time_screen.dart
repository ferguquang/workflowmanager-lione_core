import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/by_time/revenue_time_repository.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/by_plan/item_by_plan.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/by_plan/percent_gird_view.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/item_dot_actual_overview.dart';

import '../../../../../main.dart';
import '../item_build_row_dialog.dart';

//doan thu - theo thời gian
class RevenueTimeScreen extends StatefulWidget {
  int statusTab = 0;

  RevenueTimeScreen(this.statusTab);

  static const int TAB_BY_TIME = 20; // Theo thời gian

  @override
  _RevenueTimeScreenState createState() => _RevenueTimeScreenState();
}

class _RevenueTimeScreenState extends State<RevenueTimeScreen> {
  RevenueTimeRepository _repository = RevenueTimeRepository();
  List<charts.Series> seriesList = List();
  final _myState = new charts.UserManagedState<String>();

  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProjecTreportIndex();
    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      switch (widget.statusTab) {
        case RevenueTimeScreen.TAB_BY_TIME:
          setState(() {
            request = event.request;
            _getProjecTreportIndex();
          });
          break;
      }
    });
  }

  _getProjecTreportIndex() async {
    seriesList.clear();
    await _repository.getByTheTimeReport(widget.statusTab, request);
    seriesList = _createData();
    setState(() {});
  }

  @override
  void dispose() {
    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, RevenueTimeRepository _repository, child) {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 32, bottom: 32),
                    child: Text(
                      "THỐNG KÊ THEO NĂM",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  _getDataChartWidgets(),
                  _getLegendChart(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PercentGirdView(_repository.listDotActual),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 10,
                    width: double.infinity,
                    color: Colors.grey[200],
                  ),

                  // Divider(),
                  _getListDataWidgets(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget itemHeaderList(String year) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              'Năm $year',
            ),
            flex: 2,
          ),
          const Expanded(
            child: Text(
              "Doanh thu",
              textAlign: TextAlign.center,
            ),
            flex: 2,
          ),
          const Expanded(
            child: Text(
              "Tỷ lệ hoàn thành",
              textAlign: TextAlign.center,
            ),
            flex: 2,
          )
        ],
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
                      width: _repository.listDataChart.length *
                          (Constant.CHART_WIDTH2 * seriesList?.length +
                              Constant.CHART_DISTANCE2),
                      padding: EdgeInsets.all(8),
                      child: charts.BarChart(seriesList,
                          animate: true,
                          // domainAxis: charts.OrdinalAxisSpec(
                          //   scaleSpec:
                          //       commonCharts.FixedPixelOrdinalScaleSpec(40),
                          // ),
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

  // ghi chú biểu đồ
  _getLegendChart() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getListColorsWidgets(),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: ItemDotActualOverView(
              sColors: '#5DB2FF',
              text: 'Kế hoạch',
            ),
          ),
        ],
      ),
    );
  }

  _getListDataWidgets() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _repository.listDataChart?.length ?? 0,
      itemBuilder: (context, index) {
        ProjectQuaterChartInfos item = _repository.listDataChart[index];
        return item.isHeader ? itemHeaderList(item?.year) : ItemByPlan(item);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  _getListColorsWidgets() {
    List<String> colorActualDots = [];
    if (_repository.listDataChart != null) {
      _repository.listDataChart.forEach((element) {
        if (!colorActualDots.contains(element.actualColor)) {
          colorActualDots.add(element.actualColor);
        }
      });
    }
    return ItemDotActualOverView(
      sColors: '#444444',
      text: 'Thực tế',
      colorActualDots: colorActualDots,
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<ProjectQuaterChartInfos, String>> _createData() {
    List<charts.Series<ProjectQuaterChartInfos, String>> listColumns = [];

    if (isNullOrEmpty(_repository.listDataChart)) return [];
    // do có header lêm phải tạo list mới
    List<ProjectQuaterChartInfos> listChart = [];
    _repository.listDataChart.forEach((element) {
      if (!element.isHeader) {
        listChart.add(element);
      }
    });

    /// cột thực tế
    var actual = new charts.Series<ProjectQuaterChartInfos, String>(
      id: 'Sales',
      colorFn: (ProjectQuaterChartInfos typeRecords, __) =>
          charts.Color.fromHex(code: typeRecords.actualColor),
      domainFn: (ProjectQuaterChartInfos typeRecords, _) => typeRecords.lable,
      measureFn: (ProjectQuaterChartInfos typeRecords, _) => typeRecords.actual,
      data: listChart,
    );
    listColumns.add(actual);

    //cột kế hoạch
    var plan = new charts.Series<ProjectQuaterChartInfos, String>(
      id: 'Sales',
      colorFn: (ProjectQuaterChartInfos typeRecords, __) =>
          charts.Color.fromHex(code: "#5db2ff"),
      domainFn: (ProjectQuaterChartInfos typeRecords, _) => typeRecords.lable,
      measureFn: (ProjectQuaterChartInfos typeRecords, _) => typeRecords.plan,
      data: listChart,
    );
    listColumns.add(plan);

    return listColumns;
  }

  _onSelectionChanged(charts.SelectionModel model) async {
    if (model.selectedDatum.length <= 0) return;

    await CustomDialogWidget(
            context,
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "Thống kê chi tiết".toUpperCase(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ItemBuildRowDialog(
                      "Thời gian", "${model.selectedDatum.first.datum.lable}"),
                  ItemBuildRowDialog("Giá trị thực tế",
                      "${model.selectedDatum.first.datum.actual == 0.0 ? 0 : model.selectedDatum.first.datum.actual} tỷ"),
                  ItemBuildRowDialog("Giá trị kế hoạch",
                      "${model.selectedDatum.first.datum.plan == 0.0 ? 0 : model.selectedDatum.first.datum.plan} tỷ"),
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
