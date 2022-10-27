import 'package:workflow_manager/workflow/models/message.dart';
import 'package:workflow_manager/base/models/base_response.dart';

class ResponseJobHistory extends BaseResponse {
  int status;
  List<HistoryModel> data;

  ResponseJobHistory.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<HistoryModel>();
      json['Data'].forEach((v) {
        data.add(new HistoryModel.fromJson(v));
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

class HistoryModel {
  String describe;
  String created;

  HistoryModel({this.describe, this.created});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    describe = json['Describe'];
    created = json['Created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Describe'] = this.describe;
    data['Created'] = this.created;
    return data;
  }
}
