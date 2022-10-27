import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class RowAndTwoText extends StatelessWidget {
  IconData icon;
  String textTitle;
  String textValue;
  bool isColors;

  RowAndTwoText({this.icon, this.textTitle, this.textValue, this.isColors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 8, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              icon ?? Icons.access_time_rounded,
              color: Colors.grey,
              size: 16,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: '$textTitle: ',
                      style: TextStyle(
                        fontSize: 13,
                      )),
                  TextSpan(
                      text: textValue,
                      style: TextStyle(
                        fontSize: 13,
                        color: isColors ?? false
                            ? Colors.red
                            : getColor('#3e444b'),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
