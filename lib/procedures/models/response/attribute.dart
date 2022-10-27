class Attribute {
  String key;

  String value;

  Attribute.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['Key'] = key;
    json['Value'] = value;
    return json;
  }
}
