import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';

class ContentShoppingModel {
  dynamic key;
  String title;
  dynamic value; // là text hiển thị
  dynamic idValue; // trong trường hợp là dropdown thì content sẽ là ID
  bool isNextPage, isRequire;
  bool isNumeric;
  bool isCheckbox;
  bool isDecimal;
  bool isMoney;
  bool isDropDown;
  bool isSingleChoice;
  bool isEditable;
  GetTitle getTitle;
  List dropDownData;
  List selected;
  bool isOnlyDate;
  bool isFullDate;
  bool isHtml;
  void Function(ContentShoppingModel) onTap;

  bool isNumber() {
    return isNumeric || isDecimal || isMoney;
  }

  clearSelected() {
    selected = [];
    value = null;
    idValue = null;
  }

  ContentShoppingModel(
      {this.key,
      this.title,
      this.value = "",
      this.isNextPage = true,
      this.isRequire = false,
      this.isNumeric = false,
      this.isDecimal = false,
      this.isDropDown = false,
      this.isSingleChoice = true,
      this.isMoney = false,
      this.dropDownData,
      this.selected,
      this.idValue,
      this.getTitle,
      this.isCheckbox = false,
      this.isEditable = true,
      this.isOnlyDate = false,
      this.onTap,
      this.isFullDate = false,
      this.isHtml = false}) {
    if (isMoney == true) isNumeric = true;
  }

  copyTo(ContentShoppingModel clone) {
    if (clone == null) return;
    clone.key = key;
    clone.title = title;
    clone.value = value;
    clone.idValue = idValue;
    clone.isNextPage = isNextPage;
    clone.isRequire = isRequire;
    clone.isNumeric = isNumeric;
    clone.isDropDown = isDropDown;
    clone.isSingleChoice = isSingleChoice;
    clone.getTitle = getTitle;
    clone.dropDownData = dropDownData;
    clone.selected = selected;
    clone.isDecimal = isDecimal;
    clone.isMoney = isMoney;
  }
}
