import 'package:flutter/material.dart';
import 'package:workflow_manager/procedures/models/response/record_is_resolve_list_response.dart';

class SelectedHandleItem extends StatelessWidget {
  ActionsResolve action;

  SelectedHandleItem({this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(action.stateString, style: TextStyle(color: action.isSelected ? Colors.blue : Colors.black),),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: action.isSelected ? Colors.blue : Colors.grey),
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}
