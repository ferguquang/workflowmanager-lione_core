import 'package:workflow_manager/base/models/base_response.dart';

import 'response_list_register.dart';

class ListReportStateResponse extends BaseResponse {
  Data data;

  ListReportStateResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
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

class Data {
  List<FilterStates> filterStates;
  List<TypeResolve> listTypeResolves;
  List<Services> services;
  List<FilterDept> listDepts;
  List<UserRegister> listUserRegisters;
  List<RecordReport> recordReports;
  int rowCount;
  int pageSize;
  int pageIndex;
  int pageTotal;

  Data(
      {this.filterStates,
        this.listTypeResolves,
        this.services,
        this.listDepts,
        this.listUserRegisters,
        this.recordReports,
        this.rowCount,
        this.pageSize,
        this.pageIndex,
        this.pageTotal});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['FilterStatusRecords'] != null) {
      filterStates = new List<FilterStates>();
      json['FilterStatusRecords'].forEach((v) {
        filterStates.add(new FilterStates.fromJson(v));
      });
    }
    if (json['Categories'] != null) {
      listTypeResolves = new List<TypeResolve>();
      json['Categories'].forEach((v) {
        listTypeResolves.add(new TypeResolve.fromJson(v));
      });
    }
    if (json['Services'] != null) {
      services = new List<Services>();
      json['Services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    if (json['Dept'] != null) {
      listDepts = new List<FilterDept>();
      json['Dept'].forEach((v) {
        listDepts.add(new FilterDept.fromJson(v));
      });
    }
    if (json['User'] != null) {
      listUserRegisters = new List<UserRegister>();
      json['User'].forEach((v) {
        listUserRegisters.add(new UserRegister.fromJson(v));
      });
    }
    if (json['RecordReports'] != null) {
      recordReports = new List<RecordReport>();
      json['RecordReports'].forEach((v) {
        recordReports.add(new RecordReport.fromJson(v));
      });
    }
    rowCount = json['RowCount'];
    pageSize = json['PageSize'];
    pageIndex = json['PageIndex'];
    pageTotal = json['PageTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filterStates != null) {
      data['FilterStatusRecords'] =
          this.filterStates.map((v) => v.toJson()).toList();
    }
    if (this.listTypeResolves != null) {
      data['Categories'] = this.listTypeResolves.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['Services'] = this.services.map((v) => v.toJson()).toList();
    }
    if (this.listDepts != null) {
      data['Dept'] = this.listDepts.map((v) => v.toJson()).toList();
    }
    if (this.listUserRegisters != null) {
      data['User'] = this.listUserRegisters.map((v) => v.toJson()).toList();
    }
    if (this.recordReports != null) {
      data['RecordReports'] =
          this.recordReports.map((v) => v.toJson()).toList();
    }
    data['RowCount'] = this.rowCount;
    data['PageSize'] = this.pageSize;
    data['PageIndex'] = this.pageIndex;
    data['PageTotal'] = this.pageTotal;
    return data;
  }
}

class RecordReport {
  int stt;
  String registerName;
  String serviceRecordName;
  String stepName;
  String solverName;
  String progressTime;

  RecordReport(
      {this.stt,
        this.registerName,
        this.serviceRecordName,
        this.stepName,
        this.solverName,
        this.progressTime});

  RecordReport.fromJson(Map<String, dynamic> json) {
    stt = json['Stt'];
    registerName = json['RegisterName'];
    serviceRecordName = json['ServiceRecordName'];
    stepName = json['StepName'];
    solverName = json['SolverName'];
    progressTime = json['ProgressTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Stt'] = this.stt;
    data['RegisterName'] = this.registerName;
    data['ServiceRecordName'] = this.serviceRecordName;
    data['StepName'] = this.stepName;
    data['SolverName'] = this.solverName;
    data['ProgressTime'] = this.progressTime;
    return data;
  }
}
