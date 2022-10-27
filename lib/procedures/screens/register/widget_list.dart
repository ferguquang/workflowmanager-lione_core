import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetListItem extends StatefulWidget {
  EdgeInsets padding;
  Widget child;
  String title;
  bool isCanExpand;
  bool isHeader;
  bool isShowInRowInList;

  WidgetListItem(
      {this.padding = EdgeInsets.zero,
      this.child,
      this.title,
      this.isCanExpand = false,
      this.isHeader = false,
      this.isShowInRowInList = false});

  @override
  _WidgetListItemState createState() => _WidgetListItemState();
}

class _WidgetListItemState extends State<WidgetListItem> {
  @override
  Widget build(BuildContext context) {
    return !widget.isShowInRowInList
        ? widget.child
        : Column(children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: widget.child),
                  Visibility(
                      visible: widget.isCanExpand,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ))
                ],
              ),
            ),
            Divider(
              height: 0.1,
              color: Colors.grey[400],
            ),
          ]);
  }
}
