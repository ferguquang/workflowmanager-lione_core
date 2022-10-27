import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/message.dart';

class JobRecipientModel extends BaseResponse {
  int status;
  List<DataJobRecipient> data;

  JobRecipientModel.fromJson(Map<String, dynamic> json):super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<DataJobRecipient>();
      json['Data'].forEach((v) {
        data.add(new DataJobRecipient.fromJson(v));
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
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class DataJobRecipient {
  int iD;
  String name;

  DataJobRecipient({this.iD, this.name});

  DataJobRecipient.fromJson(Map<String, dynamic> json) {
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
