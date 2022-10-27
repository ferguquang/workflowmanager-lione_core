import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';

class RadioTextWidget extends StatelessWidget {

  Color color;

  String text;

  RadioTextWidget(this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(5)),
          ),
          Padding(padding: EdgeInsets.only(left: 8), child: Text(text, style: TextStyle(fontSize: 10),))
        ],
      ),
    );
  }
}
