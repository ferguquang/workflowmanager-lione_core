import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget.dart';

import 'api_source.dart';
import 'props.dart';
import 'drop_down_datum.dart';
import 'group_infos.dart';

class Field {
  int iD;
  String name;
  String type;
  bool isMultiple;
  String key;
  bool isDropdown;
  bool isCheckbox;
  bool isMoney;
  bool isReadonly;
  bool isDisabled;
  bool hasDefault;
  String defaultValue;
  bool isHidden;
  bool isHiddenOnView;
  bool isRequired;
  int iDTable;
  int maxChar;
  int maxVal;
  int minVal;
  int minChar;
  String code;
  int fieldIndex;
  String displayText;
  bool isUnique;
  bool isDateOnly;
  bool isTimeOnly;
  List<GroupInfos> groupInfosList;
  List<String> groupValues;
  Props props;
  String value;
  List<String> values;
  List<DropdownDatum> dropdownData;
  String warning = null;

  bool isWarning = false;
  bool isCheckValidate = false;
  bool isPass = true;
  String textCheckValidate = "";
  String colorClass;
  List<int> idRows;
  ApiSource apiSource;

  Field(
      {this.iD,
      this.name,
      this.type,
      this.isMultiple,
      this.key,
      this.isDropdown,
      this.isCheckbox,
      this.isMoney,
      this.isReadonly,
      this.isDisabled,
      this.hasDefault,
      this.defaultValue,
      this.isHidden,
      this.isHiddenOnView,
      this.isRequired,
      this.iDTable,
      this.maxChar,
      this.maxVal,
      this.minVal,
      this.minChar,
      this.code,
      this.fieldIndex,
      this.value,
      this.values,
      this.dropdownData,
      this.isUnique,
      this.isDateOnly,
      this.isTimeOnly,
      this.groupInfosList,
      this.groupValues,
      this.props,
      this.idRows}) {
    if (isCheckbox == true && isNullOrEmpty(value)) {
      value = "0";
    }
  }

  Field.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    value = json['Value'];
    name = json['Name'];
    type = json['Type'];
    isMultiple = json['IsMultiple'];
    key = json['Key'];
    isDateOnly = json['IsDateOnly'];
    isTimeOnly = json['IsTimeOnly'];
    isDropdown = json['IsDropdown'];
    isCheckbox = json['IsCheckbox'];
    isMoney = json['IsMoney'];
    isReadonly = json['IsReadonly'];
    isDisabled = json['IsDisabled'];
    hasDefault = json['HasDefault'];
    defaultValue = json['DefaultValue'];
    isHidden = json['IsHidden'];
    isHiddenOnView = json['IsHiddenOnView'];
    isRequired = json['IsRequired'];
    iDTable = json['IDTable'];
    maxChar = json['MaxChar'];
    maxVal = json['MaxVal'];
    minVal = json['MinVal'];
    minChar = json['MinChar'];
    code = json['Code'];
    fieldIndex = json['FieldIndex'];
    if (json['IDRows'] != null) {
      idRows = new List<int>();
      json['IDRows'].forEach((v) {
        idRows.add(v);
      });
    }
    if (json['Values'] != null) {
      values = new List<String>();
      json['Values'].forEach((v) {
        values.add(v);
      });
    }
    if (json['GroupValues'] != null) {
      groupValues = new List<String>();
      json['GroupValues'].forEach((v) {
        groupValues.add(v);
      });
    }
    if (json["Props"] != null) props = Props.fromJson(json["Props"]);
    if (json["ApiSource"] != null) apiSource = ApiSource.fromJson(json["ApiSource"]);
    if (json['DropdownData'] != null) {
      dropdownData = new List<DropdownDatum>();
      json['DropdownData'].forEach((v) {
        dropdownData.add(new DropdownDatum.fromJson(v));
      });
    }
    if (json['GroupInfosList'] != null) {
      groupInfosList = new List<GroupInfos>();
      json['GroupInfosList'].forEach((v) {
        groupInfosList.add(new GroupInfos.fromJson(v));
      });
    }
    if (json['DropdownData'] != null) {
      dropdownData = new List<DropdownDatum>();
      json['DropdownData'].forEach((v) {
        dropdownData.add(new DropdownDatum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Type'] = this.type;
    data['IsMultiple'] = this.isMultiple;
    data['Key'] = this.key;
    data['IsDropdown'] = this.isDropdown;
    data['IsCheckbox'] = this.isCheckbox;
    data['IsMoney'] = this.isMoney;
    data['IsReadonly'] = this.isReadonly;
    data['IsDisabled'] = this.isDisabled;
    data['HasDefault'] = this.hasDefault;
    data['DefaultValue'] = this.defaultValue;
    data['IsHidden'] = this.isHidden;
    data['IsHiddenOnView'] = this.isHiddenOnView;
    data['IsRequired'] = this.isRequired;
    data['IDTable'] = this.iDTable;
    data['MaxChar'] = this.maxChar;
    data['MaxVal'] = this.maxVal;
    data['MinVal'] = this.minVal;
    data['MinChar'] = this.minChar;
    data['Code'] = this.code;
    data['FieldIndex'] = this.fieldIndex;
    data['Value'] = this.value;
    data['IDRows'] = this.idRows;
    if (this.values != null) {
      data['Values'] = this.values;
    }
    if (this.dropdownData != null) {
      data['DropdownData'] = this.dropdownData.map((v) => v.toJson()).toList();
    }
    if (this.props != null) {
      data['Props'] = this.props.toJson();
    }
    if (this.groupInfosList != null) {
      data['GroupInfosList'] =
          this.groupInfosList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  copyTo(Field target) {
    target.name = this.name;
    target.value = this.value;
    target.isCheckbox = this.isCheckbox;
    target.code = this.code;
    target.iDTable = this.iDTable;
    target.isDropdown = this.isDropdown;
    target.dropdownData = this.dropdownData;
    target.fieldIndex = this.fieldIndex;
    target.isHidden = this.isHidden;
    target.isHiddenOnView = this.isHiddenOnView;
    target.iD = this.iD;
    target.key = this.key;
    target.isMoney = this.isMoney;
    target.isMultiple = this.isMultiple;
    target.props = this.props;
    target.apiSource = this.apiSource;
    target.displayText = this.displayText;
    target.type = this.type;
    target.isRequired = this.isRequired;
    target.value = this.value;
    target.minVal = this.minVal;
    target.isUnique = this.isUnique;
    target.isReadonly = this.isReadonly;
    target.values = this.values;
    target.groupInfosList = this.groupInfosList;
    target.groupInfosList = this.groupInfosList;

    target.minChar = this.minChar;
    target.maxChar = this.maxChar;
    target.minVal = this.minVal;
    target.maxVal = this.maxVal;

    List<String> stringList = [];
    target.groupValues = stringList;

    target.hasDefault = this.hasDefault;
    target.defaultValue = this.defaultValue;
    target.isDateOnly = this.isDateOnly;
    target.isTimeOnly = this.isTimeOnly;
    target.idRows = [];
    if (this.idRows != null) target.idRows.addAll(this.idRows);
  }
}
