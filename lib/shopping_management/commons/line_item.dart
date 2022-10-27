import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';

class LineItem extends StatelessWidget {
  EdgeInsets padding;
  String title;

  LineItem(this.title, {this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding:padding?? EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      child: Row(children: [
        Expanded(child: Text(title??"")),
        RightArrowIcons()
      ],),
    );
  }
}
