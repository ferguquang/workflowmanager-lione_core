import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';

import 'file_response.dart';

class AddFileResponse extends BaseResponse{
  FileModel data;

  AddFileResponse.fromJson(Map<String, dynamic> json) :super.fromJson(json){
    status = json['Status'];
    data = json['Data'] != null ? new FileModel.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    data['Messages'] = this.messages;
    return data;
  }
}

class Data {
  int iD;
  int iDChannel;
  int iDJob;
  String name;
  String path;

  Data({this.iD, this.iDChannel, this.iDJob, this.name, this.path});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJob = json['IDJob'];
    name = json['Name'];
    path = json['Path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDJob'] = this.iDJob;
    data['Name'] = this.name;
    data['Path'] = this.path;
    return data;
  }
}
