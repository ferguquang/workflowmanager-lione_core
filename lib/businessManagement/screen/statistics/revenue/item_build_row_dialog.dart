import 'package:flutter/material.dart';

class ItemBuildRowDialog extends StatelessWidget {
  String name;
  String value;

  ItemBuildRowDialog(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 0),
      child: RichText(
        text: TextSpan(
          text: '',
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
                text: '$name: ',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            TextSpan(
              text: value,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      // child: Row(
      //   children: <Widget>[
      //     Text(
      //       name,
      //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      //     ),
      //     Text(
      //       ' $value',
      //       style: TextStyle(fontSize: 14),
      //     )
      //   ],
      // ),
    );
  }
}
