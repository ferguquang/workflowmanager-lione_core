import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

class StatisticsDetailResponse extends BaseResponse {
  DataStatisticDetail data;

  StatisticsDetailResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataStatisticDetail.fromJson(json['Data'])
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

class DataStatisticDetail {
  List<ProjectPlans> projectPlans;
  SearchParam searchParam;

  DataStatisticDetail({this.projectPlans, this.searchParam});

  DataStatisticDetail.fromJson(Map<String, dynamic> json) {
    if (json['ProjectPlans'] != null) {
      projectPlans = new List<ProjectPlans>();
      json['ProjectPlans'].forEach((v) {
        projectPlans.add(new ProjectPlans.fromJson(v));
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

class ProjectPlans {
  String name;
  String iD;
  List<SeriesDept> series;
  List<Cate> cate;

  ProjectPlans({this.name, this.iD, this.series, this.cate});

  ProjectPlans.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    iD = json['ID'];
    if (json['Series'] != null) {
      series = new List<SeriesDept>();
      json['Series'].forEach((v) {
        series.add(new SeriesDept.fromJson(v));
      });
    }
    if (json['Cate'] != null) {
      cate = new List<Cate>();
      json['Cate'].forEach((v) {
        cate.add(new Cate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ID'] = this.iD;
    if (this.series != null) {
      data['Series'] = this.series.map((v) => v.toJson()).toList();
    }
    if (this.cate != null) {
      data['Cate'] = this.cate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeriesDept {
  String name;
  int iD;
  double data;
  String color;
  bool isHeader = false;
  String year;
  String idYear;

  SeriesDept(
      {this.name,
      this.iD,
      this.data,
      this.color,
      this.isHeader,
      this.year,
      this.idYear});

  SeriesDept.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    iD = json['ID'];
    data = json['Data'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ID'] = this.iD;
    data['Data'] = this.data;
    data['Color'] = this.color;
    return data;
  }
}

class Cate {
  String name;
  String iD;
  List<SeriesDept> series;

  Cate({this.name, this.iD, this.series});

  Cate.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    iD = json['ID'];
    if (json['Series'] != null) {
      series = new List<SeriesDept>();
      json['Series'].forEach((v) {
        series.add(new SeriesDept.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ID'] = this.iD;
    if (this.series != null) {
      data['Series'] = this.series.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
