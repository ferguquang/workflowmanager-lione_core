import 'package:workflow_manager/base/models/base_response.dart';

import 'detail_management_response.dart';

class SaveAttachResponse extends BaseResponse {
  DataSaveAttach data;

  SaveAttachResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data =
        json['Data'] != null ? new DataSaveAttach.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataSaveAttach {
  Attachments attachment;

  DataSaveAttach({this.attachment});

  DataSaveAttach.fromJson(Map<String, dynamic> json) {
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
