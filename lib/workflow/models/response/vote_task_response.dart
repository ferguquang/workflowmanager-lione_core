import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';

import 'change_status_response.dart';

class RatingCloseJobResponse extends BaseResponse {

  StatusItem data;

  RatingCloseJobResponse.fromJson(Map<String, dynamic> json): super.fromJson(json){

    data = json['Data'] != null ? new StatusItem.fromJson(json['Data']) : null;
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
