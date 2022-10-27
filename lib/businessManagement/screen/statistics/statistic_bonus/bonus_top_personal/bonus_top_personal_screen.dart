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
import 'package:workflow_manager/businessManagement/model/response/statistic_seller_response.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/item_build_row_dialog.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistic_according_dept/item_header_according_dept.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/statistic_seller/list_seller/item_top_seller.dart';

import '../../../../../main.dart';
import 'bonus_top_personal_repository.dart';

// thưởng - top thưởng cá nhân
class BonusTopPersonalScreen extends StatefulWidget {
  int statusTab = 0;

  static const int TAB_BONUS_TOP_PERSONAL = 62; // top thưởng cá nhân

  BonusTopPersonalScreen(this.statusTab);

  @override
  _BonusTopPersonalScreenState createState() => _BonusTopPersonalScreenState();
}

class _BonusTopPersonalScreenState extends State<BonusTopPersonalScreen> {
  var _repository = BonusTopPersonalRepository();
  List<charts.Series> seriesList = List();
  final _myState = new charts.UserManagedState<String>();

  List<SellerInfos> listDataChart;
  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  @override
  void initState() {
    super.initState();

    _getDataChart();

    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      if (event.numberTabFilter ==
          BonusTopPersonalScreen.TAB_BONUS_TOP_PERSONAL) {
        setState(() {
          request = event.request;
          _getDataChart();
        });
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
    listDataChart = _repository.dataTopPersonal.bonusCNBarChartInfos;
    seriesList = _createData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, BonusTopPersonalRepository _repository1, child) {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 32, bottom: 32),
                    child: Text(
                      'TOP THƯỞNG CÁ NHÂN',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  _getDataChartWidgets(),
                  ItemHeaderAccordingDept(
                    'Nhân viên',
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
                  "Mức thưởng(Triệu đồng)",
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
              SellerInfos item = listDataChart[index];
              return ItemTopSeller(item, index);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<SellerInfos, String>> _createData() {
    List<charts.Series<SellerInfos, String>> listColumns = [];

    if (isNullOrEmpty(listDataChart)) return [];

    listColumns.add(new charts.Series<SellerInfos, String>(
      id: 'Statistics',
      colorFn: (SellerInfos dataType, __) =>
          charts.Color.fromHex(code: '#9ed36a'),
      domainFn: (SellerInfos dataType, __) => dataType.sellerName.length > 10
          ? '${dataType.sellerName.substring(0, 10)}...'
          : dataType.sellerName,
      measureFn: (SellerInfos dataType, __) => dataType.percent,
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
                      "Chi tiết thưởng theo cá nhân".toUpperCase(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ItemBuildRowDialog(
                      "Mức thưởng: ", model.selectedDatum.first.datum.value),
                  ItemBuildRowDialog("Cá nhân: ",
                      "${model.selectedDatum.first.datum.sellerName}"),
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
