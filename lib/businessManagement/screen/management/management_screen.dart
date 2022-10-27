import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/custom_listview_loading_refresh_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/response/imodule_response.dart';
import 'package:workflow_manager/businessManagement/model/response/project_plan_index_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/cell/project_plan_cell.dart';
import 'package:workflow_manager/main.dart';

import 'create/create_management_screen.dart';
import 'detail/detail_management_screen.dart';
import 'management_repository.dart';

class ManagementScreen extends StatefulWidget {
  DataIModule iModule;

  ManagementScreen({this.iModule});

  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  bool isSort;
  ManagementRepository _repository = ManagementRepository();
  StreamSubscription _dataCreateOpportunity;
  StreamSubscription _dataIsOnlyView;
  StreamSubscription _dataRequestFilterManager;
  DataProjectPlanIndex dataPlan;
  List<ProjectPlanItem> projectPlans;
  bool isOnlyView;

  @override
  void initState() {
    // TODO: implement initState
    isOnlyView = widget.iModule?.isKhach;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getListDataProjectPlan();

      _listenerEventBus();
    });
  }

  void _listenerEventBus() {
    // từ business_management_repository.dart qua
    if (isNotNullOrEmpty(_dataIsOnlyView)) _dataIsOnlyView.cancel();
    _dataIsOnlyView = eventBus.on<GetDataIsOnlyViewEventBus>().listen((event) {
      isOnlyView = event.isOnlyView;
      _getListDataProjectPlan();
    });
    // các aciton bottomshet và create truyền qua
    if (isNotNullOrEmpty(_dataCreateOpportunity))
      _dataCreateOpportunity.cancel();
    _dataCreateOpportunity = eventBus.on<GetDataSaveEventBus>().listen((event) {
      setState(() {
        _getListDataProjectPlan();
      });
    });

    // filter quản lý truyền qua
    if (isNotNullOrEmpty(_dataRequestFilterManager))
      _dataRequestFilterManager.cancel();
    _dataRequestFilterManager =
        eventBus.on<GetRequestFilterToManagerEventBus>().listen((event) {
      setState(() {
        _repository.listPlanRequest = event.plansRequest;
        _onRefresh();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (isNotNullOrEmpty(_dataCreateOpportunity))
      _dataCreateOpportunity.cancel();
    if (isNotNullOrEmpty(_dataIsOnlyView)) _dataIsOnlyView.cancel();
    if (isNotNullOrEmpty(_dataRequestFilterManager))
      _dataRequestFilterManager.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this._repository,
      child: Consumer(
        builder: (context, ManagementRepository _repository, child) {
          return Scaffold(
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  this._buildTopWidget(),
                  Expanded(
                    child: this._buildListPlan(this.projectPlans),
                  ),
                ],
              ),
            ),
            floatingActionButton: Visibility(
              visible: dataPlan?.isCreate ?? false,
              child: FloatingButtonWidget(
                onSelectedButton: () => pushPage(
                    context,
                    CreateManagementScreen(
                      typeOpportunity: CreateManagementScreen.TYPE_CREATE,
                      // idOpportunity: 1195,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  // header cơ hội, khách hàng, tổng giá trị, tên
  Widget _buildTopWidget() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.only(top: 8, left: 16, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${dataPlan == null ? 0 : dataPlan.totalPlan} cơ hội, ${dataPlan == null ? 0 : dataPlan.totalCustomer} khách hàng.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                ),
                Text(
                  "Tổng giá trị: ${dataPlan == null ? "" : dataPlan.totalMoney}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 0),
              child: Container(
                  color: Colors.grey[200],
                  child: RaisedButton(
                      color: Colors.grey[200],
                      elevation: 0,
                      onPressed: () {
                        setState(() {
                          // _repository.sortByName(this.isSort);
                          if (this.isSort == null || this.isSort == true) {
                            this.isSort = false;
                          } else {
                            this.isSort = true;
                          }
                          // widget.sortList(this.isSort);
                        });
                      },
                      textColor: Colors.grey[600],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // color: Colors.white,
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              'Tên',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Icon(
                            isSort == false || isSort == null
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.grey[600],
                            size: 15,
                          ),
                        ],
                      )))),
        ],
      ),
    );
  }

  Widget _buildListPlan(data) {
    // sắp theo theo tên local
    List<ProjectPlanItem> _plans = [];
    if (data != null && data?.length > 0) {
      _plans = data;
      if (isSort != null) {
        if (isSort) {
          _plans.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        } else {
          _plans.sort(
              (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        }
      }
    }

    return CustomListViewWidget(
      lengthList: _plans.length,
      onLoading: this._onLoading,
      onRefresh: this._onRefresh,
      listViewWidget: _plans.length == 0
          ? EmptyScreen()
          : ListView.separated(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                ProjectPlanItem _item = _plans[index];
                return InkWell(
                  onTap: () {
                    pushPage(
                        context,
                        DetailManagementScreen(
                          idOpportunity: _item?.iD ?? 0,
                          isOnlyView: isOnlyView,
                        ));
                  },
                  child: ProjectPlanCell(
                    item: _item,
                    isOnlyView: isOnlyView,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
    );
  }

  _getListDataProjectPlan() async {
    if (isOnlyView == null) return;
    await _repository.getProjectPlanIndex(isOnlyView);
    dataPlan = _repository.dataPlan;
    projectPlans = _repository.listProjectPlans;
  }

  void _onLoading() async {
    _repository.listPlanRequest.pageIndex =
        _repository.listPlanRequest.pageIndex + 1;
    _getListDataProjectPlan();
  }

  void _onRefresh() async {
    _repository.listPlanRequest.pageIndex = 1;
    _getListDataProjectPlan();
  }
}
