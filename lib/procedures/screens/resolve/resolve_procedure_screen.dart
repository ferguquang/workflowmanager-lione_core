import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/custom_tab_bar_widget.dart';
import 'package:workflow_manager/base/utils/change_notifier_base.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/list_resolve_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';

import 'list/list_resolve_screen.dart';

class ResolveProcedureScreen extends StatefulWidget {
  @override
  _ResolveProcedureScreenState createState() => _ResolveProcedureScreenState();
}

class _ResolveProcedureScreenState extends State<ResolveProcedureScreen> {
  List<Tab> myTabs = <Tab>[];

  TabController _tabController;
  int recordTotalPending = 0;
  int recordTotalProcessed = 0;
  int recordTotalResented = 0;
  int recordTotalStar = 0;
  StreamSubscription listen;
  ChangeNotifierBase tabNotifier = ChangeNotifierBase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    createTab();
    listen = eventBus.on<DataResolve>().listen((event) {
      recordTotalPending = event.recordTotalPending;
      recordTotalProcessed = event.recordTotalProcessed;
      recordTotalResented = event.recordTotalResented;
      recordTotalStar = event.recordTotalStar;

      myTabs.clear();
      createTab();
      tabNotifier.notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    listen.cancel();
  }

  void createTab() {
    myTabs = <Tab>[
      Tab(
          child:
              CustomTabBarWidget("Hồ sơ cần giải quyết", recordTotalPending)),
      Tab(
          child:
              CustomTabBarWidget("Hồ sơ đã giải quyết", recordTotalProcessed)),
      Tab(child: CustomTabBarWidget("Cần bổ sung", recordTotalResented)),
      Tab(child: CustomTabBarWidget("Có gắn sao", recordTotalStar)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainScreen(),
    );
  }

  Widget _mainScreen() {
    return DefaultTabController(
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
                  ChangeNotifierProvider.value(
                    value: tabNotifier,
                    child: Consumer(
                      builder:
                          (context, ChangeNotifierBase tabNotifier, child) {
                        return TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.blue,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black87,
                          tabs: myTabs,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListResolveScreen(ListResolveScreen.TYPE_PENDING),
            ListResolveScreen(ListResolveScreen.TYPE_PROCESSED),
            ListResolveScreen(ListResolveScreen.TYPE_COMPLEMENTARY),
            ListResolveScreen(ListResolveScreen.TYPE_STAR),
          ],
        ),
      ),
    );
  }
}
