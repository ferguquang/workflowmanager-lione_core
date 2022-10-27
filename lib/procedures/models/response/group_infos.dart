class GroupInfos {
  String iD = null;
  String name = null;
  String fieldValues = null;

  GroupInfos.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    fieldValues = json['FieldValues'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['ID'] = iD;
    json['Name'] = name;
    json['FieldValues'] = fieldValues;
    return json;
  }
}
