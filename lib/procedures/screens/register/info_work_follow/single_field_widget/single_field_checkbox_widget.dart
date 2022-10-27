import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

import 'base/single_field_widget_base.dart';

class SingleFieldCheckboxWidget extends SingleFieldWidgetBase {
  SingleFieldCheckboxWidget(Field field, bool isReadonly, bool isViewInOneRow,
      {GlobalKey key, double verticalPadding = 4})
      : super(field, isReadonly, isViewInOneRow,
            key: key, verticalPadding: verticalPadding);

  @override
  _SingleFieldCheckboxWidgetState createState() =>
      _SingleFieldCheckboxWidgetState();
}

class _SingleFieldCheckboxWidgetState
    extends SingleFieldWidgetBaseState<SingleFieldCheckboxWidget> {
  Color colorReadonly = getColor("8b8f92");
  Color colorNormal = Colors.black;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible(),
      child: InkWell(
        onTap: () {
          if (isReadonly()) return;
          widget.field.value = widget.field.value == "1" ? "0" : "1";
          setState(() {});
        },
        child: WidgetListItem(
          isShowInRowInList: isShowInRowInList,
          child: Container(
            padding: EdgeInsets.all(widget.verticalPadding),
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.only(right: 16),
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: widget.field.value == "1",
                      activeColor: isReadonly() ? colorReadonly : colorNormal,
                      checkColor:  Colors.white,
                    )),
                Expanded(
                    child: Text(widget.field?.name ?? "",
                        style: TextStyle(
                            color: isReadonly() ? colorReadonly : colorNormal)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isReadonly() =>
      widget.field.isReadonly == true || widget.isReadonly == true;
}
