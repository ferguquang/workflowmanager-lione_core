import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/params/detail_procedure_request.dart';
import 'package:workflow_manager/procedures/models/response/field_table_list.dart';
import 'package:workflow_manager/procedures/models/response/info_step_history_response.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/history/detail/history_detail_repository.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/group_table_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/table_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

class HistoryDetailProcedureScreen extends StatefulWidget {
  Histories histories;
  int idServiceRecord;

  HistoryDetailProcedureScreen({this.histories, this.idServiceRecord});

  @override
  _HistoryDetailProcedureScreenState createState() =>
      _HistoryDetailProcedureScreenState();
}

class _HistoryDetailProcedureScreenState
    extends State<HistoryDetailProcedureScreen> {
  HistoryDetailRepository _repository = HistoryDetailRepository();
  Histories histories;
  int idServiceRecord;
  SingleFieldWidget _singleFieldWidget;
  List<TableFieldWidget> _tableFieldWidget = [];
  bool _isFirstLoad = true;
  GlobalKey<SingleFieldWidgetState> _singleFieldKey = GlobalKey();
  GroupTableFieldWidget _groupTableFieldWidget;
  Color color = getColor("#858585");

  @override
  void initState() {
    super.initState();
    histories = widget.histories;
    idServiceRecord = widget.idServiceRecord;
    getInfoStepHistory();
  }

  void getInfoStepHistory() async {
    InfoStepHistoryRequest request = InfoStepHistoryRequest();
    request.idServiceRecord = idServiceRecord;
    request.idServiceRecordHistory = histories.iD;
    request.idServiceRecordWfStep = histories.iDServiceRecordWfStep;
    int status = await _repository.infoStepHistory(request);
    if (status == 0) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, HistoryDetailRepository repository,
            Widget child) {
          return _mainScreen(repository);
        },
      ),
    );
  }

  Widget _mainScreen(HistoryDetailRepository repository) {
    DataInfoStepHistory dataInfoStepHistory = repository.dataInfoStepHistory;

    HistoryInfo historyInfo;

    if (isNotNullOrEmpty(dataInfoStepHistory?.historyInfo)) {
      historyInfo = repository.dataInfoStepHistory.historyInfo[0];
      if (_isFirstLoad && historyInfo != null) {
        if (isNullOrEmpty(historyInfo.groupInfos)) {
          // _tableFieldWidget = TableFieldWidget(
          //   historyInfo?.tableFields ?? [],
          //   true,
          //   null,
          //   isShowHeader: true,
          //   isShowInRowInList: true,
          // );
          if (historyInfo?.fieldTableList?.tableFieldInfos != null)
            for (TableFieldInfo tableList
                in historyInfo?.fieldTableList?.tableFieldInfos) {
              _tableFieldWidget.add(TableFieldWidget(
                tableList?.fields ?? [],
                true,
                null,
                isAdd: false,
                isDelete: false,
                tableName: tableList.name,
                iDTable: tableList.iDTable,
                indexTitle: tableList.id,
              ));
            }
        } else {
          _groupTableFieldWidget = GroupTableFieldWidget(
            historyInfo?.tableFields,
            true,
            null,
            historyInfo.groupInfos,
            isShowInRowInList: true,
          );
        }
        _singleFieldWidget = SingleFieldWidget(
          historyInfo?.singleFields ?? [],
          isReadonly: true,
          key: _singleFieldKey,
          isViewInOneRow: true,
          isShowInRowInList: true,
        );
        if (isNotNullOrEmpty(historyInfo.groupInfos)) {
          _singleFieldWidget?.sendTableColListener = _tableFieldWidget;
          _groupTableFieldWidget.onFieldEditted =
              _singleFieldWidget.onFieldEditted;
        } else {
          _singleFieldWidget?.sendTableColListener = _tableFieldWidget;
          _tableFieldWidget.forEach(
              (e) => e.onFieldEditted = _singleFieldWidget.onFieldEditted);
        }
        _isFirstLoad = false;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết lịch sử"),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildRow("Bước", historyInfo?.stepName ?? ""),
                _buildRow("Đơn vị phụ trách", historyInfo?.executorName ?? ""),
                _buildRow(
                    "Thời gian xử lý",
                    historyInfo?.doneDate == 0
                        ? ""
                        : convertTimeStampToHumanDate(
                                historyInfo?.doneDate ?? 0, "dd-MM-yyyy HH:mm")
                            .replaceAll("-", "/")),
                _buildRow("Tiến độ xử lý", historyInfo?.progressTime ?? ""),
                _buildRow("Thông tin giải quyết", "", isHeader: true),
                _buildRow("Trạng thái xử lý", historyInfo?.statusProcess ?? ""),
                _buildRow(
                    "Ghi chú",
                    isNotNullOrEmpty(historyInfo?.solveMessage)
                        ? historyInfo?.solveMessage[0]
                        : ""),
                Visibility(
                    visible: isNotNullOrEmpty(historyInfo?.singleFields) ||
                        isNotNullOrEmpty(historyInfo?.tableFields),
                    child: WidgetListItem(
                      child: Text("Form thông tin"),
                      isShowInRowInList: true,
                    )),
                Visibility(
                  visible: isNotNullOrEmpty(historyInfo?.singleFields),
                  child: _singleFieldWidget ??
                      Container(
                        height: 0,
                      ),
                ),
                Divider(
                  height: 0.1,
                  color: Colors.grey[400],
                ),
                Visibility(
                  visible: isNotNullOrEmpty(historyInfo?.tableFields),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: _groupTableFieldWidget ??
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: _tableFieldWidget,
                        ) ??
                        Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, {bool isHeader}) {
    TextStyle textStyle;
    if (isHeader == true)
      textStyle = TextStyle(color: Colors.black);
    else {
      textStyle = TextStyle(color: color);
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                title,
                style: textStyle,
              )),
              Text(value ?? '', style: textStyle)
            ],
          ),
        ),
        Divider(
          height: 0.1,
          color: Colors.grey[400],
        )
      ],
    );
  }
}
