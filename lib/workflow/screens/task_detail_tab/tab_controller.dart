import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/processed_content/processed_content_widget.dart';

import 'comment/comment_widget.dart';
import 'history/history_widget.dart';

class TaskDetailTabController extends StatefulWidget {
  int taskId;
  TaskDetailTabController(this.taskId);

  @override
  _TaskDetailTabControllerState createState() =>
      _TaskDetailTabControllerState();
}

class _TaskDetailTabControllerState extends State<TaskDetailTabController>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Bình luận'.toUpperCase()),
    Tab(text: 'Lịch sử'.toUpperCase()),
    Tab(text: 'Nội dung đã xử lý'.toUpperCase()),
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
      child: DefaultTabController(
        length: myTabs.length,
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
                      isScrollable: true,
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.black87,
                      tabs: myTabs,
                    )
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              CommentWidget(widget.taskId),
              HistoryWidget(widget.taskId),
              ProcessedContentWidget(widget.taskId),
            ],
          ),
        ),
      )
    );
  }
}
