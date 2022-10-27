import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_response.dart';
import 'package:workflow_manager/base/extension/string.dart';

class StatisticGroupTaskCell extends StatefulWidget {
  DataGroupJobItem item = new DataGroupJobItem();

  StatisticGroupTaskCell({this.item});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StatisticGroupTaskCell();
  }
}

class _StatisticGroupTaskCell extends State<StatisticGroupTaskCell> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Text(
              this.widget.item.jobGroupName,
              style: TextStyle(
                  fontSize: 14,
                  color: "#00689D".toColor(),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Text(
                '${this.widget.item.totalMember}',
                style: TextStyle(fontSize: 12),
              )),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 16, top: 10),
            child: Text(
              '${this.widget.item.performance}%',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 16, top: 10),
          child: Row(
            children: <Widget>[
              Text(
                '${this.widget.item.rate}',
                style: TextStyle(fontSize: 14),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2),
                child: this.widget.item.rate == 0
                    ? Icon(
                        Icons.star_border,
                        size: 20,
                      )
                    : Icon(
                        Icons.star,
                        color: "#FFC52F".toColor(),
                        size: 20,
                      ),
              )
            ],
          ),
        )),
      ],
    );
  }
}
