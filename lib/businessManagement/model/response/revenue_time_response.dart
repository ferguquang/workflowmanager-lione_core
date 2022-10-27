import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

class RevenueTimeResponse extends BaseResponse {
  DataRevenueTime data;

  RevenueTimeResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataRevenueTime.fromJson(json['Data'])
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

class DataRevenueTime {
  List<TimeReport> timeReport;
  SearchParam searchParam;
  List<ColorNotes> colorNotes;

  DataRevenueTime({this.timeReport, this.searchParam, this.colorNotes});

  DataRevenueTime.fromJson(Map<String, dynamic> json) {
    if (json['TimeReport'] != null) {
      timeReport = new List<TimeReport>();
      json['TimeReport'].forEach((v) {
        timeReport.add(new TimeReport.fromJson(v));
      });
    }
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
    if (json['ColorNotes'] != null) {
      colorNotes = new List<ColorNotes>();
      json['ColorNotes'].forEach((v) {
        colorNotes.add(new ColorNotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timeReport != null) {
      data['TimeReport'] = this.timeReport.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    if (this.colorNotes != null) {
      data['ColorNotes'] = this.colorNotes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeReport {
  String label;
  List<ProjectQuaterChartInfos> times;

  TimeReport({this.label, this.times});

  TimeReport.fromJson(Map<String, dynamic> json) {
    label = json['Label'];
    if (json['Times'] != null) {
      times = new List<ProjectQuaterChartInfos>();
      json['Times'].forEach((v) {
        times.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Label'] = this.label;
    if (this.times != null) {
      data['Times'] = this.times.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
