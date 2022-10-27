import 'package:workflow_manager/base/models/base_response.dart';

class GroupJobMemberReponse extends BaseResponse {
  List<GroupJobMemberModel> data;

  GroupJobMemberReponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<GroupJobMemberModel>();
      json['Data'].forEach((v) {
        data.add(new GroupJobMemberModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Messages'] = this.messages;
    return data;
  }
}

class GroupJobMemberModel {
  String deptName;
  String positionName;
  int iD;
  int iDUser;
  String name;
  String email;
  String statusName;
  int role;
  String avatar;

  GroupJobMemberModel(
      {this.deptName,
      this.positionName,
      this.iDUser,
      this.iD,
      this.name,
      this.email,
      this.statusName,
      this.role,
      this.avatar});

  GroupJobMemberModel.fromJson(Map<String, dynamic> json) {
    deptName = json['DeptName'];
    positionName = json['PositionName'];
    iDUser = json['IDUser'];
    iD = json['ID'];
    name = json['Name'];
    email = json['Email'];
    statusName = json['StatusName'];
    role = json['Role'];
    avatar = json['Avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DeptName'] = this.deptName;
    data['PositionName'] = this.positionName;
    data['IDUser'] = this.iDUser;
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['StatusName'] = this.statusName;
    data['Role'] = this.role;
    data['Avatar'] = this.avatar;
    return data;
  }
}
