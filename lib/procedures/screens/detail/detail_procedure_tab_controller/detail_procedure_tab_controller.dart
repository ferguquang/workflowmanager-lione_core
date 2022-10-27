import 'package:flutter/material.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/file_detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/history/tab_history_detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/info/info_detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/version_brief/tab_version_brief_procedure_screen.dart';

class DetailProcedureTabController extends StatefulWidget {
  DataProcedureDetail dataProcedureDetail;
  int type, state;

  DetailProcedureTabController(this.dataProcedureDetail, this.type, this.state);

  @override
  _DetailProcedureTabControllerState createState() =>
      _DetailProcedureTabControllerState();
}

class _DetailProcedureTabControllerState
    extends State<DetailProcedureTabController>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Thông tin hồ sơ'),
    Tab(text: 'File tài liệu'),
    Tab(text: 'Lịch sử'),
    Tab(text: 'Phiên bản hồ sơ'),
  ];

  @override
  Widget build(BuildContext context) {
    return _mainScreen();
  }

  Widget _mainScreen() {
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
                    // Expanded(child: Container()),
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
              InfoDetailProcedureScreen(
                  widget.dataProcedureDetail, widget.type, widget.state == 4),
              FileDetailProcedureScreen(
                  widget.dataProcedureDetail, widget.type, widget.state),
              TabHistoryDetailProcedureScreen(
                data: widget.dataProcedureDetail,
              ),
              TabVersionBriefProcedureScreen(
                dataProcedureDetail: widget.dataProcedureDetail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
