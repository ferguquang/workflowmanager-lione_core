import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';

class DataSignedPdfResponse extends BaseResponse {
  int status;
  DataSignedPdf data;

  DataSignedPdfResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data =
        json['Data'] != null ? new DataSignedPdf.fromJson(json['Data']) : null;
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

class DataSignedPdf {
  FileTemplate signFile;

  DataSignedPdf({this.signFile});

  DataSignedPdf.fromJson(Map<String, dynamic> json) {
    signFile = json['SignFile'] != null
        ? new FileTemplate.fromJson(json['SignFile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.signFile != null) {
      data['SignFile'] = this.signFile.toJson();
    }
    return data;
  }
}
