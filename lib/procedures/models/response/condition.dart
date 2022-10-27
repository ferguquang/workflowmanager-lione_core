class Condition {
  String action;
  String type;
  String nextSchemaConditionId;
  int iDServiceRecordWfStep;
  int idSchemaCondition;
  String color;
  String name;

  Condition.fromJson(Map<String, dynamic> json) {
    action = json['Action'];
    type = json['Type'];
    nextSchemaConditionId = json['NextSchemaConditionId'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
    idSchemaCondition = json['IdSchemaCondition'];
    color = json['Color'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['Action'] = action;
    json['Type'] = type;
    json['NextSchemaConditionId'] = nextSchemaConditionId;
    json['IDServiceRecordWfStep'] = iDServiceRecordWfStep;
    json['IdSchemaCondition'] = idSchemaCondition;
    json['Color'] = color;
    json['Name'] = name;
    return json;
  }
}
