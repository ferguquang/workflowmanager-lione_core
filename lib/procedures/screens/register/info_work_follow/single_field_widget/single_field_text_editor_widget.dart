import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

import 'base/single_field_widget_base.dart';

class SingleFieldTextEditorWidget extends SingleFieldWidgetBase {
  SingleFieldTextEditorWidget(Field field, bool isReadonly, bool isViewInOneRow,
      {GlobalKey key, double verticalPadding = 4})
      : super(
      field, isReadonly, isViewInOneRow,
            key: key, verticalPadding: verticalPadding);

  @override
  SingleFieldTextEditorWidgetState createState() =>
      SingleFieldTextEditorWidgetState();
}

class SingleFieldTextEditorWidgetState
    extends SingleFieldWidgetBaseState<SingleFieldTextEditorWidget> {
  Field field;
  GlobalKey<FlutterSummernoteState> _key = GlobalKey();
  GlobalKey _htmlKey = GlobalKey();
  double maxHeight = 100;
  bool isOver = false;
  bool isShowAll = false;

  Future<String> setTextToField() async {
    if (_key?.currentState == null) return "";
    field.value = await _key.currentState.getText();
    field.value =
        await _key.currentState.getText(); //cần gọi 2 lần để lấy dc text
    return field.value;
  }

  @override
  void initState() {
    super.initState();
    field = widget.field;
    if (widget.isViewInOneRow || widget.isReadonly || field.isReadonly) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_htmlKey?.currentContext != null) {
          RenderBox renderBox = _htmlKey.currentContext.findRenderObject();
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
                      Text(field.name ?? ""),
                      Expanded(
                        child: getReadonlyWidget(),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Text(field.name ?? ""),
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
                  )),
      ),
    );
  }

  Widget getReadonlyWidget() {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
              maxHeight: isOver
                  ? (isShowAll ? double.infinity : maxHeight)
                  : double.infinity),
          child: Html(
            style: {"body": Style(textAlign: TextAlign.end)},
            data: field?.value ?? "",
            key: _htmlKey,
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
    return FocusScope(
      onFocusChange: (value) {
        // print("steasdfasf ngon");
      },
      child: FlutterSummernote(
        height: 200,
        value: field.value,
        customToolbar: """
          [
            ['undo',['undo','redo']],
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert',['link','table']]
          ]
            """,
        showBottomToolbar: false,
        hasAttachment: false,
        key: _key,
      ),
    );
  }
}
