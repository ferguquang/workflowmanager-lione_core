import 'package:workflow_manager/base/models/base_response.dart';

class BorrowAuserResponse extends BaseResponse {
  DataBorrowAuser data;

  BorrowAuserResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataBorrowAuser.fromJson(json['Data'])
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

class DataBorrowAuser {
  List<AUser> aUser;

  DataBorrowAuser({this.aUser});

  DataBorrowAuser.fromJson(Map<String, dynamic> json) {
    if (json['AUser'] != null) {
      aUser = new List<AUser>();
      json['AUser'].forEach((v) {
        aUser.add(new AUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aUser != null) {
      data['AUser'] = this.aUser.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AUser {
  int iD;
  String name;
  String avatar;
  String parents;
  bool isCheck = false;

  AUser({this.iD, this.name, this.avatar, this.parents});

  AUser.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    parents = json['Parents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Avatar'] = this.avatar;
    data['Parents'] = this.parents;
    return data;
  }
}
