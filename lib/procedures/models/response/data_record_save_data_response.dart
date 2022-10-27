import 'package:workflow_manager/base/models/base_response.dart';

import 'single_field.dart';

class DataRecordSaveDataResponse extends BaseResponse {
  int status;
  DataRecordSaveData data;

  DataRecordSaveDataResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataRecordSaveData.fromJson(json['Data'])
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
class DataRecordSaveData {
  int iDServiceRecord;
  int iDServiceRecordWfStep;
  int iDServiceRecordData;
  List<Field> singleFields;
  List<Field> tableFields;

  DataRecordSaveData.fromJson(Map<String, dynamic> json) {
    iDServiceRecord = json['IDServiceRecord'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
    iDServiceRecordData = json['IDServiceRecordData'];
    if (json['SingleFields'] != null) {
      singleFields = new List<Field>();
      json['SingleFields'].forEach((v) {
        singleFields.add(new Field.fromJson(v));
      });
    }
    if (json['TableFields'] != null) {
      tableFields = new List<Field>();
      json['TableFields'].forEach((v) {
        tableFields.add(new Field.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['IDServiceRecord'] = iDServiceRecord;
    json['IDServiceRecordWfStep'] = iDServiceRecordWfStep;
    json['IDServiceRecordData'] = iDServiceRecordData;
    if (this.singleFields != null) {
      json['SingleFields'] = this.singleFields.map((v) => v.toJson()).toList();
    }
    if (this.tableFields != null) {
      json['TableFields'] = this.tableFields.map((v) => v.toJson()).toList();
    }
    return json;
  }
}
