import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/models/base_response.dart';

import 'list_task_model_response.dart';

class ListTaskGroupResponse extends BaseResponse {
  ListTaskGroupModel data;

  ListTaskGroupResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = isNotNullOrEmpty(json['Data'])
        ? new ListTaskGroupModel.fromJson(json['Data'])
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

class ListTaskGroupModel {
  List<TaskIndexItem> arrayTaskGroup;
  int role;

  ListTaskGroupModel({this.arrayTaskGroup, this.role});

  ListTaskGroupModel.fromJson(Map<String, dynamic> json) {
    if (isNotNullOrEmpty(json['result'])) {
      arrayTaskGroup = new List<TaskIndexItem>();
      json['result'].forEach((v) {
        arrayTaskGroup.add(new TaskIndexItem.fromJson(v));
      });
    }
    role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.arrayTaskGroup != null) {
      data['result'] = this.arrayTaskGroup.map((v) => v.toJson()).toList();
    }
    data['Role'] = this.role;
    return data;
  }
}
