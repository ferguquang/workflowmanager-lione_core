import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/day.dart';

class StatesWidget extends StatefulWidget {

  bool state;

  Function onPressed;

  StatesWidget(this.state, {this.onPressed});

  @override
  State<StatefulWidget> createState() => _StatesWidgetState();

}
class _StatesWidgetState extends State<StatesWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        widget.state ? Icons.check_box : Icons.check_box_outline_blank,
        color: widget.state ? Colors.blue : Colors.grey,
        size: 16.0,
      )
    );
  }
}