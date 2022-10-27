import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/models/response/history_model.dart';

class HistoryItem extends StatelessWidget {
  HistoryModel historyModel;

  HistoryItem({this.historyModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: Colors.blue,
            size: 12,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(historyModel.created.toDateTimeFormat()),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: historyModel.describe),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
