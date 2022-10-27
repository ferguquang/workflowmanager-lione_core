import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_manager_response.dart';
import 'package:workflow_manager/base/extension/string.dart';

class StatisticManagerTaskCell extends StatefulWidget {
  DataMemberItem item = new DataMemberItem();

  StatisticManagerTaskCell({this.item});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StatisticManagerTaskCell();
  }
}

class _StatisticManagerTaskCell extends State<StatisticManagerTaskCell> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Text(
              this.widget.item.name,
              style: TextStyle(
                  fontSize: 14,
                  color: "#00689D".toColor(),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, right: 32),
          child: Text(
            '${this.widget.item.totalJob}',
            style: TextStyle(fontSize: 12),
          ),
        )
      ],
    );
  }
}
