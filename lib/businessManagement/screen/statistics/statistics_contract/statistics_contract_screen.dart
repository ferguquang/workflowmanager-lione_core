import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

import 'list_contract/list_contract_screen.dart';
import 'top_contract/top_contract_screen.dart';

//Hợp đồng
class StatisticsContractScreen extends StatefulWidget {
  @override
  _StatisticsContractScreenState createState() =>
      _StatisticsContractScreenState();
}

class _StatisticsContractScreenState extends State<StatisticsContractScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> myTabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTabs = <Tab>[
      ItemTabBarView('Top hợp đồng'),
      ItemTabBarView('Danh sách hợp đồng'),
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
          TopContractScreen(TopContractScreen.TAB_TOP_CONTRACT),
          ListContractScreen(ListContractScreen.TAB_LIST_CONTRACT),
        ],
      ),
    );
  }
}
