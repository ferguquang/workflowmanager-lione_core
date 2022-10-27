import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/procedures/models/response/list_report_state_response.dart';

class RecordReportItem extends StatelessWidget {
  RecordReport recordReport;

  RecordReportItem({this.recordReport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text(
                recordReport.serviceRecordName,
                style: TextStyle(fontWeight: FontWeight.w700),
              )),
          Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 20,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text("Người đăng ký:")),
                Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(this.recordReport.registerName))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 20,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text("Người giải quyết:")),
                Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(this.recordReport.solverName))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.grey,
                  size: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text("Bước:"),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(this.recordReport.stepName))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.grey,
                  size: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text("Trạng thái xử lý:"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(this.recordReport.progressTime),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
