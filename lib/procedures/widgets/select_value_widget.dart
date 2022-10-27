import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/filter/list_select_screen.dart';

class SelectValueWidget extends StatelessWidget {
  String name;
  String value;
  IconData icon;
  Function() onPressed;

  SelectValueWidget(this.name, {this.value, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Column(
        children: [
          Container(
            height: 40,
            child: Row (
              children: [
                Expanded(child: Text(name)),
                Row (
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.grey),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),),
                    Padding(padding: EdgeInsets.only(left: 8),),
                    Icon(isNotNullOrEmpty(icon) ? icon : Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: "DDDDDD".toColor())
        ],
      ),
    );
  }
}