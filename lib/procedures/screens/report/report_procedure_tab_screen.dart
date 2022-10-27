import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/procedures/screens/main/procedure_main_repository.dart';
import 'package:workflow_manager/procedures/screens/report/report_procedures/report_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/report/register_resolve/report_register_resolve_screen.dart';
import 'package:workflow_manager/procedures/screens/report/report_status/report_status_screen.dart';

class ReportProcedureTabScreen extends StatefulWidget {
  @override
  _ReportProcedureTabScreenState createState() => _ReportProcedureTabScreenState();
}

class _ReportProcedureTabScreenState extends State<ReportProcedureTabScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Quy trình thủ tục'),
    Tab(text: 'Đăng ký giải quyết'),
    Tab(text: 'Trạng thái'),
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
    return ChangeNotifierProvider(
      create: (context) => ProceduresMainRepository(),
      child: Consumer(
        builder: (context, ProceduresMainRepository repository, _) {
          return Scaffold(
            body: DefaultTabController(
              length: myTabs.length,
              child: (myTabs == null || myTabs?.length == 0)
                  ? EmptyScreen()
                  : Scaffold(
                      appBar: new PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: new Container(
                          color: Colors.white,
                          child: new SafeArea(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: new Container(),
                                ),
                                TabBar(
                                  isScrollable: true,
                                  labelColor: Colors.blue,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: myTabs,

                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        // controller: _tabController,
                        children: <Widget>[
                          ReportProcedureScreen(),
                          ReportRegisterResolveScreen(),
                          ReportStatusScreen(),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
