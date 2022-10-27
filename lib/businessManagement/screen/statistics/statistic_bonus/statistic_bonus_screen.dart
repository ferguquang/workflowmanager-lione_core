import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

import 'bonus_by_dept/bonus_by_dept_screen.dart';
import 'bonus_top_personal/bonus_top_personal_screen.dart';

class StatisticBonusScreen extends StatefulWidget {
  @override
  _StatisticBonusScreenState createState() => _StatisticBonusScreenState();
}

class _StatisticBonusScreenState extends State<StatisticBonusScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> myTabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTabs = <Tab>[
      ItemTabBarView('Theo phòng ban'),
      ItemTabBarView('Theo chi nhánh'),
      ItemTabBarView('Top thưởng cá nhân'),
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
          BonusByDeptScreen(BonusByDeptScreen.TAB_BONUS_DEPT),
          BonusByDeptScreen(BonusByDeptScreen.TAB_BONUS_BRANCH),
          BonusTopPersonalScreen(BonusTopPersonalScreen.TAB_BONUS_TOP_PERSONAL),
        ],
      ),
    );
  }
}
