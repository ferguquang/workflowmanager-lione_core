import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/manager/widgets/project_progress_widget.dart';
import 'package:workflow_manager/manager/widgets/staff_statistics_widget.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/procedures/models/event/report_procedure_event.dart';
import 'package:workflow_manager/procedures/models/params/report_procedure_request.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/screens/filter/filter_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/report/report_procedures/state_resolve_widget.dart';

import 'report_procedure_repository.dart';
import 'statistics_procedures_widget.dart';

class ReportProcedureScreen extends StatefulWidget {
  @override
  _ReportProcedureScreenState createState() => _ReportProcedureScreenState();
}

class _ReportProcedureScreenState extends State<ReportProcedureScreen>
    with AutomaticKeepAliveClientMixin {
  PageController controller = PageController();

  ReportProcedureRepository _repository = ReportProcedureRepository();

  List<Widget> _listHeader = [
    new StatisticsProceduresWidget(),
    new StateResolveWidget(),
  ];

  int _curr = 0;

  Widget _filterScreen() {
    List<FilterProcedureType> arrayTypeItem = [];
    arrayTypeItem.add(FilterProcedureType.START_DATE);
    arrayTypeItem.add(FilterProcedureType.END_DATE);
    arrayTypeItem.add(FilterProcedureType.YEAR);
    return FilterProcedureScreen(
      searchProcedureModel: _repository.searchProcedureModel,
      originalRequest: _repository.reportProcedureRequest,
      arrayTypeItem: arrayTypeItem,
      onDoneFilter: (result) {
        this._repository.reportProcedureRequest =
            ReportProcedureRequest.from(result);
        _onRefresh();
      },
    );
  }

  void _onRefresh() async {
    _getData();
  }

  _getData() async {
    if (isNullOrEmpty(_repository.reportProcedureRequest.startDate)) {
      _repository.reportProcedureRequest.startDate =
          this._repository.getStartDate();
    }
    if (isNullOrEmpty(_repository.reportProcedureRequest.endDate)) {
      _repository.reportProcedureRequest.endDate =
          this._repository.getEndDate();
    }
    if(isNullOrEmpty(_repository.reportProcedureRequest.filterYear.name)) {
      var year = FilterYear();
      year.name = getCurrentYear().toString();
      _repository.reportProcedureRequest.filterYear = year;
    }
    bool status = await _repository.getReportProcedure();
    if (status) {
      ReportProcedureEvent event = ReportProcedureEvent(_repository.reportProcedureData.wfReport,_repository.reportProcedureData.typeWfTotal,_repository.reportProcedureData.workflowTotal);
      event.listWfReport = _repository.reportProcedureData.wfReport;
      eventBus.fire(event);
    }
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

  @override
  void initState() {
    super.initState();
    _repository.getDefaultParams();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _repository,
        child: Consumer(
          builder: (context, ReportProcedureRepository _repository, _) {
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
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text("Tên"),
                            ),
                            Text("Số lượng"),
                          ],
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(top: 8),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Tổng số loại quy trình thủ tục"),
                              ),
                              Text(
                                _repository.reportProcedureData?.typeWfTotal
                                        ?.toString() ??
                                    "0",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: "E9ECEF".toColor()),
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Tổng số quy trình thủ tục"),
                              ),
                              Text(
                                _repository.reportProcedureData?.workflowTotal
                                        ?.toString() ??
                                    "0",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: "E9ECEF".toColor()),
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Tổng số hồ sơ đăng ký"),
                              ),
                              Text(
                                _repository.reportProcedureData?.recordTotal
                                        ?.toString() ??
                                    "0",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: "E9ECEF".toColor()),
                      ],
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
