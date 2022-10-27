import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class ItemDotActualOverView extends StatelessWidget {
  String sColors;
  String text;
  List<String> colorActualDots;

  ItemDotActualOverView({this.sColors, this.text, this.colorActualDots});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isNullOrEmpty(colorActualDots)
            ? containerWidget(sColors)
            : Wrap(
                spacing: 5,
                children: isNotNullOrEmpty(colorActualDots) &&
                        colorActualDots.length > 0
                    ? getListWidgets()
                    : [],
              ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            text,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  List<Widget> getListWidgets() {
    if (isNullOrEmpty(colorActualDots) && colorActualDots.length < 1) return [];
    List<Widget> listData =
        colorActualDots.map((e) => containerWidget(e)).toList();
    return listData;
  }

  Widget containerWidget(String colors) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          color: getColor(colors) ?? Colors.red,
          borderRadius: BorderRadius.circular(50)),
    );
  }
}
