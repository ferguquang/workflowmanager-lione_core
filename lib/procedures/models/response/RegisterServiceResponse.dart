import 'package:workflow_manager/base/models/base_response.dart';

class RegisterServiceResponse extends BaseResponse {
  int status;
  RegisterServiceModel data;

  RegisterServiceResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new RegisterServiceModel.fromJson(json['Data'])
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

class RegisterServiceModel {
  int pageSize;
  int pageIndex;
  int pageTotal;
  List<RegisterServices> services;

  RegisterServiceModel({this.services});

  RegisterServiceModel.fromJson(Map<String, dynamic> json) {
    pageSize = json['PageSize'];
    pageIndex = json['PageIndex'];
    pageTotal = json['PageTotal'];
    if (json['Services'] != null) {
      services = new List<RegisterServices>();
      json['Services'].forEach((v) {
        services.add(new RegisterServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.services != null) {
      data['Services'] = this.services.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegisterServices {
  int iD;
  String name;
  String describe;
  String code;
  int iDType;
  String typeName;
  int created;
  bool isFeatured;
  String urlFlowChart;

  RegisterServices(
      {this.iD,
      this.name,
      this.describe,
      this.code,
      this.iDType,
      this.typeName,
      this.created,
      this.isFeatured,
      this.urlFlowChart});

  RegisterServices.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    code = json['Code'];
    iDType = json['IDType'];
    typeName = json['TypeName'];
    created = json['Created'];
    isFeatured = json['IsFeatured'];
    urlFlowChart = json['UrlFlowChart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Code'] = this.code;
    data['IDType'] = this.iDType;
    data['TypeName'] = this.typeName;
    data['Created'] = this.created;
    data['IsFeatured'] = this.isFeatured;
    data['UrlFlowChart'] = urlFlowChart;

    return data;
  }
}
