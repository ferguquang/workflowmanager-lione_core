import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/states_widget.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';

class SearchUserCell extends StatelessWidget {
  UserItem user = new UserItem();

  SearchUserCell({this.user});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Row(children: [
              Expanded(child: Text('${user.name}')),
              StatesWidget(user.isSelected ?? false),
            ],),
          ),
        ],
      ),
    );
  }
}
