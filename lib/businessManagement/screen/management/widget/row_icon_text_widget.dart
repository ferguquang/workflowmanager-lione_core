import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class RowAndTextWidget extends StatelessWidget {
  IconData icon;
  String text;
  EdgeInsetsGeometry padding;
  double sizeText;
  double sizeIcon;
  Color color;
  FontWeight fontWeight;

  RowAndTextWidget(
      {this.icon,
      this.text,
      this.padding,
      this.sizeText,
      this.color,
      this.fontWeight,
      this.sizeIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 16, right: 8, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              icon ?? Icons.access_time_rounded,
              color: Colors.grey,
              size: sizeIcon ?? 16,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: sizeText ?? 13,
                  color: color ?? getColor('#3e444b'),
                  fontWeight: fontWeight ?? null),
            ),
          )
        ],
      ),
    );
  }
}
