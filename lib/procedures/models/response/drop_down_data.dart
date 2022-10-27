import 'attribute.dart';

class DropdownData {
  String value;
  String text;
  bool selected;
  List<Attribute> attributes;

  DropdownData({this.value, this.text, this.selected, this.attributes});

  DropdownData.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    text = json['Text'];
    selected = json['Selected'];
    if (json['Attributes'] != null) {
      attributes = new List<Attribute>();
      json['Attributes'].forEach((v) {
        attributes.add(Attribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Text'] = this.text;
    data['Selected'] = this.selected;
    if (this.attributes != null) {
      data['Attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
