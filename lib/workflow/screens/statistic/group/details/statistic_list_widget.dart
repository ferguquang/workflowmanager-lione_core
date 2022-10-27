import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/models/response/get_data_detail_group_job_report_response.dart';

class StatisticListWidget extends StatefulWidget {
  bool isListMembers;
  List<ListReportUserJobGroupManagerAPI> members;
  List<ListJob> listJob;

  StatisticListWidget({this.isListMembers, this.members, this.listJob});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StatisticListWidget();
  }
}

class _StatisticListWidget extends State<StatisticListWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Column(
          children: <Widget>[
            this.widget.isListMembers == true
                ? this._buildTopListMembers()
                : this._buildTopListJobs(),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: this.widget.isListMembers == true
                  ? this.widget.members?.length ?? 0
                  : this.widget.listJob?.length ?? 0,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                return this.widget.isListMembers == true
                    ? this._buildMemberCell(index)
                    : this._buildJobCell(index);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopListMembers() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: "#E9ECEF".toColor(),
          border: Border(bottom: BorderSide(color: "#DDDDDD".toColor(), width: 1))),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                'Thành viên',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  'Số công việc',
                  style: TextStyle(fontSize: 12),
                )),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                'Hiệu suất',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopListJobs() {
    return Container(
      height: 60,
      color: "#E9ECEF".toColor(),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                'Danh sách nhóm',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'Tiến độ',
                    style: TextStyle(fontSize: 14),
                  ))),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              'Người thực hiện',
              style: TextStyle(fontSize: 14),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMemberCell(int index) {
    ListReportUserJobGroupManagerAPI member = this.widget.members[index];
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(
                member.name,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 0, right: 0),
                child: Text(
                  "${member.totalJob}",
                  style: TextStyle(fontSize: 12),
                )),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                '${member.performance.performance}%',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCell(int index) {
    ListJob job = this.widget.listJob[index];
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(
                job.jobName,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                job.progress.name,
                style: TextStyle(
                    fontSize: 14, color: job.progress.color.toColor()),
              ))),
          Expanded(child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              job.userName,
              style: TextStyle(fontSize: 14),
            ),
          )),
        ],
      ),
    );
  }
}
