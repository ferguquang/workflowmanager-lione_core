class GenTableRow {
  String origin;
  List<String> targets;
  List<String> valueFroms;
  String refValue;
  List<String> params;
  String scope;
  String link;

  GenTableRow(
      {this.origin,
      this.targets,
      this.refValue,
      this.params,
      this.scope,
      this.link});

  GenTableRow.fromJson(Map<String, dynamic> json) {
    origin = json['Origin'];
    targets = json['Targets']?.cast<String>();
    valueFroms = json['ValueFroms']?.cast<String>();
    refValue = json['RefValue'];
    params = json['Params']?.cast<String>();
    scope = json['Scope'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Origin'] = this.origin;
    data['Targets'] = this.targets;
    data['ValueFroms'] = this.valueFroms;
    data['RefValue'] = this.refValue;
    data['Params'] = this.params;
    data['Scope'] = this.scope;
    data['Link'] = this.link;
    return data;
  }
}