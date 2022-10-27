import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/models/response/list_task_model_response.dart';

class TaskCell extends StatelessWidget {
  TaskIndexItem item = new TaskIndexItem();

  int viewType;

  final VoidCallback onStatusChanged;

  TaskCell({this.item, this.onStatusChanged, this.viewType});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          this._buildCircularPercentIndicator(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                this._buildNameTaskView(),
                this._buildInfoTaskView(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularPercentIndicator() {
    return Container(
        alignment: Alignment.topCenter,
        width: 70,
        height: 70,
        child: CircularPercentIndicator(
          radius: 30.0,
          lineWidth: 2.0,
          animation: true,
          progressColor: item.colorPercentCompleted.toColor(),
          percent:
              double.parse((item.percentCompleted / 100.0).toStringAsFixed(2)),
          center: new Text(
            "${item.percentCompleted.toStringAsFixed(0)}",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 9.0),
          ),
        ));
  }

  Widget _buildNameTaskView() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 0),
        child: Text(
          '${item.jobName}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTaskView(BuildContext context) {
    String endDate = "";
    if (this.item.endDate != null) {
      endDate =
          '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(this.item.endDate))}';
    } else {
      endDate = '--';
    }
    String createdName = "";

    if (this.viewType == 2) {
      //nếu là đã giao thì hiển thị người nhận việc
      if (this.item.executeName != null) {
        createdName = this.item.executeName;
      } else {
        createdName = "--";
      }
    } else {
      //còn lại thì hiển thị người giao việc
      if (this.item.createdByName != null) {
        createdName = this.item.createdByName;
      } else {
        createdName = "--";
      }
    }

    String priority = "";
    String priorityColor = "";
    if (this.item.priority != null) {
      priority = this.item.priority.priorityName;
      priorityColor = this.item.priority.color;
    }

    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/images/ic-clock.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7),
                          ),
                          Text(
                            endDate,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          //Icon(Icons.account_circle_outlined, color: Colors.grey,),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/images/ic-person.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7),
                          ),
                          Text(
                            createdName,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          //Icon(Icons.account_circle_outlined, color: Colors.grey,),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/images/ic-priority.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7),
                          ),
                          Text(
                            priority,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: priorityColor.toColor()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // this._buildStatusView(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusView(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 10),
        child: RaisedButton(
          color: item.jobStatus.color.toColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            '${item.jobStatus.value}',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          onPressed: () {
            this.onStatusChanged();
          },
        ));
  }
}
