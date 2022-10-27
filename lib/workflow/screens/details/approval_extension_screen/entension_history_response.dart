import 'package:workflow_manager/base/models/base_response.dart';

class ExtensionHistoryResponse extends BaseResponse {
  int status;
  List<ExtensionHistoryModel> data;

  ExtensionHistoryResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<ExtensionHistoryModel>();
      json['Data'].forEach((v) {
        data.add(new ExtensionHistoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Messages'] = this.messages;
    return data;
  }
}

class ExtensionHistoryModel {
  int iD;
  String describe;
  String created;

  ExtensionHistoryModel({this.iD, this.describe, this.created});

  ExtensionHistoryModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    describe = json['Describe'];
    created = json['Created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Describe'] = this.describe;
    data['Created'] = this.created;
    return data;
  }
}
