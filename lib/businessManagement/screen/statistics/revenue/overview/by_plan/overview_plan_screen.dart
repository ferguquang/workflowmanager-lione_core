import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/by_plan/percent_gird_view.dart';

import '../../../../../../main.dart';
import '../../item_build_row_dialog.dart';
import '../item_dot_actual_overview.dart';
import 'item_by_plan.dart';
import 'item_by_plan_overview.dart';

//Doanh thu - tổng quan - theo kế hoạch
class OverviewPlanScreen extends StatefulWidget {
  DataOverView dataOverView;
  int statusTab = 0;

  static const int TAB_PLAN = 1; // theo kế hoạch
  static const int TAB_QUATER = 2; // theo quý
  static const int TAB_BRANCH = 3; // theo chi nhánh
  static const int TAB_DEPT = 4; // theo phòng ban
  static const int TAB_CUSTOM = 5; // theo khách hàng
  static const int TAB_MARKETING = 6; // theo chiến dịch marketing

  OverviewPlanScreen({this.statusTab, this.dataOverView});

  @override
  _OverviewPlanScreenState createState() => _OverviewPlanScreenState();
}

class _OverviewPlanScreenState extends State<OverviewPlanScreen> {
  List<charts.Series> seriesList = List();
  final _myState = new charts.UserManagedState<String>();

  List<ProjectQuaterChartInfos> listDataChart = [];
  List<ColorNotes> listDotActual;
  String title = '';
  String headerName = '';
  StreamSubscription _dataListChartPlan;

  String colorPlan = '#C28BFC'; // màu cột kế hoạch
  String colorCommited = '#5db2ff'; // màu cột dự kiến
  bool isShowColumnPlan = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getTypeTab();

      _listenerEventBus();
    });
  }

  _listenerEventBus() {
    if (isNotNullOrEmpty(_dataListChartPlan)) _dataListChartPlan.cancel();
    _dataListChartPlan =
        eventBus.on<GetListDataOverviewEventBus>().listen((event) {
      // truyền từ overview_repository.dart qua
      setState(() {
        if (isNullOrEmpty(listDotActual)) listDotActual = event.colorNotes;

        switch (widget.statusTab) {
          case OverviewPlanScreen.TAB_PLAN:
            listDataChart = event.dataOverView?.projectBarChartInfos;
            break;
          case OverviewPlanScreen.TAB_QUATER:
            listDataChart = event.dataOverView?.projectQuaterChartInfos;
            break;
          case OverviewPlanScreen.TAB_BRANCH:
            listDataChart = event.dataOverView?.projectPieChartChiNhanh;
            break;
          case OverviewPlanScreen.TAB_DEPT:
            listDataChart = event.dataOverView?.projectPieChartPB;
            break;
          case OverviewPlanScreen.TAB_CUSTOM:
            listDataChart = event.dataOverView?.sourceBarChartInfos;
            break;
          case OverviewPlanScreen.TAB_MARKETING:
            listDataChart = event.dataOverView?.campaignBarChartInfos;
            break;
        }
        seriesList = _createData();
      });
    });
  }

  _getTypeTab() {
    switch (widget.statusTab) {
      case OverviewPlanScreen.TAB_PLAN:
        listDataChart = widget.dataOverView?.projectBarChartInfos;
        title = "TIẾN ĐỘ DỰ ÁN THEO KẾ HOẠCH";
        headerName = "Loại dự án";
        isShowColumnPlan = true;
        break;
      case OverviewPlanScreen.TAB_QUATER:
        listDataChart = widget.dataOverView?.projectQuaterChartInfos;
        title = "TIẾN ĐỘ DỰ ÁN THEO QUÝ";
        headerName = "Quý";
        isShowColumnPlan = true;
        break;
      case OverviewPlanScreen.TAB_BRANCH:
        listDataChart = widget.dataOverView?.projectPieChartChiNhanh;
        title = "TIẾN ĐỘ DỰ ÁN THEO CHI NHÁNH";
        isShowColumnPlan = true;
        headerName = "Chi nhánh";
        break;
      case OverviewPlanScreen.TAB_DEPT:
        listDataChart = widget.dataOverView?.projectPieChartPB;
        title = "TIẾN ĐỘ DỰ ÁN THEO PHÒNG BAN";
        headerName = "Phòng ban";
        isShowColumnPlan = true;
        break;
      case OverviewPlanScreen.TAB_CUSTOM:
        listDataChart = widget.dataOverView?.sourceBarChartInfos;
        title = "TIẾN ĐỘ DỰ ÁN THEO NGUỒN KHÁCH HÀNG";
        headerName = "Khách hàng";
        break;
      case OverviewPlanScreen.TAB_MARKETING:
        listDataChart = widget.dataOverView?.campaignBarChartInfos;
        title = "TIẾN ĐỘ DỰ ÁN THEO CHIẾN DỊCH MARKETING";
        headerName = "Chiến dịch marketing";
        break;
    }

    if (isNotNullOrEmpty(widget.dataOverView?.colorNotes)) {
      listDotActual = widget.dataOverView?.colorNotes[0]?.percentNotes;
    }
    seriesList = _createData();
    setState(() {});
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
                title,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              child: Text(
                'Tổng doanh thu thực tế: ${widget.dataOverView?.actualTotalMoney ?? '0 tỷ'} - Tổng doanh thu dự kiến ${widget.dataOverView?.planTotalMoney ?? '0 tỷ'}',
                style: TextStyle(color: Colors.black, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            _getDataChartWidgets(),
            _getLegendChart(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PercentGirdView(listDotActual),
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
                    child: Text(
                      headerName,
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
                      width: this.listDataChart.length *
                          (Constant.CHART_WIDTH2 * seriesList?.length +
                              Constant.CHART_DISTANCE5),
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
            child: Visibility(
              visible: isShowColumnPlan,
              child: ItemDotActualOverView(
                sColors: colorPlan,
                text: 'Kế hoạch',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: ItemDotActualOverView(
              sColors: colorCommited,
              text: 'Dự kiến',
            ),
          ),
        ],
      ),
    );
  }

  // danh sách listView
  _getListDataWidgets() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listDataChart?.length ?? 0,
      itemBuilder: (context, index) {
        // tab khách hàng và marketing thì thực tế chia dự kiến
        // các tab còn lại thì thực tế chia dự kiến
        return widget.statusTab == OverviewPlanScreen.TAB_CUSTOM ||
                widget.statusTab == OverviewPlanScreen.TAB_MARKETING
            ? ItemByPlan(listDataChart[index])
            : ItemByPlanOverView(listDataChart[index]);
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
              ? typeRecords.lable.substring(0, 15) + '...'
              : typeRecords.lable,
      measureFn: (ProjectQuaterChartInfos typeRecords, _) => typeRecords.actual,
      data: listDataChart,
    );
    listColumns.add(actual);

    if (isShowColumnPlan) {
      // cột kế hoạch
      var plan = new charts.Series<ProjectQuaterChartInfos, String>(
        id: 'Sales',
        colorFn: (ProjectQuaterChartInfos typeRecords, __) =>
            charts.Color.fromHex(code: colorPlan),
        domainFn: (ProjectQuaterChartInfos typeRecords, _) =>
            typeRecords.lable.length > 15
                ? typeRecords.lable.substring(0, 15) + '...'
                : typeRecords.lable,
        measureFn: (ProjectQuaterChartInfos typeRecords, _) =>
            typeRecords.committed,
        data: listDataChart,
      );
      listColumns.add(plan);
    }

    //cột dự kiến
    var commited = new charts.Series<ProjectQuaterChartInfos, String>(
      id: 'Sales',
      colorFn: (ProjectQuaterChartInfos typeRecords, __) =>
          charts.Color.fromHex(code: colorCommited),
      domainFn: (ProjectQuaterChartInfos typeRecords, _) =>
          typeRecords.lable.length > 15
              ? typeRecords.lable.substring(0, 15) + '...'
              : typeRecords.lable,
      measureFn: (ProjectQuaterChartInfos typeRecords, _) => typeRecords.plan,
      data: listDataChart,
    );
    listColumns.add(commited);

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
                      "Thống kê chi tiết ${widget.statusTab == OverviewPlanScreen.TAB_CUSTOM || widget.statusTab == OverviewPlanScreen.TAB_MARKETING ? "" : model.selectedDatum.first.datum.lable}"
                          .toUpperCase(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Visibility(
                    visible: widget.statusTab ==
                            OverviewPlanScreen.TAB_CUSTOM ||
                        widget.statusTab == OverviewPlanScreen.TAB_MARKETING,
                    child: ItemBuildRowDialog(
                        widget.statusTab == OverviewPlanScreen.TAB_CUSTOM
                            ? "Nguồn khách hàng: "
                            : "Chiến dịch marketing",
                        model.selectedDatum.first.datum.lable),
                  ),
                  ItemBuildRowDialog("Giá trị thực tế",
                      "${model.selectedDatum.first.datum.actual} tỷ"),
                  Visibility(
                    visible: isShowColumnPlan,
                    child: ItemBuildRowDialog("Giá trị kế hoạch",
                        "${model.selectedDatum.first.datum.committed} tỷ"),
                  ),
                  ItemBuildRowDialog("Giá trị dự kiến",
                      "${model.selectedDatum.first.datum.plan} tỷ"),
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
