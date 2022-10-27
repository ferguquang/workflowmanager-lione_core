import 'package:workflow_manager/base/models/base_response.dart';

import 'filter_task_response.dart';
import 'list_status_response.dart';

class FilterColumnGroupResponse extends BaseResponse {

  FilterColumnGroupData data;

  FilterColumnGroupResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data =
    json['Data'] != null ? new FilterColumnGroupData.fromJson(json['Data']) : null;
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

class FilterColumnGroupData {

  List<Priorities> priorities;

  List<StatusItem> statuses;

  List<Types> types;

  int executerType;
  int createdType;
  int supervisorType;
  int coExecuter;

  FilterColumnGroupData({this.priorities, this.statuses, this.executerType,
    this.createdType,
    this.supervisorType,
    this.coExecuter});

  FilterColumnGroupData.fromJson(Map<String, dynamic> json) {
    if (json['Priority'] != null) {
      priorities = new List<Priorities>();
      json['Priority'].forEach((v) {
        priorities.add(new Priorities.fromJson(v));
      });
    }
    if (json['Status'] != null) {
      statuses = new List<StatusItem>();
      json['Status'].forEach((v) {
        statuses.add(new StatusItem.fromJson(v));
      });
    }
    if (json['Type'] != null) {
      types = new List<Types>();
      json['Type'].forEach((v) {
        types.add(new Types.fromJson(v));
      });
    }
    executerType = json['ExecuterType'];
    createdType = json['CreatedType'];
    supervisorType = json['SupervisorType'];
    coExecuter = json['CoExecuter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priorities != null) {
      data['Priority'] = this.priorities.map((v) => v.toJson()).toList();
    }
    if (this.statuses != null) {
      data['Status'] = this.statuses.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['Type'] = this.types.map((v) => v.toJson()).toList();
    }
    data['ExecuterType'] = this.executerType;
    data['CreatedType'] = this.createdType;
    data['SupervisorType'] = this.supervisorType;
    data['CoExecuter'] = this.coExecuter;
    return data;
  }
}