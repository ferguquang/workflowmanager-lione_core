import 'package:workflow_manager/base/models/base_response.dart';

import 'detail_management_response.dart';

class ChangeFileResponse extends BaseResponse {
  DataChangeFile data;

  ChangeFileResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data =
        json['Data'] != null ? new DataChangeFile.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataChangeFile {
  Attachments attachment;

  DataChangeFile({this.attachment});

  DataChangeFile.fromJson(Map<String, dynamic> json) {
    attachment = json['Attachment'] != null
        ? new Attachments.fromJson(json['Attachment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attachment != null) {
      data['Attachment'] = this.attachment.toJson();
    }
    return data;
  }
}
