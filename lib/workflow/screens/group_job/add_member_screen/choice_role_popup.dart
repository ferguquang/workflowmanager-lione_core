import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

class ChoiceRolePopup extends StatefulWidget {
  void Function(int) onSelectedRole;

  ChoiceRolePopup({this.onSelectedRole});

  @override
  State<StatefulWidget> createState() {
    return _ChoiceRolePopupState();
  }
}

class _ChoiceRolePopupState extends State<ChoiceRolePopup> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        TitleDialog(
          "Chọn quyền thành viên".toUpperCase(),
          padding: 16,
        ),
        InkWell(
          onTap: () {
            widget.onSelectedRole(1);
          },
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            width: double.infinity,
            child: Text("Thành viên"),
          ),
        ),
        InkWell(
            onTap: () {
              widget.onSelectedRole(2);
            },
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              width: double.infinity,
              child: Text("Quản trị viên"),
            )),
        Padding(
          padding: EdgeInsets.only(top: 24),
        )
      ],
    );
  }
}
