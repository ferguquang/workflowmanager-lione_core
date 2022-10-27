import 'package:workflow_manager/base/models/base_response.dart';

class GetPdfPathResponse extends BaseResponse {
  int status;
  GetPdfPathModel data;

  GetPdfPathResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new GetPdfPathModel.fromJson(json['Data'])
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

class GetPdfPathModel {
  List<Files> files;

  GetPdfPathModel({this.files});

  GetPdfPathModel.fromJson(Map<String, dynamic> json) {
    if (json['Files'] != null) {
      files = new List<Files>();
      json['Files'].forEach((v) {
        files.add(new Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.files != null) {
      data['Files'] = this.files.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  String filePath;
  String filePathChange;
  String content;

  Files({this.filePath, this.filePathChange});

  Files.fromJson(Map<String, dynamic> json) {
    filePath = json['FilePath'];
    filePathChange = json['FilePathChange'];
    content = json['Content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FilePath'] = this.filePath;
    data['FilePathChange'] = this.filePathChange;
    data['Content'] = content;
    return data;
  }
}
