import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class ContentViewShoppingItem extends StatefulWidget {
  ContentShoppingModel model;
  int position;
  void Function(ContentShoppingModel, int) onClick;

  ContentViewShoppingItem({this.model, this.onClick, this.position});

  @override
  _ContentViewShoppingItemState createState() =>
      _ContentViewShoppingItemState();
}

class _ContentViewShoppingItemState extends State<ContentViewShoppingItem> {
  ContentShoppingModel model;

  @override
  Widget build(BuildContext context) {
    model = widget.model;
    return InkWell(
      onTap: () {
        if (model.isCheckbox == true && model.isNextPage == true) {
          model.value = !model.value;
          setState(() {});
        }
        if (widget.onClick != null) {
          if (model.isNextPage) {
            widget.onClick(model, widget.position);
          }
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Text(model?.title ?? ""),
                    Visibility(
                      visible: (model?.isRequire ?? false) && model.isNextPage,
                      child: Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 16)),
                    Expanded(child: getContentWidget()),
                  ],
                )),
                Visibility(
                  child: RightArrowIcons(),
                  visible: (model?.isNextPage ?? false) && !model.isCheckbox,
                )
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
          )
        ],
      ),
    );
  }

  Widget getContentWidget() {
    if (model.isCheckbox) {
      return Container(
          alignment: Alignment.centerRight,
          child: Container(
            height: 20,
            width: 20,
            child: Checkbox(
              value: model.value == true,
            ),
          ));
    } else if (model.isHtml) {
      return Html(data: model.value ?? "");
    }
    return Text(
      getDisplayText(),
      textAlign: TextAlign.end,
    );
  }

  String getDisplayText() {
    if (isNotNullOrEmpty(model?.value)) if (model.isMoney) {
      return getCurrencyFormat(model?.value?.toString() ?? "",
          isAllowDot: model.isDecimal);
    } else if (model.isOnlyDate) {
      return model?.value?.toString()?.replaceAll("-", "/");
    }
    if (isNotNullOrEmpty(model.selected) && isNullOrEmpty(model.value)) {
      return model.selected.map((e) => model.getTitle(e)).join(", ");
    }
    return model?.value?.toString() ?? "";
  }
}
