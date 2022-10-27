import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/procedures/models/params/list_report_state_request.dart';
import 'package:workflow_manager/procedures/models/response/list_report_state_response.dart';
import 'package:workflow_manager/procedures/screens/filter/filter_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/report/report_status/record_report_item.dart';

import 'report_status_repository.dart';

class ReportStatusScreen extends StatefulWidget {
  @override
  _ReportStatusScreenState createState() => _ReportStatusScreenState();
}

class _ReportStatusScreenState extends State<ReportStatusScreen> {

  ReportStatusRepository _repository = ReportStatusRepository();

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  Widget _filterScreen() {
    List<FilterProcedureType> arrayTypeItem = [];
    arrayTypeItem.add(FilterProcedureType.START_DATE);
    arrayTypeItem.add(FilterProcedureType.END_DATE);
    arrayTypeItem.add(FilterProcedureType.STATE);
    arrayTypeItem.add(FilterProcedureType.TYPE);
    arrayTypeItem.add(FilterProcedureType.SERVICE);
    arrayTypeItem.add(FilterProcedureType.USER_REGISTER);
    arrayTypeItem.add(FilterProcedureType.DEPT);
    return FilterProcedureScreen(
      searchProcedureModel: _repository.searchProcedureModel,
      originalRequest: _repository.reportStatusRequest,
      arrayTypeItem: arrayTypeItem,
      rootType: FilterRootType.REPORT,
      onDoneFilter: (result) {
        _repository.pullToRefreshData();
        this._repository.reportStatusRequest = ListReportStatusRequest.from(result);
        _getListData();
      },
    );
  }

  _getListData() async {
    if(isNullOrEmpty(_repository.reportStatusRequest.filterState.state)) {
      _repository.reportStatusRequest.filterState.state = -1;
    }
    if(isNullOrEmpty(_repository.reportStatusRequest.startDate)) {
      _repository.reportStatusRequest.startDate = this._repository.getStartDate();
    }
    if(isNullOrEmpty(_repository.reportStatusRequest.endDate)) {
      _repository.reportStatusRequest.endDate = this._repository.getEndDate();
    }
    await _repository.getListStatusReport();
  }

  _exportResolveStatusExcel() async {
    bool status = await _repository.exportResolveStatusExcel();
    if(status) {
      FileUtils.instance.downloadFileAndOpen(_repository.exportResolveData.fileName, _repository.exportResolveData.path, context);
    }
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
    _repository.pullToRefreshData();
    _getListData();
  }

  void _onLoadMore() async {
    _refreshController.loadComplete();
    _getListData();
  }

  @override
  void initState() {
    super.initState();
    _repository.pullToRefreshData();
    _repository.getDefaultParams();
    _getListData();
  }

  Widget _listReportStatus(List<RecordReport> list) {
    return isNullOrEmpty(list)
        ? EmptyScreen()
        : ListView.separated(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: RecordReportItem(
            recordReport: list[index],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, ReportStatusRepository repository, _) {
          return _screen(repository);
        },
      ),
    );
  }

  _screen(ReportStatusRepository repository) {
    return Container(
      child: Column (
        children: [
          Container(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Expanded(child: Text("${repository.rowCount} trạng thái giải quyết")),
                    IconButton(
                      icon: Icon(Icons.download_sharp),
                      color: Colors.grey,
                      onPressed: () {
                        _exportResolveStatusExcel();
                      },
                    ),
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
          Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(
                  complete: Container(),
                ),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                    } else if (mode == LoadStatus.loading) {
                      body = CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                    } else if (mode == LoadStatus.canLoading) {
                    } else {}
                    return Container(
                      height: 55.0,
                      child: Center(
                        child: body,
                      ),
                    );
                  },
                ),
                onRefresh: () {
                  _onRefresh();
                },
                onLoading: () {
                  _onLoadMore();
                },
                child: _listReportStatus(repository.listRecordReports),
              ))
        ],
      ),
    );
  }
}
