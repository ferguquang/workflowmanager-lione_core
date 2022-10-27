import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class ExpectedYearResponse extends BaseResponse {
  DataExpectedYear data;

  ExpectedYearResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataExpectedYear.fromJson(json['Data'])
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

class DataExpectedYear {
  List<ProjectQuaterChartInfos> expectedYearBarChartInfos;
  SearchParam searchParam;

  DataExpectedYear({this.expectedYearBarChartInfos, this.searchParam});

  DataExpectedYear.fromJson(Map<String, dynamic> json) {
    if (json['ExpectedYearBarChartInfos'] != null) {
      expectedYearBarChartInfos = new List<ProjectQuaterChartInfos>();
      json['ExpectedYearBarChartInfos'].forEach((v) {
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
      data['ExpectedYearBarChartInfos'] =
          this.expectedYearBarChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}
