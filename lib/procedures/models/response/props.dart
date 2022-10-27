import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/gen_table_row.dart';

import 'column_logic.dart';
import 'logic_column_update.dart';

class Props {
  List<ColumnLogic> show;
  List<String> calCol;
  List<ColumnLogic> readonly;
  List<ColumnLogic> enableRow;

  List<ColumnLogic> hidden;
  List<ColumnLogic> enableCol;
  List<ColumnLogic> updateValueRange;
  List<ColumnLogic> enable;

  List<ColumnLogic> showCol;
  List<ColumnLogic> updateSelectedValue;
  List<String> cal;
  List<ColumnLogic> readonlyCol;

  List<ColumnLogic> readonlyRow;
  List<ColumnLogic> hiddenCol;
  List<String> calRow;
  List<LogicColumnUpdate> calculateWithApiReturnStringValues;

  List<LogicColumnUpdate> calculateWithApi;
  List<LogicColumnUpdate> updateApiLinkDropDowns;
  List<LogicColumnUpdate> updateInfos;
  List<LogicColumnUpdate> checkValidate;
  List<GenTableRow> genTableRows;

  Props();

  Props.fromJson(Map<String, dynamic> json) {
    if (json["GenTableRow"] != null) {
      genTableRows = [];
      (json["GenTableRow"] as List).forEach((element) {
        genTableRows.add(GenTableRow.fromJson(element));
      });
    }
    if (json['Show'] != null) {
      show = [];
      json['Show'].forEach((v) {
        show.add(new ColumnLogic.fromJson(v));
      });
    }
    if (isNotNullOrEmpty(json['CalCol']))
      calCol =
          (json['CalCol'] as List<dynamic>).map((e) => e.toString()).toList();
    if (json['Readonly'] != null) {
      readonly = [];
      json['Readonly'].forEach((v) {
        readonly.add(new ColumnLogic.fromJson(v));
      });
    }
    if (json['EnableRow'] != null) {
      enableRow = [];
      json['EnableRow'].forEach((v) {
        enableRow.add(new ColumnLogic.fromJson(v));
      });
    }
    if (json['Hidden'] != null) {
      hidden = [];
      json['Hidden'].forEach((v) {
        hidden.add(new ColumnLogic.fromJson(v));
      });
    }
    if (json['EnableCol'] != null) {
      enableCol = [];
      json['EnableCol'].forEach((v) {
        enableCol.add(new ColumnLogic.fromJson(v));
      });
    }
    if (json['UpdateValueRange'] != null) {
      updateValueRange = [];
      json['UpdateValueRange'].forEach((v) {
        updateValueRange.add(new ColumnLogic.fromJson(v));
      });
    }
    if (json['Enable'] != null) {
      enable = [];
      json['Enable'].forEach((v) {
        enable.add(new ColumnLogic.fromJson(v));
      });
    }

    if (json['ShowCol'] != null) {
      showCol = [];
      json['ShowCol'].forEach((v) {
        showCol.add(new ColumnLogic.fromJson(v));
      });
    }
    if (json['UpdateSelectedValue'] != null) {
      updateSelectedValue = [];
      json['UpdateSelectedValue'].forEach((v) {
        updateSelectedValue.add(new ColumnLogic.fromJson(v));
      });
    }
    if (isNotNullOrEmpty(json['Cal']))
      cal = (json['Cal'] as List<dynamic>).map((e) => e.toString()).toList();
    if (json['ReadonlyCol'] != null) {
      readonlyCol = [];
      json['ReadonlyCol'].forEach((v) {
        readonlyCol.add(new ColumnLogic.fromJson(v));
      });
    }

    if (json['ReadonlyRow'] != null) {
      readonlyRow = [];
      json['ReadonlyRow'].forEach((v) {
        readonlyRow.add(new ColumnLogic.fromJson(v));
      });
    }
    if (json['HiddenCol'] != null) {
      hiddenCol = [];
      json['HiddenCol'].forEach((v) {
        hiddenCol.add(new ColumnLogic.fromJson(v));
      });
    }
    if (isNotNullOrEmpty(json['CalRow']))
      calRow =
          (json['CalRow'] as List<dynamic>).map((e) => e.toString()).toList();
    if (json['CalculateWithApiReturnStringValue'] != null) {
      calculateWithApiReturnStringValues = [];
      json['CalculateWithApiReturnStringValue'].forEach((v) {
        calculateWithApiReturnStringValues
            .add(new LogicColumnUpdate.fromJson(v));
      });
    }
    if (json['CalculateWithApi'] != null) {
      calculateWithApi = [];
      json['CalculateWithApi'].forEach((v) {
        calculateWithApi.add(new LogicColumnUpdate.fromJson(v));
      });
    }

    if (json['UpdateApiLinkDropDown'] != null) {
      updateApiLinkDropDowns = [];
      json['UpdateApiLinkDropDown'].forEach((v) {
        updateApiLinkDropDowns.add(new LogicColumnUpdate.fromJson(v));
      });
    }
    if (json['UpdateInfo'] != null) {
      updateInfos = [];
      json['UpdateInfo'].forEach((v) {
        updateInfos.add(new LogicColumnUpdate.fromJson(v));
      });
    }
    if (json['CheckValidate'] != null) {
      checkValidate = [];
      json['CheckValidate'].forEach((v) {
        checkValidate.add(new LogicColumnUpdate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    if (this.show != null) {
      json['Show'] = this.show.map((v) => v.toJson()).toList();
    }
    json["CalCol"] = calCol;
    if (this.readonly != null) {
      json['Readonly'] = this.readonly.map((v) => v.toJson()).toList();
    }
    if (this.enableRow != null) {
      json['EnableRow'] = this.enableRow.map((v) => v.toJson()).toList();
    }

    if (this.hidden != null) {
      json['Hidden'] = this.hidden.map((v) => v.toJson()).toList();
    }
    if (this.enableCol != null) {
      json['EnableCol'] = this.enableCol.map((v) => v.toJson()).toList();
    }
    if (this.updateValueRange != null) {
      json['UpdateValueRange'] =
          this.updateValueRange.map((v) => v.toJson()).toList();
    }
    if (this.enable != null) {
      json['Enable'] = this.enable.map((v) => v.toJson()).toList();
    }

    if (this.showCol != null) {
      json['ShowCol'] = this.showCol.map((v) => v.toJson()).toList();
    }
    if (this.updateSelectedValue != null) {
      json['UpdateSelectedValue'] =
          this.updateSelectedValue.map((v) => v.toJson()).toList();
    }
    json["Cal"] = cal;
    if (this.readonlyCol != null) {
      json['ReadonlyCol'] = this.readonlyCol.map((v) => v.toJson()).toList();
    }
    if (this.readonlyRow != null) {
      json['ReadonlyRow'] = this.readonlyRow.map((v) => v.toJson()).toList();
    }
    if (this.hiddenCol != null) {
      json['HiddenCol'] = this.hiddenCol.map((v) => v.toJson()).toList();
    }
    json["CalRow"] = calRow;
    if (this.calculateWithApiReturnStringValues != null) {
      json['CalculateWithApiReturnStringValues'] = this
          .calculateWithApiReturnStringValues
          .map((v) => v.toJson())
          .toList();
    }
    if (this.calculateWithApi != null) {
      json['CalculateWithApi'] =
          this.calculateWithApi.map((v) => v.toJson()).toList();
    }
    if (this.updateApiLinkDropDowns != null) {
      json['UpdateApiLinkDropDowns'] =
          this.updateApiLinkDropDowns.map((v) => v.toJson()).toList();
    }
    if (this.updateInfos != null) {
      json['UpdateInfos'] = this.updateInfos.map((v) => v.toJson()).toList();
    }
    if (this.checkValidate != null) {
      json['CheckValidate'] =
          this.checkValidate.map((v) => v.toJson()).toList();
    }
    return json;
  }
}
