import 'package:workflow_manager/base/models/base_response.dart';

class ListColumnGroupResponse extends BaseResponse {
  List<TabItemGroup> arrayItemTabGroup;

  ListColumnGroupResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['Data'] != null) {
      arrayItemTabGroup = new List<TabItemGroup>();
      json['Data'].forEach((v) {
        arrayItemTabGroup.add(new TabItemGroup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.arrayItemTabGroup != null) {
      data['Data'] = this.arrayItemTabGroup.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class TabItemGroup {
  int iD;
  String colTitle;

  TabItemGroup({this.iD, this.colTitle});

  TabItemGroup.fromJson(Map<String, dynamic> json) {
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

