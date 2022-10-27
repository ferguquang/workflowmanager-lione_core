import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/change_status_response.dart';

class GetListJobGroupResponse extends BaseResponse {
  List<DataJobGroupItem> data;

  GetListJobGroupResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['Data'] != null) {
      data = new List<DataJobGroupItem>();
      json['Data'].forEach((v) {
        data.add(new DataJobGroupItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['Messages'] = messages;
    }
    return data;
  }
}

class DataJobGroupItem {
  int iD;
  String name;

  DataJobGroupItem({this.iD, this.name});

  DataJobGroupItem.fromJson(Map<String, dynamic> json) {
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
