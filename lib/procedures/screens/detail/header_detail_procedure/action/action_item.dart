import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';

class ActionItem extends StatelessWidget {

  Conditions model;

  ActionItem({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(model.action, style: TextStyle(fontSize: 14),),
          Card(
            color: getColor(model.color),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(model.name, style: TextStyle(color: Colors.white, fontSize: 12),),
            )
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey[200])
      ),
    );
  }
}

// dfsdf
