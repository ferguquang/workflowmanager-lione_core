import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/history/detail/history_detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/history/histories_procedure_item.dart';

class TabHistoryDetailProcedureScreen extends StatelessWidget {
  DataProcedureDetail data;

  TabHistoryDetailProcedureScreen({this.data});

  @override
  Widget build(BuildContext context) {
    List<Histories> histories = data.histories;
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: histories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: HistoriesProcedureItem(
              model: histories[index],
              position: index,
            ),
            onTap: () {
              pushPage(context, HistoryDetailProcedureScreen(
                idServiceRecord: data.iDServiceRecord,
                histories: histories[index],
              ));
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}