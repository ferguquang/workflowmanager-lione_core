import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/model/response/revenue_phased_response.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/by_plan/item_by_plan.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/by_plan/percent_gird_view.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/item_dot_actual_overview.dart';

import '../../../../../../main.dart';
import '../../item_build_row_dialog.dart';

// doanh thu - theo giai đoạn - hành chính
class AdministrativeScreen extends StatefulWidget {
  List<ProjectQuaterChartInfos> listDataChart;
  List<ColorNotes> listDotActual;
  int idTab;

  AdministrativeScreen(this.listDataChart, this.listDotActual, this.idTab);

  @override
  _AdministrativeScreenState createState() => _AdministrativeScreenState();
}

class _AdministrativeScreenState extends State<AdministrativeScreen> {
  List<charts.Series> seriesList = List();
  final _myState = new charts.UserManagedState<String>();
  StreamSubscription _dataListChartPlan;
  List<ProjectQuaterChartInfos> listDataChart = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listDataChart = widget.listDataChart;
    seriesList = _createData();
    setState(() {});

    if (isNotNullOrEmpty(_dataListChartPlan)) _dataListChartPlan.cancel();
    _dataListChartPlan =
        eventBus.on<GetListDataRevenueEventBus>().listen((event) {
      // truyền từ revenue_phased_repository.dart qua
      setState(() {
        List<PhaseTypeCharts> listType =
            event?.dataRevenuePhased?.phaseTypeCharts;
        for (int i = 0; i < listType.length; i++) {
          if (widget.idTab == listType[i].iD) {
            listDataChart = listType[i]?.phaseReport;
            seriesList = _createData();
            break;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (isNotNullOrEmpty(_dataListChartPlan)) _dataListChartPlan.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 32),
              child: Text(
                "THỐNG KÊ THEO GIAI ĐOẠN",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            _getDataChartWidgets(),
            _getLegendChart(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PercentGirdView(widget.listDotActual),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 10,
              width: double.infinity,
              color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: const Text(
                      'Giai đoạn',
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
                    ),
                    flex: 2,
                  )
                ],
              ),
            ),
            Divider(),
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
                      width: listDataChart.length *
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
              text: 'Dự kiến',
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
      itemCount: listDataChart.length,
      itemBuilder: (context, index) {
        return ItemByPlan(listDataChart[index]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  _getListColorsWidgets() {
    List<String> colorActualDots = [];
    if (listDataChart != null) {
      listDataChart.forEach((element) {
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

    if (isNullOrEmpty(listDataChart)) return [];

    /// cột thực tế
    var actual = new charts.Series<ProjectQuaterChartInfos, String>(
      id: 'Sales',
      colorFn: (ProjectQuaterChartInfos typeRecords, __) =>
          charts.Color.fromHex(code: typeRecords.actualColor),
      domainFn: (ProjectQuaterChartInfos typeRecords, _) =>
          typeRecords.lable.length > 15
              ? '${typeRecords.lable.substring(0, 15)}...'
              : typeRecords.lable,
      measureFn: (ProjectQuaterChartInfos typeRecords, _) => typeRecords.actual,
      data: listDataChart,
    );
    listColumns.add(actual);

    //cột kế hoạch
    var plan = new charts.Series<ProjectQuaterChartInfos, String>(
      id: 'Sales',
      colorFn: (ProjectQuaterChartInfos typeRecords, __) =>
          charts.Color.fromHex(code: "#5db2ff"),
      domainFn: (ProjectQuaterChartInfos typeRecords, _) =>
          typeRecords.lable.length > 15
              ? '${typeRecords.lable.substring(0, 15)}...'
              : typeRecords.lable,
      measureFn: (ProjectQuaterChartInfos typeRecords, _) => typeRecords.plan,
      data: listDataChart,
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
                children: [
                  Center(
                    child: Text(
                      "Thống kê chi tiết".toUpperCase(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ItemBuildRowDialog(
                      "Giai đoạn", model.selectedDatum.first.datum.lable),
                  ItemBuildRowDialog("Giá trị thực tế",
                      "${model.selectedDatum.first.datum.actual == 0.0 ? 0 : model.selectedDatum.first.datum.actual} tỷ"),
                  ItemBuildRowDialog("Giá trị dự kiến",
                      "${model.selectedDatum.first.datum.plan == 0.0 ? 0 : model.selectedDatum.first.datum.plan} tỷ"),
                  // ItemBuildRowDialog(
                  //     "Thời gian", "${model.selectedDatum.first.datum.lable}"),
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
