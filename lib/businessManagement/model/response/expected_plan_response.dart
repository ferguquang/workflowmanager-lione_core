import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class ExpectedPlanResponse extends BaseResponse {
  DataExpectedPlan data;

  ExpectedPlanResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataExpectedPlan.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataExpectedPlan {
  List<ExpectedProjectPlans> projectPlans;
  SearchParam searchParam;

  DataExpectedPlan({this.projectPlans, this.searchParam});

  DataExpectedPlan.fromJson(Map<String, dynamic> json) {
    if (json['ProjectPlans'] != null) {
      projectPlans = new List<ExpectedProjectPlans>();
      json['ProjectPlans'].forEach((v) {
        projectPlans.add(new ExpectedProjectPlans.fromJson(v));
      });
    }
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projectPlans != null) {
      data['ProjectPlans'] = this.projectPlans.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class ExpectedProjectPlans {
  int iD;
  String code;
  String name;
  String statusName;
  String statusColor;
  int startDate;
  int quater;
  String totalMoney;
  Seller seller;

  ExpectedProjectPlans(
      {this.iD,
      this.code,
      this.name,
      this.statusName,
      this.statusColor,
      this.startDate,
      this.quater,
      this.totalMoney,
      this.seller});

  ExpectedProjectPlans.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    statusName = json['StatusName'];
    statusColor = json['StatusColor'];
    startDate = json['StartDate'];
    quater = json['Quater'];
    totalMoney = json['TotalMoney'];
    seller =
        json['Seller'] != null ? new Seller.fromJson(json['Seller']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['StatusName'] = this.statusName;
    data['StatusColor'] = this.statusColor;
    data['StartDate'] = this.startDate;
    data['Quater'] = this.quater;
    data['TotalMoney'] = this.totalMoney;
    if (this.seller != null) {
      data['Seller'] = this.seller.toJson();
    }
    return data;
  }
}
