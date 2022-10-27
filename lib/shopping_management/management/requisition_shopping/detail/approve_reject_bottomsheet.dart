import 'package:flutter/material.dart';

class ApproveRejectBottomSheet extends StatelessWidget {
  bool isApprove, isReject;

  void Function() onApprove;
  void Function() onReject;

  ApproveRejectBottomSheet(
      {this.onApprove,
      this.onReject,
      this.isApprove = true,
      this.isReject = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: isApprove,
          child: InkWell(
            onTap: () {
              onApprove();
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text("Duyệt")),
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
        Visibility(
          visible: isReject,
          child: InkWell(
            onTap: () {
              onReject();
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text("Từ chối")),
            ),
          ),
        )
      ],
    );
  }
}
