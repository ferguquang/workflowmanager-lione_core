import 'package:workflow_manager/base/models/base_response.dart';

import 'group_job_member_response.dart';

class GroupMemberReponse extends BaseResponse {
  GroupJobMemberModel data;

  GroupMemberReponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new GroupJobMemberModel.fromJson(json['Data'])
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
