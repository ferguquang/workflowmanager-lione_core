import 'package:workflow_manager/base/models/base_response.dart';

class ProgressReportResponse extends BaseResponse {
  int status;
  ProgressReportModel data;

  ProgressReportResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new ProgressReportModel.fromJson(json['Data'])
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

class ProgressReportModel {
  List<Report> report;
  int totalRecord;
  SearchParam searchParam;

  ProgressReportModel({this.report, this.totalRecord, this.searchParam});

  ProgressReportModel.fromJson(Map<String, dynamic> json) {
    if (json['Report'] != null) {
      report = new List<Report>();
      json['Report'].forEach((v) {
        report.add(new Report.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['Report'] = this.report.map((v) => v.toJson()).toList();
    }
    data['TotalRecord'] = this.totalRecord;
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class Report {
  String project;
  String requisition;
  String contract;
  String investor;
  String totalAmount;
  String cham;
  String dangVe;
  String dungTienDo;
  String vuotTienDo;

  Report(
      {this.project,
      this.requisition,
      this.contract,
      this.investor,
      this.totalAmount,
      this.cham,
      this.dangVe,
      this.dungTienDo,
      this.vuotTienDo});

  Report.fromJson(Map<String, dynamic> json) {
    project = json['Project'];
    requisition = json['Requisition'];
    contract = json['Contract'];
    investor = json['Investor'];
    totalAmount = json['TotalAmount'];
    cham = json['Cham'];
    dangVe = json['DangVe'];
    dungTienDo = json['DungTienDo'];
    vuotTienDo = json['VuotTienDo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Project'] = this.project;
    data['Requisition'] = this.requisition;
    data['Contract'] = this.contract;
    data['Investor'] = this.investor;
    data['TotalAmount'] = this.totalAmount;
    data['Cham'] = this.cham;
    data['DangVe'] = this.dangVe;
    data['DungTienDo'] = this.dungTienDo;
    data['VuotTienDo'] = this.vuotTienDo;
    return data;
  }
}

class SearchParam {
  List<SearchObject> projects;
  List<SearchObject> requisitions;
  List<SearchObject> contracts;

  SearchParam({this.projects, this.requisitions, this.contracts});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Projects'] != null) {
      projects = new List<SearchObject>();
      json['Projects'].forEach((v) {
        projects.add(new SearchObject.fromJson(v));
      });
    }
    if (json['Requisitions'] != null) {
      requisitions = new List<SearchObject>();
      json['Requisitions'].forEach((v) {
        requisitions.add(new SearchObject.fromJson(v));
      });
    }
    if (json['Contracts'] != null) {
      contracts = new List<SearchObject>();
      json['Contracts'].forEach((v) {
        contracts.add(new SearchObject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projects != null) {
      data['Projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    if (this.requisitions != null) {
      data['Requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    if (this.contracts != null) {
      data['Contracts'] = this.contracts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchObject {
  int iD;
  String name;
  String key;
  bool isEnable;

  SearchObject({this.iD, this.name, this.key, this.isEnable});

  SearchObject.fromJson(Map<String, dynamic> json) {
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
