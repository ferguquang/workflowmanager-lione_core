import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_tab_controller/comment/comment_group.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_tab_controller/history/history_group.dart';

class GroupTabController extends StatefulWidget {
  int taskId;
  GroupTabController(this.taskId);

  @override
  _GroupTabControllerState createState() =>
      _GroupTabControllerState();
}

class _GroupTabControllerState extends State<GroupTabController>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Bình luận'.toUpperCase()),
    Tab(text: 'Lịch sử'.toUpperCase()),
  ];

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: myTabs.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        hasScrollBody: true,
        child: DefaultTabController(
          length: myTabs.length,
          child: Scaffold(
            // resizeToAvoidBottomPadding: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.black87,
                      tabs: myTabs,
                    )
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                CommentGroupWidget(widget.taskId),
                HistoryGroupWidget(widget.taskId),
              ],
            ),
          ),
        ));
  }
}
