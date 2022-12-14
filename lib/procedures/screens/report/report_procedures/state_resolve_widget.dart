import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/manager/widgets/radio_text_widget.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/procedures/models/event/report_procedure_event.dart';
import 'package:workflow_manager/procedures/models/response/report_procedure_response.dart';

import '../../../../main.dart';

class StateResolveWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StateResolveWidgetState();
  }
}

class _StateResolveWidgetState extends State<StateResolveWidget> {
  List<charts.Series> seriesList;

  bool animate;

  // ReportProjectPlan reportProjectPlan;

  ReportProcedureData reportProcedureData;

  List<WfServiceTypeRecords> wfServiceTypeRecords;

  final _myState = new charts.UserManagedState<String>();

  @override
  void initState() {
    super.initState();
    animate = true;
    if(isNotNullOrEmpty(AppStore.reportProcedureData)) {
      this.reportProcedureData = AppStore.reportProcedureData;
      this.wfServiceTypeRecords =
          AppStore.reportProcedureData.wfServiceTypeRecords;
      setState(() {
        seriesList = _createData(wfServiceTypeRecords);
      });
    }

    eventBus.on<ReportProcedureEvent>().listen((event) {
      this.reportProcedureData = AppStore.reportProcedureData;
      this.wfServiceTypeRecords =
          AppStore.reportProcedureData.wfServiceTypeRecords;
      setState(() {
        seriesList = _createData(wfServiceTypeRecords);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Th???ng k?? tr???ng th??i h??? s?? theo lo???i quy tr??nh th??? t???c"
                      .toUpperCase(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Text(
                  "Hi???n c?? ${this.reportProcedureData.typeCount} lo???i v???i ${this.reportProcedureData.recordTotal} h??? s?? ????ng k??, ${this.reportProcedureData.totalPending} h/s ch??a x??? l??,  ${this.reportProcedureData.recordTotalProcessing} h/s ??ang x??? l??, ${this.reportProcedureData.recordTotalProcessed} h/s ???? ho??n th??nh, ${this.reportProcedureData.recordTotalRejected} h/s ???? t??? ch???i, ${this.reportProcedureData.recordTotalCanceled} h/s hu???",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Expanded(
            child: seriesList == null
                ? EmptyScreen()
                : Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                "S??? l?????ng",
                                style: TextStyle(fontSize: 12),
                              ))),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: 1000,
                            padding: EdgeInsets.all(8),
                            child: charts.BarChart(seriesList,
                                animate: animate,
                                userManagedState: _myState,
                                barGroupingType: charts.BarGroupingType.grouped,
                                selectionModels: [
                                  new charts.SelectionModelConfig(
                                    type: charts.SelectionModelType.info,
                                    changedListener: _onSelectionChanged,
                                  )
                                ]
                                // barGroupingType: charts.BarGroupingType.stacked,
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
          Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RadioTextWidget("EAD189".toColor(), "Ch??a x??? l??"),
                    Padding(
                      padding: EdgeInsets.all(16),
                    ),
                    RadioTextWidget("A0D468".toColor(), "??ang x??? l??"),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RadioTextWidget(Colors.lightBlue, "???? ho??n th??nh"),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                    ),
                    RadioTextWidget("24CBE5".toColor(), "T??? ch???i"),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                    ),
                    RadioTextWidget("FF0000".toColor(), "Hu???"),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
          )
        ],
      ),
    );
  }

  _shortName(String name) {
    if(name.length > 15) {
      return name.substring(0, 15) + "...";
    }
    return name;
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<WfServiceTypeRecords, String>> _createData(
      List<WfServiceTypeRecords> wfServiceTypeRecords) {
    return [
      new charts.Series<WfServiceTypeRecords, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: "xEAD189"),
        domainFn: (WfServiceTypeRecords typeRecords, _) => _shortName(typeRecords.name),
        measureFn: (WfServiceTypeRecords typeRecords, _) => typeRecords.pending,
        data: wfServiceTypeRecords,
      ),
      new charts.Series<WfServiceTypeRecords, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: "xA0D468"),
        domainFn: (WfServiceTypeRecords typeRecords, _) => _shortName(typeRecords.name),
        measureFn: (WfServiceTypeRecords typeRecords, _) =>
            typeRecords.processing,
        data: wfServiceTypeRecords,
      ),
      new charts.Series<WfServiceTypeRecords, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: "x6CBEE7"),
        domainFn: (WfServiceTypeRecords typeRecords, _) => _shortName(typeRecords.name),
        measureFn: (WfServiceTypeRecords typeRecords, _) =>
            typeRecords.processed,
        data: wfServiceTypeRecords,
      ),
      new charts.Series<WfServiceTypeRecords, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: "x24CBE5"),
        domainFn: (WfServiceTypeRecords typeRecords, _) => _shortName(typeRecords.name),
        measureFn: (WfServiceTypeRecords typeRecords, _) =>
            typeRecords.rejected,
        data: wfServiceTypeRecords,
      ),
      new charts.Series<WfServiceTypeRecords, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: "xFF0000"),
        domainFn: (WfServiceTypeRecords typeRecords, _) => _shortName(typeRecords.name),
        measureFn: (WfServiceTypeRecords typeRecords, _) =>
            typeRecords.canceled,
        data: wfServiceTypeRecords,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    if (model.selectedDatum.length <= 0) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${model.selectedDatum.first.datum.name}"),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Ch??a x??? :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.pending}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "??ang x??? l??:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.processing}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "???? ho??n th??nh:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.processed}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "T??? ch???i:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.rejected}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "Hu???:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text("${model.selectedDatum.first.datum.canceled}")
                  ],
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text('????ng'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _myState.selectionModels[charts.SelectionModelType.info] =
                      new charts.UserManagedSelectionModel();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
