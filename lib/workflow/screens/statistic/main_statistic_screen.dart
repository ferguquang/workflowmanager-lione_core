import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/chart_statistic_group_task_screen.dart';

class MainStatisticScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainStatisticScreen();
  }
}

class _MainStatisticScreen extends State<MainStatisticScreen> {
  // bool _isReportGroup = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Báo cáo nhóm"),
      ),
      body: ChartStatisticGroupTaskScreen(), //MainStatisticGroupTaskScreen(),
    );
  }

  // Widget _buildMenu(IconData icon, String text) {
  //   return Row(children: [Text(text)]);
  // }
}
