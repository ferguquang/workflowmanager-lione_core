import 'package:workflow_manager/base/models/base_response.dart';

import 'detail_management_response.dart';

class ImportFileResponse extends BaseResponse {
  DataImportFile data;

  ImportFileResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data =
        json['Data'] != null ? new DataImportFile.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataImportFile {
  List<Attachments> attachments;

  DataImportFile({this.attachments});

  DataImportFile.fromJson(Map<String, dynamic> json) {
    if (json['Attachments'] != null) {
      attachments = new List<Attachments>();
      json['Attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attachments != null) {
      data['Attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
