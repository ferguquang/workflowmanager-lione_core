import 'package:workflow_manager/base/models/base_response.dart';

class GroupDeptReponse extends BaseResponse {
  List<GroupDeptModel> data;

  GroupDeptReponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<GroupDeptModel>();
      json['Data'].forEach((v) {
        data.add(new GroupDeptModel.fromJson(v));
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

class GroupDeptModel {
  int iD;
  String name;
  bool isSelected;

  GroupDeptModel({this.iD, this.name, this.isSelected});

  GroupDeptModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}
