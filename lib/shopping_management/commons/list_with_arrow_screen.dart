import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/commons/line_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class ListWithArrowScreen extends StatefulWidget {
  String screenTitle;
  List<ContentShoppingModel> data;
  String saveTitle;
  bool isShowSaveButton;
  GestureTapCallback onSaveButtonTap;
  bool isCanClear;
  bool Function(List<ContentShoppingModel>) onValidValue;
  Future Function(ContentShoppingModel) onValueChanged;

  ListWithArrowScreen(
      {this.screenTitle,
      this.data,
      this.saveTitle = "Lọc",
      this.isShowSaveButton = true,
      this.onSaveButtonTap,
      this.isCanClear = false,
      this.onValidValue,
      this.onValueChanged});

  @override
  _ListWithArrowScreenState createState() => _ListWithArrowScreenState();
}

class _ListWithArrowScreenState<T> extends State<ListWithArrowScreen> {
  List<ContentShoppingModel> data;

  @override
  Widget build(BuildContext context) {
    data = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screenTitle ?? ""),
        actions: [
          Visibility(
            visible: widget.isCanClear,
            child: TextButton(
              child: Text(
                "Xóa",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (isNotNullOrEmpty(data)) {
                  for (ContentShoppingModel model in data) {
                    model.idValue = null;
                    model.value = "";
                    model.selected = null;
                  }
                  if (widget.onValueChanged != null) {
                    await widget.onValueChanged(null);
                  }
                  setState(() {});
                }
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data?.length ?? 0,
              itemBuilder: (context, index) {
                return ContentViewShoppingItem(
                  model: data[index],
                  position: index,
                  onClick: (model, position) {
                    if (model.onTap != null) {
                      model.onTap(model);
                      return;
                    }
                    if (model.isDropDown) {
                      ChoiceDialog choiceDialog = ChoiceDialog(
                        context,
                        model.dropDownData,
                        selectedObject: model.selected,
                        getTitle: model.getTitle,
                        hintSearchText: "Tìm kiếm",
                        isSingleChoice: model.isSingleChoice,
                        title: model.title,
                        onAccept: (list) async {
                          model.selected = list;
                          if (isNotNullOrEmpty(list)) {
                            if (model.isSingleChoice) {
                              model.value = model.getTitle(list[0]);
                            } else {
                              model.value = list
                                  .map((e) => model.getTitle(e))
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "");
                            }
                            model.idValue =
                                list.map((e) => "${e.iD}").toList().toString();
                          } else {
                            model.value = "";
                            model.idValue = "";
                            model.selected = null;
                          }
                          if (widget.onValueChanged != null) {
                            await widget.onValueChanged(model);
                          }
                          setState(() {});
                        },
                      );
                      choiceDialog.showChoiceDialog();
                    } else if (model.isOnlyDate) {
                      DateTimePickerWidget(
                        format: Constant.ddMMyyyy,
                        context: context,
                        onDateTimeSelected: (date) async {
                          model.value = date;
                          if (widget.onValueChanged != null) {
                            await widget.onValueChanged(model);
                          }
                          setState(() {});
                        },
                      )..showOnlyDatePicker();
                    } else {
                      if (model.isCheckbox == true) {
                        return;
                      }
                      pushPage(
                          context,
                          InputTextWidget(
                            title: model.title,
                            content: model?.value?.toString() ?? "",
                            onSendText: (text) async {
                              if (model.isMoney == true)
                                text = getCurrencyFormat(text);
                              model.value = text;
                              if (widget.onValueChanged != null) {
                                await widget.onValueChanged(model);
                              }
                              setState(() {});
                            },
                            isNumberic: model.isNumeric,
                            isDecimal: model.isDecimal,
                            isMoney: model.isMoney,
                            model: model,
                          ));
                    }
                  },
                );
              },
            ),
          ),
          Visibility(
            visible: widget.isShowSaveButton,
            child: SaveButton(
              title: widget.saveTitle,
              margin: EdgeInsets.all(16),
              onTap: widget.onSaveButtonTap ??
                  () {
                    for (int i = 0; i < widget.data.length; i++) {
                      if (widget.data[i].isRequire &&
                          isNullOrEmpty(widget.data[i].value)) {
                        ToastMessage.show(
                            "Trường ${widget.data[i].title} cần bắt buộc",
                            ToastStyle.error);
                        return;
                      }
                    }
                    if (widget.onValidValue != null &&
                        !widget.onValidValue(widget.data)) return;
                    Navigator.pop(context, widget.data);
                  },
            ),
          )
        ],
      ),
    );
  }
}
