import 'package:flutter/material.dart';

class FloatingButtonWidget extends StatelessWidget {
  final void Function() onSelectedButton;

  FloatingButtonWidget({this.onSelectedButton});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (this.onSelectedButton != null) this.onSelectedButton();
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
        heroTag: null
    );
  }
}
