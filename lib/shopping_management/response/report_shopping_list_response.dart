import 'package:workflow_manager/base/models/base_response.dart';

class ReportShoppingListResponse extends BaseResponse {
  ReportShoppingListData data;

  ReportShoppingListResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new ReportShoppingListData.fromJson(json['Data']) : null;
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

class ReportShoppingListData {
  List<ReportTable> reportTable;

  ReportShoppingListData({this.reportTable});

  ReportShoppingListData.fromJson(Map<String, dynamic> json) {
    if (json['ReportTable'] != null) {
      reportTable = new List<ReportTable>();
      json['ReportTable'].forEach((v) {
        reportTable.add(new ReportTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reportTable != null) {
      data['ReportTable'] = this.reportTable.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportTable {
  int sTT;
  String projectCode;
  String investor;
  String categoryName;
  String actualAmount;

  ReportTable(
      {this.sTT,
        this.projectCode,
        this.investor,
        this.categoryName,
        this.actualAmount});

  ReportTable.fromJson(Map<String, dynamic> json) {
    sTT = json['STT'];
    projectCode = json['ProjectCode'];
    investor = json['Investor'];
    categoryName = json['CategoryName'];
    actualAmount = json['ActualAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STT'] = this.sTT;
    data['ProjectCode'] = this.projectCode;
    data['Investor'] = this.investor;
    data['CategoryName'] = this.categoryName;
    data['ActualAmount'] = this.actualAmount;
    return data;
  }
}

