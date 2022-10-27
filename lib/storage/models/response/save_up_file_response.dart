import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/models/storage_index_response.dart';
import 'package:workflow_manager/workflow/models/response/change_status_response.dart';

class SaveUpFileResponse extends BaseResponse {
  Data data;

  SaveUpFileResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = messages;
    }
    return data;
  }
}

class Data {
  List<DocChildItem> docChilds;

  Data({this.docChilds});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['DocChilds'] != null) {
      docChilds = new List<DocChildItem>();
      json['DocChilds'].forEach((v) {
        docChilds.add(new DocChildItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docChilds != null) {
      data['DocChilds'] = this.docChilds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
