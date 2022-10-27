import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/by_time/revenue_time_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/overview_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/phased/revenue_phased_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistics_detail_screen.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

// doanh thu
class RevenueScreen extends StatefulWidget {
  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> myTabs;
  // OverViewRepository _repository = OverViewRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTabs = <Tab>[
      ItemTabBarView('Tổng quan'),
      ItemTabBarView('Thống kê chi tiết'),
      ItemTabBarView('Theo thời gian'),
      ItemTabBarView('Theo giai đoạn'),
    ];
    _tabController = new TabController(vsync: this, length: myTabs.length);
    // _repository.getProjecTreportIndex();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        children: [
          OverviewScreen(), // Tổng quan
          StatisticsDetailScreen(), // Thống kê chi tiết
          RevenueTimeScreen(RevenueTimeScreen.TAB_BY_TIME), // Theo thời gian
          RevenuePhasedScreen(), // Theo giai đoạn
        ],
      ),
    );
  }
}
