import 'package:workflow_manager/base/models/base_response.dart';

class GroupUserReponse extends BaseResponse {
  GroupUserModel data;

  GroupUserReponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    data =
        json['Data'] != null ? new GroupUserModel.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    data['Messages'] = this.messages;
    return data;
  }
}

class GroupUserModel {
  String position;
  String email;
  String name;
  int id;

  GroupUserModel({this.position, this.email, this.name, this.id});

  GroupUserModel.fromJson(Map<String, dynamic> json) {
    position = json['Position'];
    email = json['Email'];
    name = json['Name'];
    id = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Position'] = this.position;
    data['Email'] = this.email;
    data['Name'] = this.name;
    data['ID'] = this.name;
    return data;
  }
}
