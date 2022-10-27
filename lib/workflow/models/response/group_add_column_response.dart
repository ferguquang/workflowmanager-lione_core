import 'package:workflow_manager/base/models/base_response.dart';

class GroupAddColumnResponse extends BaseResponse {
  int status;
  GroupAddColumnModel data;

  GroupAddColumnResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new GroupAddColumnModel.fromJson(json['Data'])
        : null;
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

class GroupAddColumnModel {
  int iD;
  String colTitle;

  GroupAddColumnModel({this.iD, this.colTitle});

  GroupAddColumnModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    colTitle = json['ColTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ColTitle'] = this.colTitle;
    return data;
  }
}
