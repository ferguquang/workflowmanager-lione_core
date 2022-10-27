import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

import 'expected_plan/expected_plan_screen.dart';
import 'expected_year/expected_year_screen.dart';

class ExpectedRevenueScreen extends StatefulWidget {
  @override
  _ExpectedRevenueScreenState createState() => _ExpectedRevenueScreenState();
}

class _ExpectedRevenueScreenState extends State<ExpectedRevenueScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> myTabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTabs = <Tab>[
      ItemTabBarView('Các năm gần đây'),
      ItemTabBarView('Theo quý'),
      ItemTabBarView('Theo tháng'),
      ItemTabBarView('Theo kế hoạch'),
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
          ExpectedYearScreen(ExpectedYearScreen.TAB_EXPECTED_REVENUE),
          ExpectedYearScreen(ExpectedYearScreen.TAB_EXPECTED_QUARTER),
          ExpectedYearScreen(ExpectedYearScreen.TAB_EXPECTED_MONTH),
          ExpectedPlanScreen(ExpectedPlanScreen.TAB_EXPECTED_PLAN),
        ],
      ),
    );
  }
}
