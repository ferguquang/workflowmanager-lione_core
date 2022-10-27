import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/shared_status_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class TimelineOneColumnWidget extends StatefulWidget {
  const TimelineOneColumnWidget({Key key}) : super(key: key);

  @override
  _TimelineOneColumnWidgetState createState() =>
      _TimelineOneColumnWidgetState();
}

class _TimelineOneColumnWidgetState extends State<TimelineOneColumnWidget> {
  double circleWidth = 25;
  double lineWidth = 2;
  Color lineColor = getColor("66BB6A");
  double paddingTop = 8;
  Color secondColor = getColor("999999");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: circleWidth,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(200)),
                          color: lineColor)),
                  Expanded(
                      child: Container(
                    width: lineWidth,
                    color: lineColor,
                  ))
                ],
              ),
            ),
            Expanded(
                child: Text(
              "04/06/2021",
              style: TextStyle(color: secondColor),
            ))
          ],
        )),
        IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: circleWidth,
                alignment: Alignment.center,
                child: Container(
                  width: 2,
                  color: lineColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: Text(
                      "Cấp duyệt 2",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.supervised_user_circle),
                        ),
                        Padding(padding: EdgeInsets.only(left: 8)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nguyễn Hữu Nhất"),
                            Padding(padding: EdgeInsets.only(top: 4)),
                            Text(
                              "Ban điều hành",
                              style:
                                  TextStyle(fontSize: 12, color: secondColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingTop)),
                  Text(
                    "Trạng thái",
                    style: TextStyle(color: secondColor),
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingTop)),
                  SharedStatusWidget(
                    text: "Chờ xác nhận thay đổi",
                    textColor: getColor("2696F7"),
                    backgroundColor: getColor("EBF5FE"),
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingTop)),
                  Text(
                    "Ghi chú",
                    style: TextStyle(color: secondColor),
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingTop)),
                  Text("OK")
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
