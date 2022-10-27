class Fields {
  int iD;
  String name;
  String type;
  bool isMultiple;
  String key;
  bool isDropdown;
  bool isCheckbox;
  bool isMoney;
  bool isReadonly;
  bool isHidden;
  bool isHiddenOnView;
  bool isRequired;
  int iDTable;
  int maxChar;
  int maxVal;
  int minVal;
  int minChar;
  String code;
  String value;

  Fields(
      {this.iD,
      this.name,
      this.type,
      this.isMultiple,
      this.key,
      this.isDropdown,
      this.isCheckbox,
      this.isMoney,
      this.isReadonly,
      this.isHidden,
      this.isHiddenOnView,
      this.isRequired,
      this.iDTable,
      this.maxChar,
      this.maxVal,
      this.minVal,
      this.minChar,
      this.code,
      this.value});

  Fields.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    type = json['Type'];
    isMultiple = json['IsMultiple'];
    key = json['Key'];
    isDropdown = json['IsDropdown'];
    isCheckbox = json['IsCheckbox'];
    isMoney = json['IsMoney'];
    isReadonly = json['IsReadonly'];
    isHidden = json['IsHidden'];
    isHiddenOnView = json['IsHiddenOnView'];
    isRequired = json['IsRequired'];
    iDTable = json['IDTable'];
    maxChar = json['MaxChar'];
    maxVal = json['MaxVal'];
    minVal = json['MinVal'];
    minChar = json['MinChar'];
    code = json['Code'];
    value = json['Value'];
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
    data['IsHidden'] = this.isHidden;
    data['IsHiddenOnView'] = this.isHiddenOnView;
    data['IsRequired'] = this.isRequired;
    data['IDTable'] = this.iDTable;
    data['MaxChar'] = this.maxChar;
    data['MaxVal'] = this.maxVal;
    data['MinVal'] = this.minVal;
    data['MinChar'] = this.minChar;
    data['Code'] = this.code;
    data['Value'] = this.value;
    return data;
  }
}
