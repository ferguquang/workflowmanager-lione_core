import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/version_brief/version_brief_item.dart';

import 'detail/version_detail_procedure_screen.dart';

class TabVersionBriefProcedureScreen extends StatelessWidget {
  DataProcedureDetail dataProcedureDetail;

  TabVersionBriefProcedureScreen({this.dataProcedureDetail});

  @override
  Widget build(BuildContext context) {
    List<RecordVersions> recordVersions = dataProcedureDetail.recordVersions;
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: recordVersions.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: VersionBriefItem(
              model: recordVersions[index],
            ),
            onTap: () async{
              await pushPage(context, VersionDetailProcedureScreen(dataProcedureDetail.recordVersions[index]));
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
