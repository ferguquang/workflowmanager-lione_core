import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_detail_main/group_job_detail_response.dart';

class ChangeGroupJobStatusReponse extends BaseResponse {
  CurrentStatus data;

  ChangeGroupJobStatusReponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = CurrentStatus.fromJson(json['Data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data;
    }
    data['Messages'] = this.messages;
    return data;
  }
}
