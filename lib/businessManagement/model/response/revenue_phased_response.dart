import 'package:workflow_manager/base/models/base_response.dart';

import 'over_view_response.dart';

class RevenuePhasedResponse extends BaseResponse {
  DataRevenuePhased data;

  RevenuePhasedResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataRevenuePhased.fromJson(json['Data'])
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

class DataRevenuePhased {
  List<PhaseTypeCharts> phaseTypeCharts;
  SearchParam searchParam;
  List<ColorNotes> colorNotes;

  DataRevenuePhased({this.phaseTypeCharts, this.searchParam, this.colorNotes});

  DataRevenuePhased.fromJson(Map<String, dynamic> json) {
    if (json['PhaseTypeCharts'] != null) {
      phaseTypeCharts = new List<PhaseTypeCharts>();
      json['PhaseTypeCharts'].forEach((v) {
        phaseTypeCharts.add(new PhaseTypeCharts.fromJson(v));
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
    if (this.phaseTypeCharts != null) {
      data['PhaseTypeCharts'] =
          this.phaseTypeCharts.map((v) => v.toJson()).toList();
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

class PhaseTypeCharts {
  int iD;
  String name;
  List<ProjectQuaterChartInfos> phaseReport;

  PhaseTypeCharts({this.iD, this.name, this.phaseReport});

  PhaseTypeCharts.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    if (json['PhaseReport'] != null) {
      phaseReport = new List<ProjectQuaterChartInfos>();
      json['PhaseReport'].forEach((v) {
        phaseReport.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    if (this.phaseReport != null) {
      data['PhaseReport'] = this.phaseReport.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
