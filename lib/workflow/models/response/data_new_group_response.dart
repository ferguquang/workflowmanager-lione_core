import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_edit_respone.dart';

class DataNewGroupResponse extends BaseResponse {
  NewGroupData data;

  DataNewGroupResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data =
        json['Data'] != null ? new NewGroupData.fromJson(json['Data']) : null;
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

class NewGroupData {
  List<ListStatus> listStatus; // Trạng thái: Chưa hoạt động, hoạt động
  List<Priorities> listPriority; // Mức độ ưu tiên: Thấp, trung bình, cao

  NewGroupData({this.listStatus, this.listPriority});

  NewGroupData.fromJson(Map<String, dynamic> json) {
    if (json['ListStatus'] != null) {
      listStatus = new List<ListStatus>();
      json['ListStatus'].forEach((v) {
        listStatus.add(new ListStatus.fromJson(v));
      });
    }
    if (json['ListPriority'] != null) {
      listPriority = new List<Priorities>();
      json['ListPriority'].forEach((v) {
        listPriority.add(new Priorities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listStatus != null) {
      data['ListStatus'] = this.listStatus.map((v) => v.toJson()).toList();
    }
    if (this.listPriority != null) {
      data['ListPriority'] = this.listPriority.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
