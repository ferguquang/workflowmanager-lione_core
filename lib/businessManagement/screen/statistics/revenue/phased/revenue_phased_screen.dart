import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/phased/administrative/administrative_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/phased/revenue_phased_repository.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

import '../../../../../main.dart';

// doanh thu - theo giai đoạn
class RevenuePhasedScreen extends StatefulWidget {

  static const int TAB_REVENUE_PHASED = 30; // Doanh thu theo giai đoạn

  @override
  _RevenuePhasedScreenState createState() => _RevenuePhasedScreenState();
}

class _RevenuePhasedScreenState extends State<RevenuePhasedScreen>
    with SingleTickerProviderStateMixin {
  RevenuePhasedRepository _repository = RevenuePhasedRepository();
  TabController _tabController;
  List<Tab> myTabs = [];
  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDataByStateBusinessManager();

    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      switch (event.numberTabFilter) {
        case RevenuePhasedScreen.TAB_REVENUE_PHASED:
          setState(() {
            request = event.request;
            _repository.getDataByStateBusinessManager(
                RevenuePhasedScreen.TAB_REVENUE_PHASED, request);
          });
          break;
      }
    });
  }

  _getDataByStateBusinessManager() async {
    await _repository.getDataByStateBusinessManager(
        RevenuePhasedScreen.TAB_REVENUE_PHASED, request);
    if (isNotNullOrEmpty(_repository.dataRevenuePhased) &&
        isNotNullOrEmpty(_repository.dataRevenuePhased?.phaseTypeCharts)) {
      myTabs.clear();
      _repository.dataRevenuePhased?.phaseTypeCharts?.forEach((element) {
        myTabs.add(ItemTabBarView(element.name));
      });
    }
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, RevenuePhasedRepository _repository1, child) =>
            DefaultTabController(
          length: myTabs?.length ?? 0,
          child: (isNullOrEmpty(myTabs))
              ? EmptyScreen()
              : Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: Container(
                      color: Colors.white,
                      child: SafeArea(
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              indicatorColor: Colors.blue,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.grey,
                              tabs: myTabs,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: getTabView(),
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> getTabView() {
    List<Widget> list = isNullOrEmpty(_repository.dataRevenuePhased) ||
            isNullOrEmpty(_repository.dataRevenuePhased?.phaseTypeCharts)
        ? <Widget>[]
        : _repository.dataRevenuePhased.phaseTypeCharts.map((content) {
            return AdministrativeScreen(
                content.phaseReport, _repository.colorNotes, content?.iD);
          }).toList();
    return list;
  }
}
