import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class TitleInforItem extends StatelessWidget {
  String title;
  Color colors;

  TitleInforItem({this.title, this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            title,
            style: TextStyle(color: colors ?? Colors.black, fontSize: 14),
          ),
        ),
        Divider(
          color: getColor("#DDDDDD"),
          height: 1,
        )
      ],
    );
  }
}
