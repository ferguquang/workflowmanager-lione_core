import 'package:workflow_manager/base/models/base_response.dart';

class ManufacturReportResponse extends BaseResponse {
  int status;
  ManufacturReportModel data;

  ManufacturReportResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new ManufacturReportModel.fromJson(json['Data'])
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

class ManufacturReportModel {
  List<Report> report;
  int totalRecord;
  List<Manufacturs> manufacturs;

  ManufacturReportModel({this.report, this.totalRecord, this.manufacturs});

  ManufacturReportModel.fromJson(Map<String, dynamic> json) {
    if (json['Report'] != null) {
      report = new List<Report>();
      json['Report'].forEach((v) {
        report.add(new Report.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
    if (json['Manufacturs'] != null) {
      manufacturs = new List<Manufacturs>();
      json['Manufacturs'].forEach((v) {
        manufacturs.add(new Manufacturs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['Report'] = this.report.map((v) => v.toJson()).toList();
    }
    data['TotalRecord'] = this.totalRecord;
    if (this.manufacturs != null) {
      data['Manufacturs'] = this.manufacturs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Report {
  String manufactur;
  String total;

  Report({this.manufactur, this.total});

  Report.fromJson(Map<String, dynamic> json) {
    manufactur = json['Manufactur'];
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Manufactur'] = this.manufactur;
    data['Total'] = this.total;
    return data;
  }
}

class Manufacturs {
  int iD;
  String name;
  String key;
  bool isEnable;

  Manufacturs({this.iD, this.name, this.key, this.isEnable});

  Manufacturs.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}
