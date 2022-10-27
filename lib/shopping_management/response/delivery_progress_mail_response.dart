import 'package:workflow_manager/base/models/base_response.dart';

class DeliveryProgressMailResponse extends BaseResponse {
  int status;
  DeliveryProgressMailModel data;

  DeliveryProgressMailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DeliveryProgressMailModel.fromJson(json['Data'])
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

class DeliveryProgressMailModel {
  int processID;
  String fromMail;
  String toMail;
  String cCMail;
  String subject;
  String content;
  List<int> detailIds;
  List<Users> users;

  DeliveryProgressMailModel(
      {this.processID,
      this.fromMail,
      this.toMail,
      this.cCMail,
      this.subject,
      this.content,
      this.detailIds});

  DeliveryProgressMailModel.fromJson(Map<String, dynamic> json) {
    processID = json['ProcessID'];
    fromMail = json['FromMail'];
    toMail = json['ToMail'];
    cCMail = json['CCMail'];
    subject = json['Subject'];
    content = json['Content'];
    detailIds = json['DetailIds']?.cast<int>();
    if (json['User'] != null) {
      users = new List<Users>();
      json['User'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProcessID'] = this.processID;
    data['FromMail'] = this.fromMail;
    data['ToMail'] = this.toMail;
    data['CCMail'] = this.cCMail;
    data['Subject'] = this.subject;
    data['Content'] = this.content;
    data['DetailIds'] = this.detailIds;
    if (this.users != null) {
      data['User'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  int iDDept;
  String deptName;

  Users(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept,
      this.deptName});

  Users.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    iDDept = json['IDDept'];
    deptName = json['DeptName'];
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
    data['DeptName'] = this.deptName;
    return data;
  }
}