class Position {
  int iD;
  int iDDept;
  String name;
  String describe;
  bool isRemovable = true;

  Position.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDDept = json['IDDept'];
    name = json['Name'];
    describe = json['Describe'];
    isRemovable = json['IsRemovable'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['ID'] = iD;
    json['IDDept'] = iDDept;
    json['Name'] = name;
    json['Describe'] = describe;
    json['IsRemovable'] = isRemovable;
    return json;
  }
}
