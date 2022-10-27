import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';


class NumberStatisticsWidget extends StatelessWidget {

  String icon;

  String text;

  String number;

  double fontSize;

  NumberStatisticsWidget(this.icon, this.text, this.number, {this.fontSize = 9});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: SizedBox(
                        width: 9,
                        height: 9,
                        child: Image.asset(icon),
                      )
                    ),
                    TextSpan(text: " ${text}", style: TextStyle(color: Colors.black, fontSize: fontSize,),)
                  ]
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  number,
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ))
          ],
        ),
      ),
    );
  }
}
