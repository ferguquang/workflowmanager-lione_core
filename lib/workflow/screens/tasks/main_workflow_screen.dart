import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/manager/auth/auth_repository.dart';
import 'package:workflow_manager/workflow/models/event/view_mode_event.dart';
import 'package:workflow_manager/workflow/screens/create_job/create_job_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/addition/addition_screen.dart';
import 'package:workflow_manager/workflow/screens/tasks/list_tasks_tab.dart';

import '../../../main.dart';

// Màn hình ngoài cùng
class MainWorkflowScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListTasksScreen();
  }
}

class _ListTasksScreen extends State<MainWorkflowScreen>
    with SingleTickerProviderStateMixin {
  AuthRepository authRepository;
  String sAppbar = 'Công việc được giao';

  int _selectedIndex = 0;
  bool isCheckMenuJob = true;

  void _onItemTapped(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          AppStore.currentViewTypeWorkflow = 1;
          sAppbar = 'Công việc được giao';
          isCheckMenuJob = true;
          eventBus.fire(ViewModeEvent());
          break;
        case 1:
          AppStore.currentViewTypeWorkflow = 2;
          sAppbar = 'Công việc đã giao';
          isCheckMenuJob = true;
          eventBus.fire(ViewModeEvent());
          break;
        case 2:
          AppStore.currentViewTypeWorkflow = 3;
          sAppbar = 'Công việc phối hợp';
          isCheckMenuJob = true;
          eventBus.fire(ViewModeEvent());
          break;
        case 3:
          sAppbar = "Tạo công việc";
          isCheckMenuJob = false;
          break;
        case 4:
          sAppbar = "";
          isCheckMenuJob = false;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authRepository = Provider.of<AuthRepository>(context,listen: false);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sAppbar),
        actions: [
          Visibility(
            visible: isCheckMenuJob,
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: PopupMenuButton(
                child: Icon(Icons.more_vert),
                onSelected: (value) {
                  setState(() {
                    AppStore.isViewDeadLine = value;
                  });
                  eventBus.fire(ViewModeEvent());
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 0,
                      child: _buildMenu(0, "Trạng thái công việc"),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: _buildMenu(1, "Theo dõi ngày kết thúc"),
                    ),
                  ];
                },
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()),
                  ModalRoute.withName('/first'),
                );
                AuthRepository.logout();
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          ListTasksTabScreen(viewType: 1),
          ListTasksTabScreen(viewType: 2),
          ListTasksTabScreen(viewType: 3),
          CreateJobScreen(true, 0, 0, 0, 0), //default
          AdditionScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem("assets/images/ic-duocgiao.png",
              "assets/images/ic-duocgiao-active.png", 'Được giao'),
          _buildBottomNavigationBarItem("assets/images/ic-dagiao.png",
              "assets/images/ic-dagiao-active.png", 'Đã giao'),
          _buildBottomNavigationBarItem("assets/images/ic-phoihop.png",
              "assets/images/ic-phoihop-active.png", 'Phối hợp'),
          _buildBottomNavigationBarItem("assets/images/ic-taomoi.png",
              "assets/images/ic-taomoi-active.png", 'Tạo mới'),
          _buildBottomNavigationBarItem("assets/images/ic-them.png",
              "assets/images/ic-them-active.png", 'Thêm'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(img, imgActive, label) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        img,
        width: 24,
        height: 24,
      ),
      activeIcon: Image.asset(
        imgActive,
        width: 24,
        height: 24,
      ),
      label: label,
    );
  }

  Widget _buildMenu(int value, String text) {
    return Row(children: [
      Opacity(
        opacity: AppStore.isViewDeadLine == value ? 1.0 : 0.0,
        child: Icon(
          Icons.check,
          color: Colors.grey,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 8),
      ),
      Text(text)
    ]);
  }
}
