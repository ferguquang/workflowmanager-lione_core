import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:workflow_manager/procedures/models/response/is_rate_response.dart';

class RateLevelsLayout extends StatefulWidget {
  List<RateLevels> rateLevels;
  void Function(RateLevels) onSelected;

  RateLevelsLayout({this.rateLevels, this.onSelected});

  @override
  _RateLevelsLayoutState createState() => _RateLevelsLayoutState();
}

class _RateLevelsLayoutState extends State<RateLevelsLayout> {
  @override
  Widget build(BuildContext context) {
    return Tags(
      symmetry: false,
      columns: 3,
      spacing: 20,
      horizontalScroll: false,
      itemCount: this.widget.rateLevels.length,
      itemBuilder: (index) {
        RateLevels _item = this.widget.rateLevels[index];
        return ItemTags(
          textScaleFactor: 1,
          elevation: 0,
          key: Key(index.toString()),
          index: index,
          title: _item.isSelected ? " ${_item.action}" : "${_item.action} ",
          //trick to change color background when select
          pressEnabled: true,
          activeColor: Colors.blue,
          highlightColor: Colors.blue,
          singleItem: false,
          active: _item.isSelected,
          splashColor: Colors.blue,
          onPressed: (item) {
            setState(() {
              this.widget.rateLevels.forEach((element) {
                element.isSelected = false;
              });
              this.widget.rateLevels[index].isSelected = true;
            });
            this.widget.onSelected(_item);
          },
        );
      },
    );
  }
}
