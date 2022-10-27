import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class DividerWidget extends StatelessWidget {
  double iHeight;

  DividerWidget({this.iHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: iHeight ?? 10,
      color: getColor("#f1f1f1"),
    );
  }
}
