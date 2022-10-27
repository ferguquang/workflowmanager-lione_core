
class Category {
  int iD;
  String name;
  bool isEnable;
  int id;
  String text;

  Category.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    isEnable = json['IsEnable'];
    id = json['id'];
    text = json['Text'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['ID'] = iD;
    json['Name'] = name;
    json['IsEnable'] = isEnable;
    json['id'] = id;
    json['Text'] = text;
    return json;
  }
}