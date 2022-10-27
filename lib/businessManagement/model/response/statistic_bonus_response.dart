import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class StatisticBonusResponse extends BaseResponse {
  DataStatisticBonus data;

  StatisticBonusResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataStatisticBonus.fromJson(json['Data'])
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

class DataStatisticBonus {
  List<ProjectQuaterChartInfos> bonusPBBarChartInfos;
  SearchParam searchParam;

  DataStatisticBonus({this.bonusPBBarChartInfos, this.searchParam});

  DataStatisticBonus.fromJson(Map<String, dynamic> json) {
    if (json['BonusPBBarChartInfos'] != null) {
      bonusPBBarChartInfos = new List<ProjectQuaterChartInfos>();
      json['BonusPBBarChartInfos'].forEach((v) {
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
      data['BonusPBBarChartInfos'] =
          this.bonusPBBarChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}
