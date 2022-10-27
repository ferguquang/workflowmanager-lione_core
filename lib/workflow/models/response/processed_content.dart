import 'package:workflow_manager/workflow/models/message.dart';
import 'package:workflow_manager/base/models/base_response.dart';

class ResponseProcessedContent extends BaseResponse {
  int status;
  List<ProcessedContent> data;

  ResponseProcessedContent.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<ProcessedContent>();
      json['Data'].forEach((v) {
        data.add(new ProcessedContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class ProcessedContent {
  int iD;
  int iDJob;
  String describe;
  String created;
  String processTime;

  ProcessedContent({this.iD, this.iDJob, this.describe, this.created, this.processTime});

  ProcessedContent.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDJob = json['IDJob'];
    describe = json['Describe'];
    created = json['Created'];
    processTime = json['ProcessTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDJob'] = this.iDJob;
    data['Describe'] = this.describe;
    data['Created'] = this.created;
    data['ProcessTime'] = this.processTime;
    return data;
  }
}

// edit-add process content
class ResponseAddEditProcessContent extends BaseResponse {
  int status;
  ProcessedContent data;

  ResponseAddEditProcessContent.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new ProcessedContent.fromJson(json['Data']) : null;
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
