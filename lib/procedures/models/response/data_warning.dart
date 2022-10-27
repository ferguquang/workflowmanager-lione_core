class DataWarning {
  String total;
  String value;
  String colorClass;

  DataWarning.fromJson(Map<String, dynamic> json) {
    total = json['Total']==null?null:json['Total'].toString();
    value = json['Value']==null?null:json['Value'].toString();
    colorClass = json['ColorClass']==null?null:json['ColorClass'].toString();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['Total'] = total;
    json['Value'] = value;
    json['ColorClass'] = colorClass;
    return json;
  }
}
