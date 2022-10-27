import 'package:flutter/material.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';

class VersionBriefItem extends StatelessWidget {
  RecordVersions model;

  VersionBriefItem({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.additionStep, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4,),
          _buildRow(Icon(Icons.account_circle_outlined, color: Colors.grey, size: 16), "Người yêu cầu bổ sung: ${model.requierName}"),
          SizedBox(height: 4,),
          _buildRow(Icon(Icons.account_circle_outlined, color: Colors.grey, size: 16), "Người bổ sung: ${model.additionerName}"),
          SizedBox(height: 4,),
          _buildRow(Icon(Icons.access_time_rounded, color: Colors.grey, size: 16), "Thời gian bổ sung hồ sơ: ${model.additionTime.replaceAll("-", "/")}"),
        ],
      ),
    );
  }

  Widget _buildRow(Icon icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        Padding(padding: EdgeInsets.only(right: 4)),
        Expanded(child: Text("$value"))
      ],
    );
  }
}
