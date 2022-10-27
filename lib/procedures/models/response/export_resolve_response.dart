import 'package:workflow_manager/base/models/base_response.dart';

class ExportResolveResponse extends BaseResponse {

  ExportResolveData data;

  ExportResolveResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new ExportResolveData.fromJson(json['Data']) : null;
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

class ExportResolveData {
  String fileName;
  String path;

  ExportResolveData({this.fileName, this.path});

  ExportResolveData.fromJson(Map<String, dynamic> json) {
    fileName = json['FileName'];
    path = json['Path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileName'] = this.fileName;
    data['Path'] = this.path;
    return data;
  }
}

class Messages {
  int code;
  String text;

  Messages({this.code, this.text});

  Messages.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['text'] = this.text;
    return data;
  }
}
