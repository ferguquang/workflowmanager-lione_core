import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SharedStatusWidget extends StatelessWidget {
  Color backgroundColor;
  Color textColor;
  EdgeInsetsGeometry padding;
  String text;
  GestureTapCallback onTap;

  SharedStatusWidget(
      {Key key,
      this.backgroundColor = Colors.blue,
      this.textColor = Colors.black,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      this.text,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(200))),
        padding: padding,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
