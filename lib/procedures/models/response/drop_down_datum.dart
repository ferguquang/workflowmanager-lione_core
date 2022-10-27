import 'attribute.dart';

class DropdownDatum {
  String value;
  String text;
  bool selected;
  List<Attribute> attributes = null;

  DropdownDatum({this.value, this.text, this.selected, this.attributes});

  DropdownDatum.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    text = json['Text'];
    selected = json['Selected'];
    if (json['Attributes'] != null) {
      attributes = [];
      json['Attributes'].forEach((v) {
        attributes.add(new Attribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['Value'] = value;
    json['Text'] = text;
    json['Selected'] = selected;
    if (this.attributes != null) {
      json['Attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    return json;
  }
}
