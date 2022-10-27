import 'package:workflow_manager/base/models/base_response.dart';

class ManagerSerialListResponse extends BaseResponse {
  int status;
  ManagerSerialListModel data;

  ManagerSerialListResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new ManagerSerialListModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class ManagerSerialListModel {
  List<Serials> serials;
  bool isCreate;
  int totalRecord;

  ManagerSerialListModel({this.serials, this.isCreate, this.totalRecord});

  ManagerSerialListModel.fromJson(Map<String, dynamic> json) {
    if (json['Serials'] != null) {
      serials = new List<Serials>();
      json['Serials'].forEach((v) {
        serials.add(new Serials.fromJson(v));
      });
    }
    isCreate = json['IsCreate'];
    totalRecord = json['TotalRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.serials != null) {
      data['Serials'] = this.serials.map((v) => v.toJson()).toList();
    }
    data['IsCreate'] = this.isCreate;
    data['TotalRecord'] = this.totalRecord;
    return data;
  }
}

class Serials {
  int iD;
  String project;
  String requisitionNumber;
  String pONumber;
  String cOName;
  String cQName;
  String otherFile;
  bool isView;
  bool isUpdate;
  bool isDelete;

  Serials(
      {this.iD,
      this.project,
      this.requisitionNumber,
      this.pONumber,
      this.cOName,
      this.cQName,
      this.otherFile,
      this.isView,
      this.isUpdate,
      this.isDelete});

  Serials.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    project = json['Project'];
    requisitionNumber = json['RequisitionNumber'];
    pONumber = json['PONumber'];
    cOName = json['COName'];
    cQName = json['CQName'];
    otherFile = json['OtherFile'];
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Project'] = this.project;
    data['RequisitionNumber'] = this.requisitionNumber;
    data['PONumber'] = this.pONumber;
    data['COName'] = this.cOName;
    data['CQName'] = this.cQName;
    data['OtherFile'] = this.otherFile;
    data['IsView'] = this.isView;
    data['IsUpdate'] = this.isUpdate;
    data['IsDelete'] = this.isDelete;
    return data;
  }
}
