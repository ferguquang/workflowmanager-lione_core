import 'package:workflow_manager/base/models/base_response.dart';

class RegisterTypeResponse extends BaseResponse {
  int status;
  RegisterTypeModel data;

  RegisterTypeResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new RegisterTypeModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class RegisterTypeModel {
  List<RegisterTypes> types;

  RegisterTypeModel({this.types});

  RegisterTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['Types'] != null) {
      types = new List<RegisterTypes>();
      json['Types'].forEach((v) {
        types.add(new RegisterTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.types != null) {
      data['Types'] = this.types.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegisterTypes {
  int iD;
  String name;
  String describe;
  String icon;

  RegisterTypes({this.iD, this.name, this.describe, this.icon});

  RegisterTypes.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    icon = json['Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Icon'] = this.icon;
    return data;
  }
}
