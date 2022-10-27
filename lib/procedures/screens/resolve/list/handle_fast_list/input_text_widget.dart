import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/thousands_formatter.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class InputTextWidget extends StatelessWidget {
  String title, content;

  void Function(String) onSendText;
  bool Function(String) onValidate;
  bool isNumberic;
  bool isMoney;
  bool isDecimal;
  bool isEditable;
  ContentShoppingModel model;

  InputTextWidget(
      {this.title,
      this.content,
      this.onSendText,
      this.isNumberic = false,
      this.isDecimal = false,
      this.isMoney = false,
      this.isEditable = true,
      this.onValidate,
      this.model}) {
    if (model != null) {
      this.isNumberic = model.isNumeric;
      this.isDecimal = model.isDecimal;
      this.isMoney = model.isMoney;
      this.content = model.value;
      this.title = model.title;
      this.isEditable = model.isEditable;
    }
    if (this.isMoney == true) {
      if (this.isDecimal != true) this.isDecimal = false;
    }
  }

  TextEditingController controller = TextEditingController();
  bool isChangeManually = false;

  @override
  Widget build(BuildContext context) {
    if (isNotNullOrEmpty(content)) {
      if (isMoney == true) {
        if (isNullOrEmpty(content) || getDouble(content) == 0)
          controller.text = "";
        else
          controller.text = getCurrencyFormat(content, isAllowDot: isDecimal);
      } else
        controller.text = content;
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                enabled: isEditable,
                maxLines: null,
                controller: controller,
                decoration: InputDecoration(hintText: "Nhập nội dung"),
                inputFormatters: getFormatter(),
                keyboardType: isDecimal == true
                    ? TextInputType.numberWithOptions(
                        decimal: true, signed: true)
                    : (isNumberic == true
                        ? TextInputType.numberWithOptions(signed: true)
                        : TextInputType.multiline)),
            Visibility(
              visible: isEditable,
              child: SaveButton(
                margin: EdgeInsets.only(top: 32),
                title: "XONG",
                onTap: () {
                  String textS = controller.text.trim();
                  if (onValidate != null) {
                    if (!onValidate(textS)) {
                      return;
                    }
                  }
                  if (isNumberic || isMoney || isDecimal) {
                    textS = textS.replaceAll(Constant.SEPARATOR_THOUSAND, "");
                  }
                  onSendText(textS);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  List<TextInputFormatter> getFormatter() {
    if (isMoney == true) {
      return [ThousandsFormatter(allowFraction: isDecimal)];
    }
    if (isNumberic == true || isDecimal == true)
      return [FilteringTextInputFormatter.digitsOnly];

    return [];
  }
}
