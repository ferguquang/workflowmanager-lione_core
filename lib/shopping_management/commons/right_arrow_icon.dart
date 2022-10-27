import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RightArrowIcons extends StatelessWidget {
  double size;
  EdgeInsets padding;
  bool isVisible;

  RightArrowIcons({this.size = 20, this.padding, this.isVisible: true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Icon(
          Icons.chevron_right_sharp,
          size: size,
        ),
      ),
    );
  }
}
