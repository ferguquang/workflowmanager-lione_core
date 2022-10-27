import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/manager/chart_statistic_manager_task_screen.dart';

import 'list_statistic_manager_task_screen.dart';

class MainStatisticManagerTaskScreen extends StatefulWidget {
  int idJobGroup;

  MainStatisticManagerTaskScreen({this.idJobGroup});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainStatisticManagerTaskScreen();
  }
}

class _MainStatisticManagerTaskScreen
    extends State<MainStatisticManagerTaskScreen> {
  final List<Tab> topTabs = <Tab>[
    Tab(text: 'Biểu đồ'.toUpperCase()),
    Tab(text: 'Danh sách'.toUpperCase()),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Báo cáo nhóm - Quản lý'),
            bottom: TabBar(
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              tabs: this.topTabs,
            ),
          ),
          body: new TabBarView(children: <Widget>[
            ChartStatisticManagerTaskScreen(
              idGroupJob: this.widget.idJobGroup,
            ),
            ListStatisticManagerTaskScreen(
              idJobGroup: this.widget.idJobGroup,
            ),
          ]),
        ),
      ),
    );
  }
}
