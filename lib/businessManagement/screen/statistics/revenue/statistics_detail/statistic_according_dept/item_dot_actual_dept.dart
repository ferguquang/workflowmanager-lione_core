import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class ItemDotActualDept extends StatelessWidget {
  String sColors;
  String text;

  ItemDotActualDept({this.sColors, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              color: getColor(sColors) ?? Colors.red,
              borderRadius: BorderRadius.circular(50)),
        ),
        Expanded(
          child: Text(
            '  $text',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
