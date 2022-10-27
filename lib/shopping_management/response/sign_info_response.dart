import 'package:workflow_manager/base/models/base_response.dart';

class SignInfoResponse extends BaseResponse {
  int status;
  SignInfoModel data;

  SignInfoResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    data =
        json['Data'] != null ? new SignInfoModel.fromJson(json['Data']) : null;
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

class SignInfoModel {
  List<Info> info;

  SignInfoModel({this.info});

  SignInfoModel.fromJson(Map<String, dynamic> json) {
    if (json['Info'] != null) {
      info = new List<Info>();
      json['Info'].forEach((v) {
        info.add(new Info.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['Info'] = this.info.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Info {
  String step;
  String name;
  String describe;
  String createdBy;
  Status status;

  Info({this.step, this.name, this.describe, this.createdBy, this.status});

  Info.fromJson(Map<String, dynamic> json) {
    step = json['Step'];
    name = json['Name'];
    describe = json['Describe'];
    createdBy = json['CreatedBy'];
    status =
        json['Status'] != null ? new Status.fromJson(json['Status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Step'] = this.step;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['CreatedBy'] = this.createdBy;
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    return data;
  }
}

class Status {
  int iD;
  String name;
  String bgColor;

  Status({this.iD, this.name, this.bgColor});

  Status.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    bgColor = json['BgColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['BgColor'] = this.bgColor;
    return data;
  }
}
