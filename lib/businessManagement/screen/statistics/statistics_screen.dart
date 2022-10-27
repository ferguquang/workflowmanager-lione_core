import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/revenue_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/statistics_contract/statistics_contract_screen.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

import 'expected_revenue/expected_revenue_screen.dart';
import 'statistic_bonus/statistic_bonus_screen.dart';
import 'statistic_seller/statistic_seller_screen.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> myTabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTabs = <Tab>[
      ItemTabBarView('Doanh thu'),
      ItemTabBarView('Hợp đồng'),
      ItemTabBarView('Seller'),
      ItemTabBarView('Thưởng'),
      ItemTabBarView('Doanh thu dự kiến'),
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
          color: Colors.blue,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(child: Container()),
                Container(
                  color: Colors.blue,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.blue,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[250],
                    tabs: myTabs,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RevenueScreen(),
          StatisticsContractScreen(),
          StatisticSellerScreen(),
          StatisticBonusScreen(),
          ExpectedRevenueScreen(),
        ],
      ),
    );
  }
}
