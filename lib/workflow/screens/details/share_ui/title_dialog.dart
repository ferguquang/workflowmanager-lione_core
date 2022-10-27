import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleDialog extends StatelessWidget {
  GestureTapCallback onTab;
  String title;
  bool isShowCloseButton;
  double padding;
  double radius;
  IconData iconData;

  TitleDialog(this.title,
      {this.onTab,
      this.isShowCloseButton = true,
      this.padding = 16,
      this.radius = 20,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius))),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )),
          Visibility(
              visible: isShowCloseButton,
              child: InkWell(
                child: Container(
                    constraints: BoxConstraints(minHeight: 40, minWidth: 40),
                    child: Icon(
                      iconData ?? Icons.close,
                      size: 20,
                    )),
                onTap: onTab ??
                    () {
                      Navigator.of(context).pop();
                    },
              ))
        ],
      ),
    );
  }
}
