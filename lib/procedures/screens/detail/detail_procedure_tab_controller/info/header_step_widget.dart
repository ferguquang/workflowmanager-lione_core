import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class HeaderStepWidget extends StatefulWidget {
  String title;
  void Function(bool) onToggle;
  bool isExpand = true;

  HeaderStepWidget(this.title, this.onToggle, this.isExpand);

  @override
  _HeaderStepWidgetState createState() => _HeaderStepWidgetState();
}

class _HeaderStepWidgetState extends State<HeaderStepWidget> {
  double size = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColor("#F2F2F2"),
      child: Row(
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
          ),
          InkWell(
            onTap: () {
              widget.isExpand = !widget.isExpand;
              setState(() {});
              widget.onToggle(widget.isExpand);
            },
            child: Container(
              alignment: Alignment.center,
              height: size,
              width: size,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: getColor("#7C7C7C"), width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Icon(
                widget.isExpand
                    ? Icons.arrow_drop_down_outlined
                    : Icons.arrow_right,
                color: getColor(
                  "#7C7C7C",
                ),
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
