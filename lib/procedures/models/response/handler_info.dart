class HandlerInfo {
  int iD;
  String name;
  String describe;
  bool isRemovable = true;
  bool isSelected = false;
  HandlerInfo();
  HandlerInfo.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    isRemovable = json['IsRemovable'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['ID'] = iD;
    json['Name'] = name;
    json['Describe'] = describe;
    json['IsRemovable'] = isRemovable;
    return json;
  }
}
