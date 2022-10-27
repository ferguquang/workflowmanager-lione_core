import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/message.dart';

class StatisticDocBorrowResponse extends BaseResponse {
  DataStatisticBorrow data;

  // StatisticDocBorrowModel({this.status, this.data, this.messages});


  StatisticDocBorrowResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new DataStatisticBorrow.fromJson(json['Data']) : null;

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

class DataStatisticBorrow {
  List<ReportPurposes> reportPurposes;
  List<ReportAmounts> reportAmounts;
  List<ReportPurposes> reportStatus;

  DataStatisticBorrow({this.reportPurposes, this.reportAmounts, this.reportStatus});

  DataStatisticBorrow.fromJson(Map<String, dynamic> json) {
    if (json['ReportPurposes'] != null) {
      reportPurposes = new List<ReportPurposes>();
      json['ReportPurposes'].forEach((v) {
        reportPurposes.add(new ReportPurposes.fromJson(v));
      });
    }
    if (json['ReportAmounts'] != null) {
      reportAmounts = new List<ReportAmounts>();
      json['ReportAmounts'].forEach((v) {
        reportAmounts.add(new ReportAmounts.fromJson(v));
      });
    }
    if (json['ReportStatus'] != null) {
      reportStatus = new List<ReportPurposes>();
      json['ReportStatus'].forEach((v) {
        reportStatus.add(new ReportPurposes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reportPurposes != null) {
      data['ReportPurposes'] =
          this.reportPurposes.map((v) => v.toJson()).toList();
    }
    if (this.reportAmounts != null) {
      data['ReportAmounts'] =
          this.reportAmounts.map((v) => v.toJson()).toList();
    }
    if (this.reportStatus != null) {
      data['ReportStatus'] = this.reportStatus.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportPurposes {
  String title;
  String color;
  int total;

  ReportPurposes({this.title, this.color, this.total});

  ReportPurposes.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    color = json['Color'];
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Color'] = this.color;
    data['Total'] = this.total;
    return data;
  }
}

class ReportAmounts {
  String title;
  int totalUser;
  int total;

  ReportAmounts({this.title, this.totalUser, this.total});

  ReportAmounts.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    totalUser = json['TotalUser'];
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['TotalUser'] = this.totalUser;
    data['Total'] = this.total;
    return data;
  }
}
