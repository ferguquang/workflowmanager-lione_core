import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/screen/business_management_repository.dart';
import 'package:workflow_manager/businessManagement/screen/management/management_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/filter_statistic/filter_statistic_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/statistics_screen.dart';

import '../../main.dart';
import 'management/filter/management_filter_screen.dart';

class BusinessManagementScreen extends StatefulWidget {
  @override
  BusinessManagementScreenState createState() =>
      BusinessManagementScreenState();
}

class BusinessManagementScreenState extends State<BusinessManagementScreen> {
  BusinessManagementRepository _repository = BusinessManagementRepository();
  int _selectedIndex = 0;

  // FilterStatisticScreen filterStatistic;
  StreamSubscription _dataSearchStatisticParams;

  // dữ liệu dành cho lọc của thống kê
  GetListDataFilterStatisticEventBus dataFilterStatistic =
      GetListDataFilterStatisticEventBus();

  // dữ liệu dành cho lọc của quản lý
  ManagementFilterScreen filterManager;
  StreamSubscription _dataSearchManageParams;
  GetListDataFilterManagerEventBus dataFilterManager =
      GetListDataFilterManagerEventBus();

  bool isShowSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _repository.getIModule();

      _listenerEventBus();
    });
  }

  void _listenerEventBus() {
    if (isNotNullOrEmpty(_dataSearchStatisticParams))
      _dataSearchStatisticParams.cancel();
    _dataSearchStatisticParams =
        eventBus.on<GetListDataFilterStatisticEventBus>().listen((event) {
      dataFilterStatistic = event;
      event.numberTabFilter != null
          ? isShowSearch = true
          : isShowSearch = false;
      _repository.notifyListeners();
    });

    if (isNotNullOrEmpty(_dataSearchManageParams))
      _dataSearchManageParams.cancel();
    _dataSearchManageParams =
        eventBus.on<GetListDataFilterManagerEventBus>().listen((event) {
      setState(() {
        dataFilterManager = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (isNotNullOrEmpty(_dataSearchStatisticParams))
      _dataSearchStatisticParams.cancel();
    if (isNotNullOrEmpty(_dataSearchManageParams))
      _dataSearchManageParams.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: this._repository,
      child: Consumer(
        builder: (context, BusinessManagementRepository _repository1, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Quản lý kinh doanh".toUpperCase(),
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                Visibility(
                  visible: isShowSearch,
                  child: FlatButton(
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_selectedIndex == 0) {
                        // thống kê
                        pushPage(context,
                            FilterStatisticScreen(dataFilterStatistic));
                      } else {
                        // quản lý
                        if (filterManager == null)
                          filterManager = ManagementFilterScreen(
                              searchParam: dataFilterManager?.searchParam,
                              plansRequest: dataFilterManager?.plansRequest);

                        pushPage(context, filterManager);
                      }
                    },
                  ),
                ),
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                StatisticsScreen(),
                ManagementScreen(
                  iModule: _repository.iModule,
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                _buildBottomNavigationBarItem("assets/images/ic-duocgiao.png",
                    "assets/images/ic-duocgiao-active.png", 'Thống kê'),
                _buildBottomNavigationBarItem("assets/images/ic-dagiao.png",
                    "assets/images/ic-dagiao-active.png", 'Quản lý'),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
            ),
          );
        },
      ),
    );
  }

  _onItemTapped(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
    });
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
}
