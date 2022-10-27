import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/list_column_group_response.dart';

class GroupEditColumnResponse extends BaseResponse {
  int status;
  TabItemGroup data;

  GroupEditColumnResponse.fromJson(Map<String, dynamic> json):super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new TabItemGroup.fromJson(json['Data']) : null;
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

