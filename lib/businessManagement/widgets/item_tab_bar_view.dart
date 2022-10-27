import 'package:flutter/material.dart';

class ItemTabBarView extends Tab {
  String text;

  ItemTabBarView(this.text) : super(text: text);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        text ?? '',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
