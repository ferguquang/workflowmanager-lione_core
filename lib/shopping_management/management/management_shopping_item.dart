import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/image_circle_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/manager/models/module.dart';

class ManagementShoppingItem extends StatelessWidget {
  Module model;

  ManagementShoppingItem(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageAssetCircleWidget(
          // color: getColor('#D9EEE8'),
          image: "assets/images/${model.image}.png",
          height: 64, width: 64,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(model.name.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getColor('#333333'),
                  fontSize: 12)),
        )
      ],
    );
  }
}
