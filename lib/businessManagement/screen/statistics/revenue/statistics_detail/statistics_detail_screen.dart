import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistic_according_dept/statistic_according_dept_screen.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

// doanh thu - thống kê chi tiết
class StatisticsDetailScreen extends StatefulWidget {
  @override
  _StatisticsDetailScreenState createState() => _StatisticsDetailScreenState();
}

class _StatisticsDetailScreenState extends State<StatisticsDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> myTabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTabs = <Tab>[
      ItemTabBarView('Theo phòng ban'),
      ItemTabBarView('Theo seller'),
      ItemTabBarView('Theo vùng'),
      ItemTabBarView('Theo khách hàng'),
    ];
    _tabController = new TabController(vsync: this, length: myTabs.length);
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
          StatisticAccordingDeptScreen(StatisticAccordingDeptScreen.TAB_DEPT),
          StatisticAccordingDeptScreen(StatisticAccordingDeptScreen.TAB_SELLER),
          StatisticAccordingDeptScreen(StatisticAccordingDeptScreen.TAB_AREA),
          StatisticAccordingDeptScreen(StatisticAccordingDeptScreen.TAB_CUSTOM),
        ],
      ),
    );
  }
}
