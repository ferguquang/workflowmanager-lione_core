import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/day.dart';

class FilterStatesWidget extends StatefulWidget {
  bool state;

  Function onPressed;

  FilterStatesWidget(this.state, {this.onPressed});

  @override
  State<StatefulWidget> createState() => _FilterStatesWidget();
}

class _FilterStatesWidget extends State<FilterStatesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Icon(
      widget.state ? Icons.check_circle : Icons.circle,
      color: widget.state ? Colors.green : Colors.grey[300],
      size: 24.0,
    ));
  }
}
