import 'package:workflow_manager/base/models/base_response.dart';

class ReportProcedureResponse extends BaseResponse {
  ReportProcedureData data;

  ReportProcedureResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new ReportProcedureData.fromJson(json['Data']) : null;
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

class ReportProcedureData {
  int typeWfTotal;
  int workflowTotal;
  List<WfReport> wfReport;
  List<WfServiceTypeRecords> wfServiceTypeRecords;
  int totalPending;
  int recordTotalProcessing;
  int recordTotalProcessed;
  int recordTotalRejected;
  int recordTotalCanceled;
  int typeCount;
  List<ServiceReport> serviceReport;
  List<Types> types;
  int recordTotal;
  List<RecordReport> recordReport;

  ReportProcedureData(
      {this.typeWfTotal,
        this.workflowTotal,
        this.wfReport,
        this.wfServiceTypeRecords,
        this.totalPending,
        this.recordTotalProcessing,
        this.recordTotalProcessed,
        this.recordTotalRejected,
        this.recordTotalCanceled,
        this.typeCount,
        this.serviceReport,
        this.types,
        this.recordTotal,
        this.recordReport});

  ReportProcedureData.fromJson(Map<String, dynamic> json) {
    typeWfTotal = json['TypeWfTotal'];
    workflowTotal = json['WorkflowTotal'];
    if (json['WfReport'] != null) {
      wfReport = new List<WfReport>();
      json['WfReport'].forEach((v) {
        wfReport.add(new WfReport.fromJson(v));
      });
    }
    if (json['WfServiceTypeRecords'] != null) {
      wfServiceTypeRecords = new List<WfServiceTypeRecords>();
      json['WfServiceTypeRecords'].forEach((v) {
        wfServiceTypeRecords.add(new WfServiceTypeRecords.fromJson(v));
      });
    }
    totalPending = json['TotalPending'];
    recordTotalProcessing = json['RecordTotalProcessing'];
    recordTotalProcessed = json['RecordTotalProcessed'];
    recordTotalRejected = json['RecordTotalRejected'];
    recordTotalCanceled = json['RecordTotalCanceled'];
    typeCount = json['TypeCount'];
    if (json['ServiceReport'] != null) {
      serviceReport = new List<ServiceReport>();
      json['ServiceReport'].forEach((v) {
        serviceReport.add(new ServiceReport.fromJson(v));
      });
    }
    if (json['Types'] != null) {
      types = new List<Types>();
      json['Types'].forEach((v) {
        types.add(new Types.fromJson(v));
      });
    }
    recordTotal = json['RecordTotal'];
    if (json['RecordReport'] != null) {
      recordReport = new List<RecordReport>();
      json['RecordReport'].forEach((v) {
        recordReport.add(new RecordReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TypeWfTotal'] = this.typeWfTotal;
    data['WorkflowTotal'] = this.workflowTotal;
    if (this.wfReport != null) {
      data['WfReport'] = this.wfReport.map((v) => v.toJson()).toList();
    }
    if (this.wfServiceTypeRecords != null) {
      data['WfServiceTypeRecords'] =
          this.wfServiceTypeRecords.map((v) => v.toJson()).toList();
    }
    data['TotalPending'] = this.totalPending;
    data['RecordTotalProcessing'] = this.recordTotalProcessing;
    data['RecordTotalProcessed'] = this.recordTotalProcessed;
    data['RecordTotalRejected'] = this.recordTotalRejected;
    data['RecordTotalCanceled'] = this.recordTotalCanceled;
    data['TypeCount'] = this.typeCount;
    if (this.serviceReport != null) {
      data['ServiceReport'] =
          this.serviceReport.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['Types'] = this.types.map((v) => v.toJson()).toList();
    }
    data['RecordTotal'] = this.recordTotal;
    if (this.recordReport != null) {
      data['RecordReport'] = this.recordReport.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WfReport {
  int iD;
  String name;
  String describe;
  String icon;
  int total;
  String color;

  WfReport(
      {this.iD, this.name, this.describe, this.icon, this.total, this.color});

  WfReport.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    icon = json['Icon'];
    total = json['Total'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Icon'] = this.icon;
    data['Total'] = this.total;
    data['Color'] = this.color;
    return data;
  }
}

class WfServiceTypeRecords {
  int iD;
  String name;
  String describe;
  String icon;
  int pending;
  int processing;
  int processed;
  int rejected;
  int canceled;

  WfServiceTypeRecords(
      {this.iD,
        this.name,
        this.describe,
        this.icon,
        this.pending,
        this.processing,
        this.processed,
        this.rejected,
        this.canceled});

  WfServiceTypeRecords.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    icon = json['Icon'];
    pending = json['Pending'];
    processing = json['Processing'];
    processed = json['Processed'];
    rejected = json['Rejected'];
    canceled = json['Canceled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Icon'] = this.icon;
    data['Pending'] = this.pending;
    data['Processing'] = this.processing;
    data['Processed'] = this.processed;
    data['Rejected'] = this.rejected;
    data['Canceled'] = this.canceled;
    return data;
  }
}

class ServiceReport {
  int iD;
  String name;
  String code;
  int totalRecord;
  int totalPending;
  int totalProcessing;
  int totalProcessed;
  int totalRejected;
  int totalCanceled;

  ServiceReport(
      {this.iD,
        this.name,
        this.code,
        this.totalRecord,
        this.totalPending,
        this.totalProcessing,
        this.totalProcessed,
        this.totalRejected,
        this.totalCanceled});

  ServiceReport.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    code = json['Code'];
    totalRecord = json['TotalRecord'];
    totalPending = json['TotalPending'];
    totalProcessing = json['TotalProcessing'];
    totalProcessed = json['TotalProcessed'];
    totalRejected = json['TotalRejected'];
    totalCanceled = json['TotalCanceled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Code'] = this.code;
    data['TotalRecord'] = this.totalRecord;
    data['TotalPending'] = this.totalPending;
    data['TotalProcessing'] = this.totalProcessing;
    data['TotalProcessed'] = this.totalProcessed;
    data['TotalRejected'] = this.totalRejected;
    data['TotalCanceled'] = this.totalCanceled;
    return data;
  }
}

class Types {
  int iD;
  String name;
  String describe;
  String icon;
  int totalDone;
  int total;

  Types(
      {this.iD,
        this.name,
        this.describe,
        this.icon,
        this.totalDone,
        this.total});

  Types.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    icon = json['Icon'];
    totalDone = json['TotalDone'];
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Icon'] = this.icon;
    data['TotalDone'] = this.totalDone;
    data['Total'] = this.total;
    return data;
  }
}

class RecordReport {
  String name;
  int number;
  String color;

  RecordReport({this.name, this.number, this.color});

  RecordReport.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    number = json['Number'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Number'] = this.number;
    data['Color'] = this.color;
    return data;
  }
}

