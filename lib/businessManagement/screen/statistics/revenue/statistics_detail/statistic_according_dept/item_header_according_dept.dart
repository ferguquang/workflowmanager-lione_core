import 'package:flutter/material.dart';

class ItemHeaderAccordingDept extends StatelessWidget {
  String name;
  String value;
  int flex;

  ItemHeaderAccordingDept(this.name, this.value, {this.flex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          height: 10,
          width: double.infinity,
          color: Colors.grey[200],
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: flex ?? 4,
                child: Text(
                  name,
                  // style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  // style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
