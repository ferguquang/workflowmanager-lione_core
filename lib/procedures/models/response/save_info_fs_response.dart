import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';

class SaveInfoFsResponse extends BaseResponse {
  DataAllAttachFiles data;

  SaveInfoFsResponse.fromJson(Map<String, dynamic> json)  : super.fromJson(json) {
    data = json['Data'] != null ? new DataAllAttachFiles.fromJson(json['Data']) : null;
  }
}

class DataAllAttachFiles {
  List<AllAttachedFiles> allAttachedFiles;

  DataAllAttachFiles({this.allAttachedFiles});

  DataAllAttachFiles.fromJson(Map<String, dynamic> json) {
    if (json['AllAttachedFiles'] != null) {
      allAttachedFiles = new List<AllAttachedFiles>();
      json['AllAttachedFiles'].forEach((v) {
        allAttachedFiles.add(new AllAttachedFiles.fromJson(v));
      });
    }
  }
}