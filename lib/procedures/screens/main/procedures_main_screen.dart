import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/response/search_procedure_model.dart';
import 'package:workflow_manager/procedures/screens/register/register_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/report/report_procedure_tab_screen.dart';
import 'package:workflow_manager/procedures/screens/resolve/resolve_procedure_screen.dart';

class ProceduresMainScreen extends StatefulWidget {
  @override
  _ProceduresMainScreenState createState() => _ProceduresMainScreenState();
}

class _ProceduresMainScreenState extends State<ProceduresMainScreen> {

  var bottomNavItems =  [
    BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: "Thống kê"),
    BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Đăng ký"),
    BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined), label: "Giải quyết"),
  ];

  var screenItem = [
    ReportProcedureTabScreen(),
    RegisterProcedureScreen(),
    ResolveProcedureScreen(),
  ];

  int _selectedIndex = 0;

  SearchProcedureModel searchProcedureModel;

  String title = "Thống kê quy trình thủ tục";

  @override
  void initState() {
    super.initState();

    eventBus.on<SearchProcedureModel>().listen((event) {
      searchProcedureModel = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
        leading: BackIconButton(),
        actions: [
          Icon(Icons.access_time_rounded, color: Colors.blue,),
          Icon(Icons.access_time_rounded, color: Colors.blue,),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screenItem,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: List.of(bottomNavItems),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped
      ),
    );
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  void _onItemTapped(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          setState(() {
            title = "Thống kê quy trình thủ tục";
          });
          break;
        case 1:
          setState(() {
            title = "Danh sách đăng ký";
          });
          break;
        case 2:
          setState(() {
            title = "Danh sách giải quyết";
          });
          break;
      }
    });
  }
}
