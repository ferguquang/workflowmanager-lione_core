import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/data_select_dynamiclly.dart';

class DataSelectDynamicllyResponse extends BaseResponse {
  int status;
  DataSelectDynamiclly data;

  DataSelectDynamicllyResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DataSelectDynamiclly.fromJson(json['Data'])
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
