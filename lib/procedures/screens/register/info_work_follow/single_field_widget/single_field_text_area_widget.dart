import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

import 'base/single_field_widget_base.dart';

class SingleFieldTextAreaWidget extends SingleFieldWidgetBase {
  SingleFieldTextAreaWidget(Field field, bool isReadonly, bool isViewInOneRow,
      {GlobalKey key, double verticalPadding = 4})
      : super(field, isReadonly, isViewInOneRow,
            key: key, verticalPadding: verticalPadding);

  @override
  _SingleFieldTextAreaWidgetState createState() =>
      _SingleFieldTextAreaWidgetState();
}

class _SingleFieldTextAreaWidgetState
    extends SingleFieldWidgetBaseState<SingleFieldTextAreaWidget> {
  Field field;
  TextEditingController _controller = TextEditingController();
  GlobalKey _readonlyKey = GlobalKey();
  double maxHeight = 150;
  bool isOver = false;
  bool isShowAll = false;

  @override
  void initState() {
    super.initState();
    field = widget.field;
    _controller.text = field?.value ?? "";
    if (widget.isViewInOneRow || widget.isReadonly || field.isReadonly) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_readonlyKey?.currentContext != null) {
          RenderBox renderBox = _readonlyKey.currentContext.findRenderObject();
          bool over = renderBox.size.height > maxHeight;
          if (over != isOver) {
            isOver = over;
            setState(() {});
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.isVisible(),
        child: WidgetListItem(
          isShowInRowInList: isShowInRowInList,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
            child: widget.isViewInOneRow
                ? Row(
                    children: [
                      Text(field.name ?? "",
                          style: TextStyle(color: widget.lableColor)),
                      Expanded(
                        child: getReadonlyWidget(),
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            field.name ?? "",
                            style: TextStyle(color: widget.lableColor),
                          ),
                          Visibility(
                            visible: !widget.isReadonly &&
                                !field.isReadonly &&
                                field.isRequired,
                            child: Expanded(
                              child: Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                      getContentWidget()
                    ],
                  ),
          ),
        ));
  }

  Widget getReadonlyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
              maxHeight: isOver
                  ? (isShowAll ? double.infinity : maxHeight)
                  : double.infinity),
          child: Text(
            field?.value ?? "",
            textAlign: TextAlign.end,
            key: _readonlyKey,
            style: TextStyle(color: widget.contentColor),
          ),
        ),
        Visibility(
          visible: isOver,
          child: InkWell(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(1000))),
                child: Text(
                  isShowAll
                      ? "Thu gọn".toUpperCase()
                      : "Xem thêm".toUpperCase(),
                  style: TextStyle(fontSize: 10),
                )),
            onTap: () {
              setState(() {
                isShowAll = !isShowAll;
              });
            },
          ),
        )
      ],
    );
  }

  Widget getContentWidget() {
    if (field.isReadonly || widget.isReadonly) {
      return getReadonlyWidget();
    }
    return TextField(
      controller: _controller,
      style: TextStyle(fontSize: 14),
      onChanged: (value) {
        field.value = value;
      },
      maxLines: 4,
    );
  }
}
