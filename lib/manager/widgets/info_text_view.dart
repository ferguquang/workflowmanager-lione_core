import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';

class InfoTextView extends StatefulWidget {
  String name;

  String info;

  IconData icon;
  GestureTapCallback onDelete;
  Function() onPressed;

  InfoTextView(this.name,
      {this.info, this.icon, this.onPressed, this.onDelete});

  @override
  State<StatefulWidget> createState() {
    return _InfoTextViewState();
  }
}

class _InfoTextViewState extends State<InfoTextView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    widget.name,
                    style: TextStyle(color: "999999".toColor(), fontSize: 14),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: 40,
                      alignment: Alignment.centerRight,
                      child: this.widget.icon != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.info ?? "",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: "222222".toColor(),
                                        fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                  iconSize: 16,
                                  icon: Icon(this.widget.icon),
                                ),
                                Visibility(
                                  visible: widget.onDelete != null,
                                  child: IconButton(
                                    iconSize: 16,
                                    icon: Icon(Icons.delete),
                                    onPressed: widget.onDelete,
                                  ),
                                )
                              ],
                            )
                          : Text(
                              widget.info,
                            ),
                    ),
                    onTap: () {
                      if (widget.onPressed != null) {
                        this.widget.onPressed();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          child: Divider(color: "E9ECEF".toColor()),
        )
      ],
    );
  }
}
