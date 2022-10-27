import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

import '../item_dot_actual_overview.dart';

class PercentGirdView extends StatelessWidget {
  double _aspectRatio = 7.0, _crossAxisSpacing = 0.2, _mainAxisSpacing = 0.2;
  List<ColorNotes> listDotActual;

  PercentGirdView(this.listDotActual);

  @override
  Widget build(BuildContext context) {
    return isNullOrEmpty(listDotActual)
        ? EmptyScreen()
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listDotActual.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: _aspectRatio,
              crossAxisSpacing: _crossAxisSpacing,
              mainAxisSpacing: _mainAxisSpacing,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              ColorNotes item = listDotActual[index];
              return ItemDotActualOverView(
                text: item.name,
                sColors: item.color,
              );
            },
          );
  }
}
