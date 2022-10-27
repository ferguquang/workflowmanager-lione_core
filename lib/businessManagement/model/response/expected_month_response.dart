import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class ExpectedMonthResponse extends BaseResponse {
  DataExpectedMonth data;

  ExpectedMonthResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataExpectedMonth.fromJson(json['Data'])
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

class DataExpectedMonth {
  List<ProjectQuaterChartInfos> expectedYearBarChartInfos;
  SearchParam searchParam;

  DataExpectedMonth({this.expectedYearBarChartInfos, this.searchParam});

  DataExpectedMonth.fromJson(Map<String, dynamic> json) {
    if (json['ExpectedMonthBarChartInfos'] != null) {
      expectedYearBarChartInfos = new List<ProjectQuaterChartInfos>();
      json['ExpectedMonthBarChartInfos'].forEach((v) {
        expectedYearBarChartInfos.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.expectedYearBarChartInfos != null) {
      data['ExpectedMonthBarChartInfos'] =
          this.expectedYearBarChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}
