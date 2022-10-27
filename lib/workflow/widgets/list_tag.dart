import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';

// ignore: must_be_immutable
class ListTagWidget extends StatefulWidget {
  List<StatusItem> listStatus;

  UserItem selected;
  IconData icon;
  final void Function(StatusItem) onStatusSelected;

  bool isFirstTime = false;

  ListTagWidget(
      {this.listStatus, this.onStatusSelected, this.selected, this.icon});

  // final VoidCallback onPressed;

  @override
  State<StatefulWidget> createState() => _ListTagWidget();
}

class _ListTagWidget extends State<ListTagWidget> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    return Tags(
      key: _tagStateKey,
      symmetry: false,
      columns: 3,
      spacing: 30,
      horizontalScroll: false,
      itemCount: this.widget.listStatus.length,
      itemBuilder: (index) {
        StatusItem _item = this.widget.listStatus[index];
        print("${_item.isSelected}");
        return ItemTags(
          textScaleFactor: 1,
          elevation: 0,
          key: Key(index.toString()),
          index: index,
          title: _item.isSelected ? " ${_item.value}" : "${_item.value} ",
          //trick to change color background when select
          pressEnabled: true,
          activeColor: Colors.blue,
          highlightColor: Colors.blue,
          singleItem: false,
          active: _item.isSelected,
          splashColor: Colors.blue,
          combine: ItemTagsCombine.withTextBefore,
          image: null,
          icon: widget.icon == null
              ? null
              : ItemTagsIcon(
                  icon: widget.icon, padding: EdgeInsets.only(left: 5)),
          onPressed: (item) {
            setState(() {
              this.resetState();
              this.widget.listStatus[index].isSelected = true;
            });
            this.widget.onStatusSelected(_item);
          },
        );
      },
    );
  }

  void resetState() {
    this.widget.listStatus.forEach((element) {
      element.isSelected = false;
    });
  }
}
