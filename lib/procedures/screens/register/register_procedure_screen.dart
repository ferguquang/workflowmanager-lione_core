import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/custom_tab_bar_widget.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/params/list_register_request.dart';
import 'package:workflow_manager/procedures/models/response/data_register_save_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/screens/register/choice_type_procedure/choice_type_procedure_screen.dart';
import 'package:workflow_manager/procedures/models/event/event_change_tab_listener.dart';
import 'package:workflow_manager/procedures/screens/register/list/event_reload_list_register.dart';
import 'package:workflow_manager/procedures/screens/register/list/list_register_repository.dart';

import 'list/list_register_screen.dart';

class RegisterProcedureScreen extends StatefulWidget {
  @override
  _RegisterProcedureScreenState createState() =>
      _RegisterProcedureScreenState();
}

class _RegisterProcedureScreenState extends State<RegisterProcedureScreen> with SingleTickerProviderStateMixin {
  List<Tab> myTabs = [];

  TabController _tabController;

  int _selectedIndex = 0;

  int recordTotalPending = 0;
  int recordTotalProcessing = 0;
  int recordTotalProcessed = 0;
  int recordTotalRejected = 0;
  int recordTotalResented = 0;
  int recordTotalCancel = 0;
  int recordTotalStar = 0;
  int recordTotal = 0;

  bool isFirst = true;

  @override
  void initState() {
    super.initState();

    createTab();

    _tabController = new TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(() {
      _selectedIndex = _tabController.index;

      eventBus.fire(EventChangeTabListener(_selectedIndex));
    });

    eventBus.on<DataListRegister>().listen((event) {
      setState(() {
        recordTotalPending = event.recordTotalPending;
        recordTotalProcessing = event.recordTotalProcessing;
        recordTotalProcessed = event.recordTotalProcessed;
        recordTotalRejected = event.recordTotalRejected;
        recordTotalResented = event.recordTotalResented;
        recordTotalCancel = event.recordTotalCancel;
        recordTotalStar = event.recordTotalStar;
        recordTotal = event.recordTotal;

        myTabs.clear();
        createTab();
      });
    });
  }

  void createTab() {
    myTabs = <Tab>[
      Tab(child: CustomTabBarWidget("Ch??a x??? l??", recordTotalPending)),
      Tab(child: CustomTabBarWidget("??ang x??? l??", recordTotalProcessing)),
      Tab(child: CustomTabBarWidget("???? ho??n th??nh", recordTotalProcessed)),
      Tab(child: CustomTabBarWidget("T??? ch???i", recordTotalRejected)),
      Tab(child: CustomTabBarWidget("H???y", recordTotalCancel)),
      Tab(child: CustomTabBarWidget("C???n b??? sung", recordTotalResented)),
      Tab(child: CustomTabBarWidget("C?? g???n sao", recordTotalStar)),
      Tab(child: CustomTabBarWidget("T???t c??? h??? s??", recordTotal)),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainScreen(),
      floatingActionButton: FloatingButtonWidget(
        onSelectedButton: () async {
          var response = await pushPage(context, ChoiceTypeProcedureScreen());
          if (response != null) {
            eventBus.fire(EventReloadListRegister());
          }
        },
      ),
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
                  TabBar(
                    controller: _tabController,
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
          controller: _tabController,
          children: [
            ListRegisterScreen(ListRegisterScreen.TYPE_PENDING),
            // ch??a x??? l??
            ListRegisterScreen(ListRegisterScreen.TYPE_PROCESSING),
            // ??ang x??? l??
            ListRegisterScreen(ListRegisterScreen.TYPE_PROCESSED),
            // ???? x??? l??
            ListRegisterScreen(ListRegisterScreen.TYPE_REJECTED),
            // t??? ch???i
            ListRegisterScreen(ListRegisterScreen.TYPE_CANCEL),
            // h???y
            ListRegisterScreen(ListRegisterScreen.TYPE_COMPLEMENTARY),
            // c???n b??? sung
            ListRegisterScreen(ListRegisterScreen.TYPE_STAR),
            // c?? g???n sao
            ListRegisterScreen(ListRegisterScreen.TYPE_TOTAL),
            // t???ng
          ],
        ),
      ),
    );
  }

  void handleTabSelected() {
    if (_tabController.indexIsChanging) {
      print("object");
      switch (_tabController.index) {
        case 0:
          break;
        case 1:
          break;
      }
    }
  }
}
