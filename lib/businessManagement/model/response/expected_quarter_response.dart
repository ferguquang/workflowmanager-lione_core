import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class ExpectedQuarterResponse extends BaseResponse {
  DataExpectedQuarter data;

  ExpectedQuarterResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataExpectedQuarter.fromJson(json['Data'])
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

class DataExpectedQuarter {
  List<ProjectQuaterChartInfos> expectedYearBarChartInfos;
  SearchParam searchParam;

  DataExpectedQuarter({this.expectedYearBarChartInfos, this.searchParam});

  DataExpectedQuarter.fromJson(Map<String, dynamic> json) {
    if (json['ExpectedQuarterBarChartInfos'] != null) {
      expectedYearBarChartInfos = new List<ProjectQuaterChartInfos>();
      json['ExpectedQuarterBarChartInfos'].forEach((v) {
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
      data['ExpectedQuarterBarChartInfos'] =
          this.expectedYearBarChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}
