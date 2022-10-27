import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/screens/group_job/addition/addition_model.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';

class AdditionItem extends StatelessWidget {
  AdditionModel model;

  AdditionItem(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageAssetCircleWidget(
          color: model.color,
          image: model.iconUrl,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Text(model.title.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getColor('#333333'),
                  fontSize: 12)),
        )
      ],
    );
  }
}
