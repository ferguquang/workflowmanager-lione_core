import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/logic_column_update.dart';
import 'package:workflow_manager/procedures/models/response/props.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/base/single_field_repository_base.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';

enum CalType { CalRow, Cal, CalCol }

class SingleFieldEditTextRepository extends SingleFieldRepositoryBase {
  bool isShowDateIcon = false;
  bool _isFirstInit = true;
  bool isVisible = true;
  bool isEnable;
  String errorMessages;
  TextEditingController controller;
  TextInputType inputType = TextInputType.text;
  String _oldValue = "";
  String lastValidate = "";
  bool isViewInOneRow;
  WaitNextAction _searchAction;
  List<dynamic> _actionData = [];
  List<TextInputFormatter> inputFormats = [];
  List<String> listNumberTypes = ["number", "fcnumber"];

  SingleFieldEditTextRepository(Field model, bool isReadonly,
      BuildContext context, this.controller, this.isViewInOneRow)
      : super(model, isReadonly, context) {
    _searchAction = WaitNextAction(null,
        doActionMoreData: waitNextAction, duration: Duration(seconds: 1));
  }

  waitNextAction(List<dynamic> value) {
    if (isNotNullOrEmpty(value)) {
      for (SearchInfo searchInfo in value) {
        if (searchInfo.type == SearchInfo.validate)
          handleCheckValidate(searchInfo.data[0], searchInfo.data[1]);
        else if (searchInfo.type == SearchInfo.calculate_with_api) {
          calculateWithApiListener(searchInfo.data[0], searchInfo.data[1]);
        }
      }
    }
    value.clear();
  }

  void loadData(bool isReadonly) {
    setReadonly(isReadonly);
    initWidget();
    setValue(model.value);
  }

  bool isDontSetValue = false;

  void onTextChanged(String text) {
    setValue(text);
  }

  String replaceCode(String text, String code, String value) {
    String pattern = "(^|[\\+\\-\\*/\\s=])$code([\\+\\-\\*/\\s=]|\$)";
    return text.replaceAllMapped(RegExp(pattern), (Match match) {
      return "${match.group(1)}$value${match.group(2)}";
    });
  }

  int calcNextField(List<String> colRowList, String value, int index,
      List<int> indexs, CalType calType) {
    if (colRowList != null && colRowList.length > 0) {
      for (int i = 0; i < colRowList.length; i++) {
        String colRow = colRowList[i];
        String codeHienTai = fields[index].code;
        if (colRow.startsWith(codeHienTai + "=")) continue;
        List<String> cols = colRow.split(RegExp(r"[\+\-\*/\:\s=]+"));
        if (cols.contains(codeHienTai)) {
          colRow = replaceCode(colRow, codeHienTai,
              fields[index].isMoney ? getCurrencyFormat(value) : value);
        }

        List<String> splitColRow = colRow.split("=");
        String resultCol = splitColRow[0].trim(); // valueResult: cột kết quả
        String recipe =
            splitColRow[1].trim(); // công thức tính toán đã có value hiện tại
        cols = recipe.split(RegExp(r"[\+\-\*/\:\s]+"));
        if (isNullOrEmpty(value)) {
          recipe = "";
        } else {
          for (int a = 0; a < fields.length; a++) {
            String code = fields[a].code;
            if (cols.contains(code)) {
              String valueOther = fields[a].value;
              if (isNullOrEmpty(valueOther)) {
                valueOther = "0";
              }
              recipe = replaceCode(recipe, code, valueOther);
            }
          }
        }
        for (int a = 0; a < fields.length; a++) {
          if (resultCol == fields[a].code && isNotNullOrEmpty(resultCol)) {
            String resultColValue = calcString(recipe);
            fields[a].value = resultColValue;
            indexs.add(a);
            for (int b = 0; b < fields.length; b++) {
              if (resultCol == fields[b].code) {
                Props propsResultCol = fields[b].props;
                List<LogicColumnUpdate> calculateWithApiReturnStringValues =
                    propsResultCol.calculateWithApiReturnStringValues;
                if (calculateWithApiReturnStringValues != null &&
                    calculateWithApiReturnStringValues.length > 0) {
                  //đoạn comment này để delay call api khi gõ
                  // SearchInfo searchInfo=SearchInfo(SearchInfo.calculate_with_api, [calculateWithApiReturnStringValues[0], true]);
                  // _actionData.add(searchInfo);
                  // _searchAction.actionMoreData(_actionData);
                  calculateWithApiListener(
                      calculateWithApiReturnStringValues[0], true);
                }

                List<String> colRowList = calType == CalType.CalRow
                    ? propsResultCol.calRow
                    : propsResultCol.cal;
                if (colRowList != null && colRowList.length > 0) {
                  int index = calcNextField(
                      colRowList, resultColValue, a, indexs, calType);
                  if (index != -1) indexs.add(index);
                }

                if (isNotNullOrEmpty(propsResultCol.checkValidate)) {
                  if (_searchAction != null) {
                    //doan nay dùng delay call api khi gõ
                    // SearchInfo searchInfo=SearchInfo(SearchInfo.validate, [propsResultCol.checkValidate[0], b]);
                    // _actionData.add(searchInfo);
                    // _searchAction.actionMoreData(_actionData);
                    handleCheckValidate(propsResultCol.checkValidate[0], b);
                  }
                }
              }
            }
            break;
          }
        }
      }
    }
    return -1;
  }

  String setValue(String text) {
    value = text;
    _actionData = [];
    if (_isFirstInit && isNullOrEmpty(value) && model.hasDefault)
      value = model.defaultValue;
    _isFirstInit = false;
    if (isNullOrEmpty(value)) value = "";
    if (!model.isMoney) {
      List<String> typeNumber = ["decimal", "fcdecimal", "number", "fcnumber"];
      if (typeNumber.contains(model.type)) {
        String value = model.value;
        if (isNotNullOrEmpty(value)) {
          if (value.contains(".") &&
              (model.type == "number" || model.type == "fcnumber")) {
            var part = value.split("\.");
            if (part.length == 2) {
              if (num.tryParse(part[1]) == 0) value = part[0];
            }
          }
        }
      }
    }
    if (model.isDropdown) {
      if (isNotNullOrEmpty(value)) {
        if (model.dropdownData != null) {
          String valueString;
          for (int i = 0; i < model.dropdownData.length; i++) {
            if (value == model.dropdownData[i].value) {
              valueString = model.dropdownData[i].text;
              break;
            }
          }
          if (valueString == null) {
            valueString = "Chưa xác định";
          }
          value = valueString;
        } else {
          value = "";
        }
      } else {
        value = model.displayText ?? "Chưa xác định";
      }
    }

    if (model.isWarning == true) {
      if (isNotNullOrEmpty(model.warning)) {
        value = model.warning ?? "";
        isReadonly = true;
        if (isNotNullOrEmpty(model.colorClass)) {
          contentColor = Colors.red;
        }
      } else {
        value = "";
      }
    }

    if (model.isCheckValidate) {
      if (model.isPass == false) {
        errorMessages = model.textCheckValidate;
      } else {
        errorMessages = null;
      }
    }

    if (isNullOrEmpty(value)) value = "";

    if (model.isMoney) {
      value = getCurrencyFormat(value);
    }
    if (listNumberTypes.contains(model.type)) {
      value = convertDoubleToInt(value);
    }
    model.value = value;
    if (controller.text != value) {
      if ((model.type == "fcdatetime" || model.type == "datetime") &&
          isNotNullOrEmpty(value)) {
        controller.text = value.replaceAll("-", "/");
      } else
        controller.text = value ?? "";
      controller.selection =
          TextSelection.collapsed(offset: value?.length ?? 0);
    }
    if (isViewInOneRow != true) {
      if (value != _oldValue) {
        if (isNotNullOrEmpty(model?.props?.checkValidate)) {
          if (lastValidate != value) if (_searchAction != null) {
            //doan nay dùng delay call api khi gõ
            // SearchInfo searchInfo=SearchInfo(SearchInfo.validate, [model.props.checkValidate[0], fields.indexOf(model)]);
            // _actionData.add(searchInfo);
            // _searchAction.actionMoreData(_actionData);
            handleCheckValidate(
                model.props.checkValidate[0], fields.indexOf(model));
          }
          lastValidate = value;
        }
        if (isNotNullOrEmpty(model.props) &&
            isNotNullOrEmpty(model.props.calRow) &&
            isViewInOneRow != true) {
          List<int> indexs = [];
          calcNextField(model.props.calRow, value, fields.indexOf(model),
              indexs, CalType.CalRow);
          notifyChangedAll(indexs);
        }
        if (isNotNullOrEmpty(model.props) &&
            isNotNullOrEmpty(model.props.cal) &&
            isViewInOneRow != true) {
          List<int> indexs = [];
          calcNextField(model.props.cal, value, fields.indexOf(model), indexs,
              CalType.Cal);
          notifyChangedAll(indexs);
        }
      }
    }
    _oldValue = value;
    return value;
  }

  @override
  void initWidget() {
    isVisible = isViewInOneRow ? !model.isHiddenOnView : !model.isHidden;
    inputFormats = [];
    if (isNotNullOrEmpty(model.type)) {
      switch (model.type) {
        case "text":
        case "fctext":
          {
            inputType = TextInputType.text;
            isShowDateIcon = false;
            break;
          }
        case "number":
        case "fcnumber":
          {
            inputType = TextInputType.numberWithOptions(signed: true);
            isShowDateIcon = false;
            inputFormats = [FilteringTextInputFormatter.digitsOnly];
            break;
          }
        case "decimal":
        case "fcdecimal":
          {
            inputType =
                TextInputType.numberWithOptions(decimal: true, signed: true);
            isShowDateIcon = false;
            break;
          }
        case "fcdatetime":
        case "datetime":
          {
            inputType = TextInputType.datetime;
            isShowDateIcon = !isReadonly;
            isReadonly = true;
          }
      }
    }
    notifyListeners();
  }

  @override
  onTab() async {
    String value = "";
    if (model.type == "fcdatetime" || model.type == "datetime") {
      if (!isShowDateIcon) return;
      String format = Constant.ddMMyyyyHHmm2;
      if (model.isDateOnly == true) {
        format = Constant.ddMMyyyy2;
      }
      if (model.isTimeOnly == true) format = Constant.HHmm;
      DateTimePickerWidget dateTimePickerWidget = DateTimePickerWidget(
        context: context,
        format: format,
        onDateTimeSelected: (date) async {
          DateTime now =
              getDateTimeObject(getCurrentDate(format), format: format);

          DateTime selectedDate = getDateTimeObject(date, format: format);
          int minVal = model.minVal;
          if (minVal == -1) {
            if (selectedDate.compareTo(now) == 1)
              value = date;
            else {
              showErrorToast("Ngày được chọn phải lớn hơn ngày hiện tại");
            }
          } else if (minVal == 0 || minVal == null) {
            value = date;
          } else {
            if (selectedDate.compareTo(now) == -1)
              showErrorToast(
                  "Ngày được chọn phải lớn hơn hoặc bằng ngày hiện tại");
            else {
              value = date;
            }
          }
          setValue(value);
          Props props = model.props;
          if (props != null) {
            List<LogicColumnUpdate> calculateWithApis = props.calculateWithApi;
            if (calculateWithApis != null) {
              if (calculateWithApis.length > 0) // chỉ có 1
              {
                LogicColumnUpdate calculateWithApi = calculateWithApis[0];
                await calculateWithApiListener(calculateWithApi, true);
              }
            }
          }
        },
      );
      if (model.isTimeOnly == true) {
        dateTimePickerWidget.showOnlyTimePicker();
      } else if (model.isDateOnly == true) {
        dateTimePickerWidget.showOnlyDatePicker();
      } else {
        dateTimePickerWidget.showDateTimePicker();
      }
    } else {}
  }

  String get displayText {
    if (model.type == "fcdatetime" ||
        model.type == "datetime" && isNotNullOrEmpty(model?.value)) {
      return model.value.replaceAll("-", "/");
    }
    return model?.value;
  }
}

class SearchInfo {
  static const int validate = 0;
  static const int calculate_with_api = 1;

  int type;
  dynamic data;

  SearchInfo(this.type, this.data);
}
