import 'package:flutter/material.dart';

class ItemBodyAccordingDept extends StatelessWidget {
  String name;
  double value;

  ItemBodyAccordingDept(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              name,
              // style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              "${value == 0.0 ? 0 : value} tỷ",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
