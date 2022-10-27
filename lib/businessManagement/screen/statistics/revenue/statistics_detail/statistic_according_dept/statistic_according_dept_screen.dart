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
import 'package:workflow_manager/businessManagement/model/response/statistic_detail_response.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistic_according_dept/item_dot_actual_dept.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistic_according_dept/statistic_according_dept_repository.dart';

import '../../../../../../main.dart';
import '../../item_build_row_dialog.dart';
import 'detail_dept/detail_dept_screen.dart';
import 'item_body_according_dept.dart';
import 'item_header_according_dept.dart';

//doanh thu - thống kê chi tiết - theo phòng ban
class StatisticAccordingDeptScreen extends StatefulWidget {
  int statusTab = 0;

  StatisticAccordingDeptScreen(this.statusTab);

  static const int TAB_DEPT = 11; // phòng ban
  static const int TAB_SELLER = 12; // seller
  static const int TAB_AREA = 13; // tình thành (vùng)
  static const int TAB_CUSTOM = 14; // khách hàng

  @override
  _StatisticAccordingDeptScreenState createState() =>
      _StatisticAccordingDeptScreenState();
}

class _StatisticAccordingDeptScreenState
    extends State<StatisticAccordingDeptScreen> {
  StatisticAccordingDeptRepository _repository =
      StatisticAccordingDeptRepository();
  double _aspectRatio = 7.0, _crossAxisSpacing = 0.2, _mainAxisSpacing = 0.2;
  List<charts.Series> seriesList = List();
  final _myState = new charts.UserManagedState<String>();

  List<ProjectPlans> listDataChart;
  String title = '';
  String headerName = '';
  String nameCate = '';
  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataChart();
    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      switch (widget.statusTab) {
        case StatisticAccordingDeptScreen.TAB_DEPT:
        case StatisticAccordingDeptScreen.TAB_SELLER:
        case StatisticAccordingDeptScreen.TAB_AREA:
        case StatisticAccordingDeptScreen.TAB_CUSTOM:
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
    super.dispose();
    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
  }

  _getDataChart() async {
    if (widget.statusTab == StatisticAccordingDeptScreen.TAB_DEPT) {
      title = "THỐNG KÊ CHI TIẾT THEO PHÒNG BAN";
      nameCate = 'Phòng ban';
    } else if (widget.statusTab == StatisticAccordingDeptScreen.TAB_SELLER) {
      title = "THỐNG KÊ CHI TIẾT THEO SELLER";
      nameCate = 'Seller';
    } else if (widget.statusTab == StatisticAccordingDeptScreen.TAB_AREA) {
      title = "THỐNG KÊ CHI TIẾT THEO VÙNG";
      nameCate = 'Vùng';
    } else {
      title = "TIẾN ĐỘ DỰ ÁN THEO KHÁCH HÀNG";
      nameCate = 'Khách hàng';
    }
    await _repository.getProjecTreportDept(widget.statusTab, request);
    listDataChart = _repository.dataStatisticDetail.projectPlans;
    setState(() {
      seriesList = _createData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder:
            (context, StatisticAccordingDeptRepository _repository, child) {
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
                  _getGirdViewPercentWidgets(),
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
                  "Doanh số (Tỷ đồng)",
                  style: TextStyle(fontSize: 12),
                ))),
        Expanded(
          child: _repository.series.length == 0
              ? EmptyScreen()
              : Container(
                  height: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: listDataChart.length == 1
                          ? 350
                          : this.listDataChart.length *
                              (Constant.CHART_WIDTH * seriesList?.length +
                                  Constant.CHART_DISTANCE5),
                      padding: EdgeInsets.all(8),
                      child: charts.BarChart(seriesList,
                          animate: true,
                          // domainAxis: charts.OrdinalAxisSpec(
                          //   scaleSpec:
                          //       commonCharts.FixedPixelOrdinalScaleSpec(90),
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

  _getGirdViewPercentWidgets() {
    return isNullOrEmpty(listDataChart) ||
            isNullOrEmpty(listDataChart[0].series)
        ? EmptyScreen()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listDataChart[0].series.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: _aspectRatio,
                crossAxisSpacing: _crossAxisSpacing,
                mainAxisSpacing: _mainAxisSpacing,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                SeriesDept item = listDataChart[0].series[index];
                return ItemDotActualDept(
                  text: item.name,
                  sColors: item.color,
                );
              },
            ),
          );
  }

  _getListDataWidgets() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _repository.listData.length,
      itemBuilder: (context, index) {
        SeriesDept item = _repository.listData[index];
        return item.isHeader
            ? ItemHeaderAccordingDept(item?.name, 'Doanh thu')
            : ItemBodyAccordingDept(item?.name, item?.data);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<SeriesDept, String>> _createData() {
    List<charts.Series<SeriesDept, String>> listColumns = [];

    if (isNullOrEmpty(listDataChart)) return [];

    // hàm này để convert lại list theo ý mình
    List<List<SeriesDept>> listDept = [];
    for (int i = 0; i < listDataChart[0].series.length; i++) {
      List<SeriesDept> listSeries = [];
      for (int j = 0; j < listDataChart.length; j++) {
        SeriesDept seriesDept = listDataChart[j].series[i];
        listSeries.add(seriesDept);
      }
      listDept.add(listSeries);
    }

    listDept.forEach((element) {
      listColumns.add(new charts.Series<SeriesDept, String>(
        id: 'Statistics',
        colorFn: (SeriesDept dataType, __) =>
            charts.Color.fromHex(code: dataType.color),
        domainFn: (SeriesDept dataType, __) => dataType.year,
        measureFn: (SeriesDept dataType, __) => dataType.data,
        data: element,
      ));
    });
    return listColumns;
  }

  _onSelectionChanged(charts.SelectionModel model) /*async*/ {
    if (model.selectedDatum.length <= 0) return;

    int position =
        _repository.getIndexProjectPlan(model.selectedDatum.first.datum.idYear);
    List<SeriesDept> series =
        _repository.dataStatisticDetail.projectPlans[position].series;

    CustomDialogWidget(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Thống kê chi tiết ${model.selectedDatum.first.datum.year}"
                        .toUpperCase(),
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(
                    height: series.length * 30.0 + 50.0,
                    alignment: Alignment.center,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: series.length,
                      itemBuilder: (context, index) {
                        SeriesDept item = series[index];
                        return InkWell(
                          onTap: () {
                            Cate cate = Cate();
                            _repository
                                .dataStatisticDetail.projectPlans[position].cate
                                .forEach((element) {
                              if (item?.iD.toString() == element?.iD) {
                                cate = element;
                              }
                            });
                            pushPage(
                                context,
                                DetailDeptScreen(cate, title, item?.color,
                                    nameCate, item.year));
                          },
                          child: ItemBuildRowDialog(item?.name,
                              '${item?.data == 0.0 ? '0' : item?.data.toString()} tỷ'),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  )
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
