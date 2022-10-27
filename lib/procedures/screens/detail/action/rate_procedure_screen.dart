import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/ratingbar_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';

class RateProcedureScreen extends StatefulWidget {
  @override
  _RateProcedureScreenState createState() => _RateProcedureScreenState();
}

class _RateProcedureScreenState extends State<RateProcedureScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Text("Đánh giá thủ tục"),
        ),
        RatingBarWidget(
          onCountChange: null,
          value: 2,
        ),
        TextField(

        ),
        SaveButton(
          onTap: () {

          },
          title: "XONG",
        )
      ],
    );
  }
}