import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/screens/details/task_details_screen_head/task_details_screen_head.dart';
import 'package:workflow_manager/workflow/screens/tasks/repository/list_task_tab_repository.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/models/event/view_mode_event.dart';

import 'list_tasks_screen.dart';

// Hiển thị tab: Chưa xử lý, Đang xử lý, Hoàn thành, Tạm dừng, Từ chối...
class ListTasksTabScreen extends StatefulWidget {
  int viewType; //phân biệt các tab Được giao, Đã giao, Phối hợp, Tạo mới, Thêm

  ListTasksTabScreen({this.viewType});

  @override
  State<StatefulWidget> createState() {
    return _ListTasksTopTabItemScreen();
  }
}

class _ListTasksTopTabItemScreen extends State<ListTasksTabScreen>
    with TickerProviderStateMixin {
  ListTaskTabRepository _listTaskTabRepository = ListTaskTabRepository();

  @override
  void initState() {
    super.initState();
    this._listTaskTabRepository.getListFilterTask(this.widget.viewType);

    eventBus.on<ViewModeEvent>().listen((event) {
      if (this.widget.viewType != AppStore.currentViewTypeWorkflow) {
        return;
      }
      this._listTaskTabRepository.getListFilterTask(this.widget.viewType);
    });
    eventBus.on<OnJobStatusChanged>().listen((event) {
      if (event.viewType == widget.viewType) {
        this._listTaskTabRepository.getListFilterTask(this.widget.viewType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _listTaskTabRepository,
      child: Consumer(
        builder: (context, ListTaskTabRepository repository, _) {
          return Scaffold(
            body: DefaultTabController(
              length: repository.tabItem.length,
              child: (repository.tabItem == null ||
                      repository.tabItem?.length == 0)
                  ? EmptyScreen(message: repository.messageError)
                  : Scaffold(
                      appBar: new PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: new Container(
                          color: Colors.white,
                          child: new SafeArea(
                            child: Column(
                              children: <Widget>[
                                new Expanded(
                                  child: new Container(),
                                ),
                                new TabBar(
                                  isScrollable: true,
                                  labelColor: Colors.blue,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: repository.tabItem.isEmpty
                                      ? <Widget>[]
                                      : repository.tabItem,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        // controller: _tabController,
                        children: getTabView(),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  List<StatusItem> status;
  List<Widget> listTabView;

  List<Widget> getTabView() {
    if (isNotNullOrEmpty(listTabView) && !_listTaskTabRepository.isChangeData) {
      return listTabView;
    }
    status = _listTaskTabRepository.arrayStatuses;
    List<Widget> list = _listTaskTabRepository.arrayStatuses.isEmpty
        ? <Widget>[]
        : _listTaskTabRepository.arrayStatuses.map((content) {
            return ListTasksScreen(
              viewType: this.widget.viewType,
              idStatus: content.key,
            );
          }).toList();
    listTabView = list;
    _listTaskTabRepository.isChangeData = false;
    return list;
  }
}
