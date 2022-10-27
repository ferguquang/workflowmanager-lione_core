import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/procedures/models/event/report_procedure_event.dart';
import 'package:workflow_manager/procedures/models/params/report_procedure_request.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/screens/filter/filter_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/report/report_procedures/report_procedure_repository.dart';
import 'package:workflow_manager/shopping_management/model/event/choice_report_shopping_event.dart';
import 'package:workflow_manager/shopping_management/model/event/report_shopping_event.dart';
import 'package:workflow_manager/shopping_management/report/filter_shopping_screen.dart';
import 'package:workflow_manager/shopping_management/response/report_shopping_list_response.dart';
import 'package:workflow_manager/shopping_management/response/shopping_dashboard_response.dart';

import 'compare_shopping_widget.dart';
import 'internal_shopping_widget.dart';
import 'project_shopping_widget.dart';
import 'repository/report_shopping_repository.dart';

class ReportShoppingScreen extends StatefulWidget {
  @override
  _ReportShoppingScreenState createState() => _ReportShoppingScreenState();
}

class _ReportShoppingScreenState extends State<ReportShoppingScreen>
    with AutomaticKeepAliveClientMixin {
  PageController controller = PageController();

  ReportShoppingRepository _repository = ReportShoppingRepository();

  List<Widget> _listHeader = [
    new CompareShoppingWidget(),
    new InternalShoppingWidget(),
    new ProjectShoppingWidget(),
  ];

  int _curr = 0;

  StreamSubscription choiceShoppingEvent;

  String titleListData = "Tất cả";

  Widget _filterScreen() {
    return FilterShoppingScreen(_repository.reportShoppingDashBoardData,
        _repository.reportShoppingRequest, onDoneFilter: (result) {
      this._repository.reportShoppingRequest = result;
      _onRefresh();
    });
  }

  void _onRefresh() async {
    _getData();
  }

  _getData() async {
    // get data for dashboard
    bool status = await _repository.getReportShoppingDashBoard();
    if (status) {
      ReportShoppingEvent event = ReportShoppingEvent();
      event.data = _repository.reportShoppingDashBoardData;
      eventBus.fire(event);
    }

    // get data for list
    _repository.getReportShoppingList(
        iDCategory: _repository.reportShoppingRequest.iDCategory);
  }

  SmoothPageIndicator _indicator() {
    return SmoothPageIndicator(
        controller: controller, // PageController
        count: _listHeader.length,
        effect: WormEffect(
            dotHeight: 6.0,
            dotWidth: 6.0,
            spacing: 8.0,
            dotColor: Colors.grey[500],
            activeDotColor: Colors.blue), // your preferr
        onDotClicked: (index) {});
  }

  _buildItem(ReportTable reportTable) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                reportTable.projectCode ?? "",
                style: TextStyle(color: Colors.blue),
              )),
            ],
          ),
          Container(
            child: Text("Tổng tiền: ${reportTable.actualAmount}"),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("Danh mục: ${reportTable.categoryName}"),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text("Chủ đầu tư: ${reportTable.investor}" ?? ""),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    choiceShoppingEvent =
        eventBus.on<ChoiceReportShoppingEvent>().listen((event) {
      int categoryId = event.categoryId;
      // get data for list
      _repository.setViewListData(true);
      _repository.getReportShoppingList(
          iDCategory: categoryId, currentPage: _curr);
      setState(() {
        titleListData = event.categoryName;
      });
    });

    DateTime now = new DateTime.now();
    _repository.reportShoppingRequest.year.iD = now.year;
    _repository.reportShoppingRequest.year.name = "${now.year}";
    _repository.reportShoppingRequest.quarter = getQuarter(now);
    _getData();
  }

  Quarters getQuarter(DateTime now) {
    Quarters quarters = Quarters();
    if (now.month == 1 || now.month == 2 || now.month == 3) {
      quarters.iD = 1;
      quarters.name = "Quý 1";
      return quarters;
    } else if (now.month == 4 || now.month == 5 || now.month == 6) {
      quarters.iD = 2;
      quarters.name = "Quý 2";
      return quarters;
    } else if (now.month == 7 || now.month == 8 || now.month == 9) {
      quarters.iD = 3;
      quarters.name = "Quý 3";
      return quarters;
    } else if (now.month == 10 || now.month == 11 || now.month == 12) {
      quarters.iD = 4;
      quarters.name = "Quý 4";
      return quarters;
    }
  }

  @override
  void dispose() {
    choiceShoppingEvent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _repository,
        child: Consumer(
          builder: (context, ReportShoppingRepository _repository, _) {
            return SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          children: [
                            Expanded(child: Text("")),
                            IconButton(
                              icon: Icon(Icons.filter_list_outlined),
                              color: Colors.grey,
                              onPressed: () {
                                pushPage(context, _filterScreen());
                              },
                            ),
                          ],
                        )),
                    decoration: BoxDecoration(color: Colors.grey[200]),
                  ),
                  Container(
                    color: Colors.white,
                    child: SizedBox(
                      height: 360,
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView(
                              children: _listHeader,
                              scrollDirection: Axis.horizontal,
                              controller: controller,
                              onPageChanged: (num) {
                                setState(() {
                                  _curr = num;
                                  _repository.clearData();
                                  setState(() {
                                    titleListData = "";
                                  });
                                });
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.only(bottom: 8),
                            child: _indicator(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: "E9ECEF".toColor(),
                    thickness: 8,
                  ),
                  Visibility(
                    visible: _repository.isViewListData,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[Text(titleListData), Spacer()],
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            itemCount: isNotNullOrEmpty(
                                    _repository.reportShoppingListData)
                                ? _repository
                                    .reportShoppingListData.reportTable.length
                                : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return isNotNullOrEmpty(
                                      _repository.reportShoppingListData)
                                  ? _buildItem(_repository
                                      .reportShoppingListData
                                      .reportTable[index])
                                  : null;
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
