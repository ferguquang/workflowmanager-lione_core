import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:workflow_manager/base/ui/save_button.dart';

class SortNameBottomSheet extends StatelessWidget {
  int type = 0;
  static final int SORT_A_Z = 1;
  static final int SORT_Z_A = 2;

  void Function(int) onUpdateType;

  SortNameBottomSheet({this.type = 0, this.onUpdateType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onUpdateType(SORT_A_Z);
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sắp xếp theo thứ tự từ A->Z  "),
                Visibility(
                    visible: type == SORT_A_Z,
                    child: Icon(
                      Icons.check,
                      color: Colors.blue,
                    ))
              ],
            ),
          ),
        ),
        Divider(),
        InkWell(
          onTap: () {
            onUpdateType(SORT_Z_A);
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sắp xếp theo thứ tự từ Z->A  "),
                Visibility(
                    visible: type == SORT_Z_A,
                    child: Icon(
                      Icons.check,
                      color: Colors.blue,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [this],
        );
      },
    );
  }
}
