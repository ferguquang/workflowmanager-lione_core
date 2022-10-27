import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/response/list_group_task_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/event/event_group_task.dart';
import 'package:workflow_manager/workflow/screens/group_job/list_group_job_screen.dart';

import 'create_group/create_group_screen.dart';
import 'repository/group_task_repository.dart';

class GroupTaskTabController extends StatefulWidget {
  @override
  _GroupTaskTabControllerState createState() => _GroupTaskTabControllerState();
}

class _GroupTaskTabControllerState extends State<GroupTaskTabController>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  GroupTaskRepository groupTaskRepository = GroupTaskRepository();
  TabController _tabController;
  bool canCreateAndDeleteGroupJob = false;
  List<StatusGroup> status = [];

  @override
  void initState() {
    super.initState();
    _getStatusGroupTask();
    eventBus.on<GetRoleForGroupList>().listen((event) {
      canCreateAndDeleteGroupJob = event.canCreateAndDeleteGroupJob;
      groupTaskRepository.notifyListeners();
    });
  }

  _getStatusGroupTask() async {
    await groupTaskRepository.getStatusGroupTask();
    status = groupTaskRepository.status;

    _tabController = new TabController(vsync: this, length: status?.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return groupTaskRepository;
      },
      child: Consumer<GroupTaskRepository>(
        builder: (BuildContext context, GroupTaskRepository repository,
            Widget child) {
          return DefaultTabController(
            length: status.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Nhóm công việc'),
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelPadding: EdgeInsets.symmetric(horizontal: 16),
                  tabs: getListTab(status),
                ),
                actions: [
                  Visibility(
                    visible: canCreateAndDeleteGroupJob,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: PopupMenuButton(
                        child: Container(child: Icon(Icons.more_vert)),
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              {
                                int status = _tabController.index + 1;
                                // int  index = DefaultTabController.of(context).index;
                                eventBus.fire(EventSelectGroup(status));
                                break;
                              }
                            case 1:
                              {
                                // tạo nhóm
                                pushPage(context, CreateGroupScreen(true));
                                break;
                              }
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                value: 0,
                                child: _buildMenu(
                                    Icons.add_box_outlined, "Chọn nhóm")),
                            PopupMenuItem(
                              value: 1,
                              child: _buildMenu(Icons.add, "Tạo nhóm"),
                            ),
                          ];
                        },
                      ),
                    ),
                  )
                ],
              ),
              body: TabBarView(
                  controller: _tabController,
                  children: status.map((content) {
                    return ListGroupTaskWidget(
                      status: content.key,
                      statusGroups: status,
                    );
                  }).toList()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenu(IconData icon, String text) {
    return Row(children: [
      Icon(
        icon,
        color: Colors.grey,
      ),
      Text('  $text')
    ]);
  }

  List<Tab> getListTab(List<StatusGroup> status) {
    List<Tab> tabs = [];
    for (int i = 0; i < status.length; i++) {
      tabs.add(Tab(text: status[i].value.toUpperCase()));
    }
    return tabs;
  }

  @override
  bool get wantKeepAlive => true;
}
