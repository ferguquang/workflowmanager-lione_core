import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/list_statistic_group_task_screen.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/personal/chart_statistic_personal_task_screen.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/personal/list_statistic_personal_task_screen.dart';

class MainStatisticPersonalTaskScreen extends StatefulWidget {
  int idJobGroup;

  MainStatisticPersonalTaskScreen({this.idJobGroup});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainStatisticPersonalTaskScreen();
  }
}

class _MainStatisticPersonalTaskScreen
    extends State<MainStatisticPersonalTaskScreen> {
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
            title: Text('Báo cáo nhóm - Cá nhân'),
            bottom: TabBar(
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              tabs: this.topTabs,
            ),
          ),
          body: new TabBarView(children: <Widget>[
            ChartStatisticPersonalTaskScreen(
              idGroupJob: this.widget.idJobGroup,
            ),
            ListStatisticPersonalTaskScreen(
              idJobGroup: this.widget.idJobGroup,
            ),
          ]),
        ),
      ),
    );
  }
}
