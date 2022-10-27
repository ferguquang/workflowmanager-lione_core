import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/select_model.dart';

class ReportShoppingDashBoardResponse extends BaseResponse {
  ReportShoppingDashBoardData data;

  ReportShoppingDashBoardResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new ReportShoppingDashBoardData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class ReportShoppingDashBoardData {
  List<ProgressChart> progressCharts;
  List<InternalChart> internalCharts;
  List<ProjectChart> projectCharts;
  SearchParam searchParam;

  ReportShoppingDashBoardData(
      {this.progressCharts,
        this.internalCharts,
        this.projectCharts,
        this.searchParam});

  ReportShoppingDashBoardData.fromJson(Map<String, dynamic> json) {
    if (json['ProgressChart'] != null) {
      progressCharts = new List<ProgressChart>();
      json['ProgressChart'].forEach((v) {
        progressCharts.add(new ProgressChart.fromJson(v));
      });
    }
    if (json['InternalChart'] != null) {
      internalCharts = new List<InternalChart>();
      json['InternalChart'].forEach((v) {
        internalCharts.add(new InternalChart.fromJson(v));
      });
    }
    if (json['ProjectChart'] != null) {
      projectCharts = new List<ProjectChart>();
      json['ProjectChart'].forEach((v) {
        projectCharts.add(new ProjectChart.fromJson(v));
      });
    }
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.progressCharts != null) {
      data['ProgressChart'] =
          this.progressCharts.map((v) => v.toJson()).toList();
    }
    if (this.internalCharts != null) {
      data['InternalChart'] =
          this.internalCharts.map((v) => v.toJson()).toList();
    }
    if (this.projectCharts != null) {
      data['ProjectChart'] = this.projectCharts.map((v) => v.toJson()).toList();
    }
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class ProgressChart {
  int iD;
  String name;
  Actual actual;
  Plan plan;

  ProgressChart({this.iD, this.name, this.actual, this.plan});

  ProgressChart.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    actual =
    json['Actual'] != null ? new Actual.fromJson(json['Actual']) : null;
    plan = json['Plan'] != null ? new Plan.fromJson(json['Plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    if (this.actual != null) {
      data['Actual'] = this.actual.toJson();
    }
    if (this.plan != null) {
      data['Plan'] = this.plan.toJson();
    }
    return data;
  }
}

class Actual {
  double value;
  String color;

  Actual({this.value, this.color});

  Actual.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Color'] = this.color;
    return data;
  }
}

class Plan {
  double value;
  String color;

  Plan({this.value, this.color});

  Plan.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Color'] = this.color;
    return data;
  }
}

class InternalChart {
  int iD;
  String name;
  double value;
  double percent;
  String color;

  InternalChart({this.iD, this.name, this.value, this.percent, this.color});

  InternalChart.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    value = json['Value'];
    percent = json['Percent'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Value'] = this.value;
    data['Percent'] = this.percent;
    data['Color'] = this.color;
    return data;
  }
}

class ProjectChart {
  int iD;
  String name;
  double value;
  double percent;
  String color;

  ProjectChart({this.iD, this.name, this.value, this.percent, this.color});

  ProjectChart.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    value = json['Value'];
    percent = json['Percent'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Value'] = this.value;
    data['Percent'] = this.percent;
    data['Color'] = this.color;
    return data;
  }
}

class SearchParam {
  int iDDept;
  int quarter;
  int year;
  List<Dept> dept;
  List<Years> years;
  List<Quarters> quarters;

  SearchParam(
      {this.iDDept,
        this.quarter,
        this.year,
        this.dept,
        this.years,
        this.quarters});

  SearchParam.fromJson(Map<String, dynamic> json) {
    iDDept = json['IDDept'];
    quarter = json['Quarter'];
    year = json['Year'];
    if (json['Dept'] != null) {
      dept = new List<Dept>();
      json['Dept'].forEach((v) {
        dept.add(new Dept.fromJson(v));
      });
    }
    if (json['Years'] != null) {
      years = new List<Years>();
      json['Years'].forEach((v) {
        years.add(new Years.fromJson(v));
      });
    }
    if (json['Quarters'] != null) {
      quarters = new List<Quarters>();
      json['Quarters'].forEach((v) {
        quarters.add(new Quarters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDDept'] = this.iDDept;
    data['Quarter'] = this.quarter;
    data['Year'] = this.year;
    if (this.dept != null) {
      data['Dept'] = this.dept.map((v) => v.toJson()).toList();
    }
    if (this.years != null) {
      data['Years'] = this.years.map((v) => v.toJson()).toList();
    }
    if (this.quarters != null) {
      data['Quarters'] = this.quarters.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dept extends SelectModel {
  int iD;
  String key;
  bool isEnable;

  Dept();

  Dept.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class Years extends SelectModel {
  int iD;
  String key;
  bool isEnable;

  Years();

  Years.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}

class Quarters extends SelectModel {
  int iD;
  String key;
  bool isEnable;

  Quarters();

  Quarters.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    key = json['Key'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Key'] = this.key;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}
