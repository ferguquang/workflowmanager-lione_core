import 'package:workflow_manager/base/models/base_response.dart';

import 'data_signature_list_response.dart';

class DoneInfoResponse extends BaseResponse {
  DataDoneInfo data;

  DoneInfoResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data =
        json['Data'] != null ? new DataDoneInfo.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataDoneInfo {
  bool isSigned;
  var iDGroup;
  ServiceInfoFile serviceInfoFile;
  List<Signatures> userSignatures;
  var iDServiceRecordTemplateExport;

  DataDoneInfo({this.isSigned, this.serviceInfoFile, this.userSignatures});

  DataDoneInfo.fromJson(Map<String, dynamic> json) {
    isSigned = json['IsSigned'];
    iDGroup = json['IDGroup'];
    iDServiceRecordTemplateExport = json['IDServiceTemplateExport'];
    serviceInfoFile = json['ServiceInfoFile'] != null
        ? new ServiceInfoFile.fromJson(json['ServiceInfoFile'])
        : null;
    if (json['UserSignatures'] != null) {
      userSignatures = [];
      json['UserSignatures'].forEach((v) {
        userSignatures.add(new Signatures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSigned'] = this.isSigned;
    data['IDGroup'] = this.iDGroup;
    data['IDServiceTemplateExport'] = this.iDServiceRecordTemplateExport;
    if (this.serviceInfoFile != null) {
      data['ServiceInfoFile'] = this.serviceInfoFile.toJson();
    }
    if (this.userSignatures != null) {
      data['UserSignatures'] =
          this.userSignatures.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceInfoFile {
  String path;
  String name;
  String extension;

  ServiceInfoFile({this.path, this.name, this.extension});

  ServiceInfoFile.fromJson(Map<String, dynamic> json) {
    path = json['Path'];
    name = json['Name'];
    extension = json['Extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Path'] = this.path;
    data['Name'] = this.name;
    data['Extension'] = this.extension;
    return data;
  }
}
