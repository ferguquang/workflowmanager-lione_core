import 'package:workflow_manager/base/models/base_response.dart';

class SearchUserModelResponse extends BaseResponse {
  List<UserItem> data;

  SearchUserModelResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['Data'] != null) {
      data = new List<UserItem>();
      json['Data'].forEach((v) {
        data.add(new UserItem.fromJson(v));
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

class UserItem {
  int iD;
  String name;
  bool isSelected;

  UserItem({this.iD, this.name, this.isSelected = false});

  UserItem.fromJson(Map<String, dynamic> json) {
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
