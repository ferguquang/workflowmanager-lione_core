import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/response/get_data_detail_group_job_report_response.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/details/statistic_list_widget.dart';

class TabStatisticGroupDetailScreen extends StatefulWidget {
  List<ListReportUserJobGroupManagerAPI> members;
  List<ListJob> listJob;

  TabStatisticGroupDetailScreen({this.members, this.listJob});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TabStatisticGroupDetailScreen();
  }
}

class _TabStatisticGroupDetailScreen
    extends State<TabStatisticGroupDetailScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> _listTabs = <Tab>[
    Tab(
      text: "DS thành viên".toUpperCase(),
    ),
    Tab(
      text: "DS công việc nhóm".toUpperCase(),
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._tabController =
        new TabController(vsync: this, length: this._listTabs.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    this._tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverFillRemaining(
        child: DefaultTabController(
      length: this._listTabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(child: Container()),
                  TabBar(
                    isScrollable: false,
                    indicatorColor: Colors.blue[300],
                    // đây là màu trong cái thanh gạch dưới
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black87,
                    tabs: _listTabs,
                  )
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            StatisticListWidget(
              isListMembers: true,
              members: this.widget.members,
            ),
            StatisticListWidget(
              isListMembers: false,
              listJob: this.widget.listJob,
            ),
          ],
        ),
      ),
    ));
  }
}
