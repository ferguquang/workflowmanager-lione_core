import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';

class NumberStatisticsWidgetDotIcon extends StatelessWidget {
  String color;

  String text;

  String number;

  double fontSize;

  NumberStatisticsWidgetDotIcon(this.color, this.text, this.number,
      {this.fontSize = 9});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                    color: color.toColor(), shape: BoxShape.circle),
              ),
              Text(
                " ${text}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                ),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                number,
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ))
        ],
      ),
    );
  }
}
