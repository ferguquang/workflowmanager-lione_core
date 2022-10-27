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
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/item_build_row_dialog.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistic_according_dept/item_body_according_dept.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistic_according_dept/item_header_according_dept.dart';

import '../../../../../main.dart';
import 'bonus_by_dept_repository.dart';

// thưởng - theo phòng ban
class BonusByDeptScreen extends StatefulWidget {
  int statusTab = 0;

  static const int TAB_BONUS_DEPT = 60; // theo phòng ban
  static const int TAB_BONUS_BRANCH = 61; // theo chi nhánh

  BonusByDeptScreen(this.statusTab);

  @override
  _BonusByDeptScreenState createState() => _BonusByDeptScreenState();
}

class _BonusByDeptScreenState extends State<BonusByDeptScreen> {
  var _repository = BonusByDeptRepository();
  List<charts.Series> seriesList = List();
  final _myState = new charts.UserManagedState<String>();

  List<ProjectQuaterChartInfos> listDataChart;
  String title = '';
  String nameHeader = '';
  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.statusTab == BonusByDeptScreen.TAB_BONUS_DEPT) {
      title = 'THƯỞNG THEO PHÒNG BAN';
      nameHeader = 'Phòng ban';
    } else {
      title = 'THƯỞNG THEO CHI NHÁNH';
      nameHeader = 'Chi nhánh';
    }

    _getDataChart();

    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      switch (event.numberTabFilter) {
        case BonusByDeptScreen.TAB_BONUS_DEPT:
        case BonusByDeptScreen.TAB_BONUS_BRANCH:
          setState(() {
            request = event.request;
            _getDataChart();
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    super.dispose();
  }

  _getDataChart() async {
    await _repository.getBonusDept(widget.statusTab, request);
    listDataChart = _repository.listChart;
    seriesList = _createData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, BonusByDeptRepository _repository1, child) {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 32, bottom: 32),
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  _getDataChartWidgets(),
                  ItemHeaderAccordingDept(
                    nameHeader,
                    'Mức thưởng',
                    flex: 3,
                  ),
                  _getListDataWidgets(),
                ],
              ),
            ),
          );
        },
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
                  "Mức thưởng(Tỷ đồng)",
                  style: TextStyle(fontSize: 12),
                ))),
        Expanded(
          child: isNullOrEmpty(listDataChart)
              ? EmptyScreen()
              : Container(
                  height: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: this.listDataChart.length *
                          (Constant.CHART_WIDTH2 * seriesList?.length +
                              Constant.CHART_DISTANCE),
                      padding: EdgeInsets.all(8),
                      child: charts.BarChart(seriesList,
                          // domainAxis: charts.OrdinalAxisSpec(
                          //   // domainAxis: set width bar chart
                          //   scaleSpec:
                          //       commonCharts.FixedPixelOrdinalScaleSpec(40),
                          // ),
                          animate: true,
                          userManagedState: _myState,
                          barGroupingType: charts.BarGroupingType.grouped,
                          selectionModels: [
                            new charts.SelectionModelConfig(
                              type: charts.SelectionModelType.info,
                              changedListener: _onSelectionChanged,
                            )
                          ]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  _getListDataWidgets() {
    return isNullOrEmpty(listDataChart)
        ? EmptyScreen()
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listDataChart?.length ?? 0,
            itemBuilder: (context, index) {
              ProjectQuaterChartInfos item = listDataChart[index];
              return ItemBodyAccordingDept(item?.lable, item?.plan);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<ProjectQuaterChartInfos, String>> _createData() {
    List<charts.Series<ProjectQuaterChartInfos, String>> listColumns = [];

    if (isNullOrEmpty(listDataChart)) return [];

    listColumns.add(new charts.Series<ProjectQuaterChartInfos, String>(
      id: 'Statistics',
      colorFn: (ProjectQuaterChartInfos dataType, __) =>
          charts.Color.fromHex(code: '#9ed36a'),
      domainFn: (ProjectQuaterChartInfos dataType, __) =>
          dataType.lable.length > 10
              ? '${dataType.lable.substring(0, 10)}...'
              : dataType.lable,
      measureFn: (ProjectQuaterChartInfos dataType, __) => dataType.plan,
      data: listDataChart,
    ));

    print(listDataChart.length.toString());
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
                      "Chi tiết thưởng theo $nameHeader".toUpperCase(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ItemBuildRowDialog("Mức thưởng",
                      "${model.selectedDatum.first.datum.plan == 0.0 ? 0 : model.selectedDatum.first.datum.plan} tỷ"),
                  ItemBuildRowDialog("$nameHeader",
                      "${model.selectedDatum.first.datum.lable}"),
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
