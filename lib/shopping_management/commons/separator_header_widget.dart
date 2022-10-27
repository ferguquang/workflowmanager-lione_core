import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class SeparatorHeaderWidget extends StatelessWidget {
  String title;
  bool isShowIcon;
  GestureTapCallback onTap;

  SeparatorHeaderWidget(this.title, {this.isShowIcon: false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: getColor("#F1F1F1")),
      child: Row(
        children: [
          Expanded(child: Text(title ?? "")),
          Visibility(
              visible: isShowIcon,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(1000)),
                      color: Colors.blue),
                  child: Icon(
                    Icons.add,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
