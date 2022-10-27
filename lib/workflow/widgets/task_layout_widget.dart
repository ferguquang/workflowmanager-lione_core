import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

// ignore: must_be_immutable
class TagLayoutWidget extends StatefulWidget {
  final VoidCallback openFilterListener;
  final VoidCallback openRemoveDataListener;

  String title;

  String value;

  IconData icon;

  double horizontalPadding = 16;

  bool enable;

  bool isShowClearText = false;

  bool isShowValidate;

  TagLayoutWidget(
      {this.title = "",
      this.value = "",
      this.icon,
      this.openFilterListener,
      this.isShowValidate = false,
      this.horizontalPadding = 16,
      this.isShowClearText,
      this.enable = true,
      this.openRemoveDataListener})
      : super();

  @override
  State<StatefulWidget> createState() => _TagLayoutWidget();
}

class _TagLayoutWidget extends State<TagLayoutWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.isShowClearText == null || isNullOrEmpty(widget.value)) {
      widget.isShowClearText = false;
    }
    return Padding(
      padding: EdgeInsets.only(
          left: widget.horizontalPadding,
          top: 8,
          right: widget.horizontalPadding),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (this.widget.enable) {
            this.widget.openFilterListener();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.widget.title,
                  style: TextStyle(color: "#555555".toColor(), fontSize: 14),
                ),
                Text(
                  widget.isShowValidate ? '*' : '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      this.widget.value,
                      style:
                          TextStyle(color: "#555555".toColor(), fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Visibility(
                    visible: widget.isShowClearText,
                    child: InkWell(
                      child: Container(
                        width: 46,
                        child: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          widget.value = '';
                          widget.openRemoveDataListener();
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 20,
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: this.widget.icon != null,
                      child: Icon(
                        this.widget.icon,
                        color: "#939BA2".toColor(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(color: "#DDDDDD".toColor())
          ],
        ),
      ),
    );
  }
}
