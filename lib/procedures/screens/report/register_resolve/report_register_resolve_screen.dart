import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/tag_label_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/manager/widgets/number_statistics_widget.dart';
import 'package:workflow_manager/manager/widgets/number_statistics_widget_dot_icon.dart';
import 'package:workflow_manager/procedures/models/event/register_resolve_event.dart';
import 'package:workflow_manager/procedures/models/params/register_resolve_request.dart';
import 'package:workflow_manager/procedures/models/response/report_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/screens/filter/filter_procedure_screen.dart';

import '../../../../main.dart';
import 'register_resolve_repository.dart';
import 'register_resolve_widget.dart';

class ReportRegisterResolveScreen extends StatefulWidget {
  @override
  _ReportRegisterResolveState createState() => _ReportRegisterResolveState();
}

class _ReportRegisterResolveState extends State<ReportRegisterResolveScreen> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  PageController controller = PageController();

  RegisterResolveRepository _repository = RegisterResolveRepository();

  int _curr = 0;

  double widthItemStatus = 70.0;

  Widget _filterScreen() {
    List<FilterProcedureType> arrayTypeItem = [];
    arrayTypeItem.add(FilterProcedureType.START_DATE);
    arrayTypeItem.add(FilterProcedureType.END_DATE);
    arrayTypeItem.add(FilterProcedureType.YEAR);
    return FilterProcedureScreen(
      searchProcedureModel: _repository.searchProcedureModel,
      originalRequest: _repository.registerResolveRequest,
      arrayTypeItem: arrayTypeItem,
      onDoneFilter: (result) {
        this._repository.registerResolveRequest =
            RegisterResolveRequest.from(result);
        _getData();
      },
    );
  }

  _getData() async {
    if (isNullOrEmpty(_repository.registerResolveRequest.startDate)) {
      _repository.registerResolveRequest.startDate =
          this._repository.getStartDate();
    }
    if (isNullOrEmpty(_repository.registerResolveRequest.endDate)) {
      _repository.registerResolveRequest.endDate =
          this._repository.getEndDate();
    }
    if(isNullOrEmpty(_repository.registerResolveRequest.filterYear.name)) {
      var year = FilterYear();
      year.name = getCurrentYear().toString();
      _repository.registerResolveRequest.filterYear = year;
    }
    bool status = await _repository.getReportProcedure();
    if(status) {
      RegisterResolveEvent event = RegisterResolveEvent();
      event.listRecordReport = _repository.reportProcedureData.recordReport;
      eventBus.fire(event);
    }
  }

  Widget _displayStatusProgress() {
    return Container(
      padding: EdgeInsets.only(right: 8),
      alignment: Alignment.centerRight,
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
              padding: EdgeInsets.all(4),
              child: TagLabelWidget(
                text: "Đã đăng ký",
                textColor: Colors.black,
                bgColor: Colors.white,
                borderColor: Colors.grey,
                fontSize: 12,
              )),
          Padding(
              padding: EdgeInsets.all(4),
              child: TagLabelWidget(
                text: "Chưa xử lý",
                textColor: Colors.white,
                bgColor: "ead189".toColor(),
                borderColor: Colors.white,
                fontSize: 12,
              )),
          Padding(
              padding: EdgeInsets.all(4),
              child: TagLabelWidget(
                text: "Đang xử lý",
                textColor: Colors.white,
                bgColor: "53a93f".toColor(),
                borderColor: Colors.white,
                fontSize: 12,
              )),
          Padding(
              padding: EdgeInsets.all(4),
              child: TagLabelWidget(
                text: 'Đã hoàn thành',
                textColor: Colors.white,
                bgColor: "57b5e3".toColor(),
                borderColor: Colors.white,
                fontSize: 12,
              )),
          Padding(
              padding: EdgeInsets.all(4),
              child: TagLabelWidget(
                text: 'Huỷ',
                textColor: Colors.white,
                bgColor: "FF0000".toColor(),
                borderColor: Colors.white,
                fontSize: 12,
              )),
        ],
      ),
    );
  }

  Widget _titleStatusIcon() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      alignment: Alignment.centerRight,
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: SizedBox(width: 150, child: Text("Tên thủ tục"))),
          Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.grey)),
          ),
          Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
                color: "ead189".toColor(),
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.grey)),
          ),
          Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
                color: "53a93f".toColor(),
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.grey)),
          ),
          Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
                color: "57b5e3".toColor(),
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.grey)),
          ),
          Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
                color: "FF0000".toColor(),
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemStatus(ServiceReport serviceReport) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: SizedBox(
                  width: 150,
                  child: Text(
                    serviceReport.name,
                    maxLines: 3,
                  ))),
          Container(
            width: 50,
            child: Text(
              serviceReport.totalRecord.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 50,
            child: Text(
              serviceReport.totalPending.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 50,
            child: Text(
              serviceReport.totalProcessing.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 50,
            child: Text(
              serviceReport.totalProcessed.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 50,
            child: Text(
              serviceReport.totalCanceled.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _repository.getDefaultParams();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _repository,
        child: Consumer(
          builder: (context, RegisterResolveRepository _repository, _) {
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
                    alignment: Alignment.center,
                    child: SizedBox(
                        height: 380,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: isNotNullOrEmpty(
                                        _repository.reportProcedureData)
                                    ? RegisterResolveWidget(
                                        _repository.reportProcedureData)
                                    : EmptyScreen()),
                            Container(
                                width: (widthItemStatus * 5.0),
                                alignment: Alignment.center,
                                height: 60,
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 8),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: isNotNullOrEmpty(
                                            _repository.reportProcedureData)
                                        ? _repository.reportProcedureData
                                            .recordReport.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        child: Row(
                                          children: [
                                            NumberStatisticsWidgetDotIcon(
                                                _repository.reportProcedureData
                                                    .recordReport[index].color, // Nhớ thay icon ở đây
                                                _repository.reportProcedureData
                                                    .recordReport[index].name,
                                                _repository.reportProcedureData
                                                    .recordReport[index].number
                                                    .toString()),
                                            Visibility(
                                                visible: index !=
                                                    _repository
                                                            .reportProcedureData
                                                            .recordReport
                                                            .length -
                                                        1,
                                                child: VerticalDivider()),
                                          ],
                                        ),
                                      );
                                    })),
                          ],
                        )),
                  ),
                  Divider(
                    color: "E9ECEF".toColor(),
                    thickness: 8,
                  ),
                  _displayStatusProgress(),
                  _titleStatusIcon(),
                  SizedBox(
                    // height: isNotNullOrEmpty(_repository.reportProcedureData)
                    //     ? _repository.reportProcedureData.serviceReport.length *
                    //         64.0
                    //     : 0.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount:
                            isNotNullOrEmpty(_repository.reportProcedureData)
                                ? _repository
                                    .reportProcedureData.serviceReport.length
                                : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return isNotNullOrEmpty(
                                  _repository.reportProcedureData)
                              ? _buildItemStatus(_repository
                                  .reportProcedureData.serviceReport[index])
                              : null;
                        }),
                  ),
                ],
              ),
            ));
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
