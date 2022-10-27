import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayRowTextWidget extends StatefulWidget {
  IconData leftIconData;
  String label;
  IconData rightIconData;

  DisplayRowTextWidget(
      {this.leftIconData, this.label, this.content, this.rightIconData});

  String content;

  @override
  _DisplayRowTextWidgetState createState() => _DisplayRowTextWidgetState();
}

class _DisplayRowTextWidgetState extends State<DisplayRowTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Icon(
            widget.leftIconData,
            size: 16,
          ),
          Padding(
            padding: EdgeInsets.only(left: 4),
          ),
          Text(widget.label + ": "),
          Expanded(child: Text(widget.content)),
          Visibility(
            visible: widget.rightIconData != null,
            child: Icon(
              widget.rightIconData,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
