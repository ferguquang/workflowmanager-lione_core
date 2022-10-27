import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class BonusBranchResponse extends BaseResponse {
  DataBonusBranch data;

  BonusBranchResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataBonusBranch.fromJson(json['Data'])
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

class DataBonusBranch {
  List<ProjectQuaterChartInfos> bonusPBBarChartInfos;
  SearchParam searchParam;

  DataBonusBranch({this.bonusPBBarChartInfos, this.searchParam});

  DataBonusBranch.fromJson(Map<String, dynamic> json) {
    if (json['BonusCNBarChartInfos'] != null) {
      bonusPBBarChartInfos = new List<ProjectQuaterChartInfos>();
      json['BonusCNBarChartInfos'].forEach((v) {
        bonusPBBarChartInfos.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bonusPBBarChartInfos != null) {
      data['BonusCNBarChartInfos'] =
          this.bonusPBBarChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}
