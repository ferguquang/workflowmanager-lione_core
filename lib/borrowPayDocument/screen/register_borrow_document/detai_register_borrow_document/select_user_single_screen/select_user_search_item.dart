import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_auser_response.dart';

class SelectedUserSearchItem extends StatelessWidget {
  AUser user;

  SelectedUserSearchItem(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          CircleNetworkImage(
            url: '${user.avatar}',
            height: 40,
            width: 40,
          ),
          Expanded(child: Text('  ${user?.name}')),
          user.isCheck
              ? Icon(
                  Icons.check_box_sharp,
                  color: Colors.blue,
                  size: 25,
                )
              : Icon(
                  null,
                  color: Colors.white,
                  size: 20,
                )
        ],
      ),
    );
  }
}
