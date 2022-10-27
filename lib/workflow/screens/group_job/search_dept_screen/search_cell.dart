import 'package:flutter/cupertino.dart';

class SearchCell extends StatelessWidget {
  String name;

  SearchCell({this.name});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Text('${name}'),
          ),
        ],
      ),
    );
  }
}
