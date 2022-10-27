import 'package:workflow_manager/base/models/base_response.dart';

class CreateContentMailResponse extends BaseResponse {
  int status;
  CreateContentMailModel data;

  CreateContentMailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new CreateContentMailModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class CreateContentMailModel {
  int fromUserID;
  String fromMail;
  int iDRecord;
  String subject;
  String content;
  List<User> user;

  CreateContentMailModel(
      {this.fromUserID,
      this.fromMail,
      this.iDRecord,
      this.subject,
      this.content});

  CreateContentMailModel.fromJson(Map<String, dynamic> json) {
    fromUserID = json['FromUserID'];
    fromMail = json['FromMail'];
    iDRecord = json['IDRecord'];
    subject = json['Subject'];
    content = json['Content'];
    if (json['User'] != null) {
      user = new List<User>();
      json['User'].forEach((v) {
        user.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FromUserID'] = this.fromUserID;
    data['FromMail'] = this.fromMail;
    data['IDRecord'] = this.iDRecord;
    data['Subject'] = this.subject;
    data['Content'] = this.content;
    if (this.user != null) {
      data['User'] = this.user.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  int iDDept;

  User(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept});

  User.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    iDDept = json['IDDept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Avatar'] = this.avatar;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['IDDept'] = this.iDDept;
    return data;
  }
}