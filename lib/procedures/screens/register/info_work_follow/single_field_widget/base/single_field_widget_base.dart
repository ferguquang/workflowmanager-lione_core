import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/base/single_field_repository_base.dart';

import '../../../widget_list.dart';
import '../single_field_widget.dart';

class SingleFieldWidgetBase extends StatefulWidget {
  Field field;
  double verticalPadding = 4;
  bool isReadonly;
  Color lableColor = Colors.grey;
  Color contentColor = Colors.black;
  Color contentInOneRowColor = Colors.black;
  bool isViewInOneRow;

  bool isVisible() {
    return isViewInOneRow ? !field.isHiddenOnView : !field.isHidden;
  }
  SingleFieldWidgetBase(this.field, this.isReadonly, this.isViewInOneRow,
      {GlobalKey key, this.verticalPadding = 4})
      : super(key: key ?? GlobalKey()) {
    reload();
  }

  void reload() {
    if (key != null && (key as GlobalKey).currentState != null)
      ((key as GlobalKey).currentState as SingleFieldWidgetBaseState)
          .reloadData();
  }

  @override
  SingleFieldWidgetBaseState createState() => SingleFieldWidgetBaseState();
}

class SingleFieldWidgetBaseState<T extends SingleFieldWidgetBase>
    extends State<SingleFieldWidgetBase> {
  Field field;
  SingleFieldRepositoryBase singleFieldRepositoryBase;
  bool isShowInRowInList;

  void reloadData() {
    singleFieldRepositoryBase?.reloadData();
  }

  @override
  void initState() {
    field = widget.field;
    isShowInRowInList = context
        .findAncestorWidgetOfExactType<SingleFieldWidget>()
        .isShowInRowInList;
    Color color = isShowInRowInList == true ? getColor("#858585") : null;
    if (color != null) {
      widget.lableColor = color;
      widget.contentColor = color;
    }
    if (widget.isReadonly) {
      widget.lableColor = getColor("8b8f92");
      widget.contentColor = getColor("#626262");
    } else {
      widget.lableColor = Colors.black;
      widget.contentColor = widget.lableColor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
