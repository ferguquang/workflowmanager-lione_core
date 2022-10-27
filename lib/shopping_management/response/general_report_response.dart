import 'package:workflow_manager/base/models/base_response.dart';

class GeneralReportResponse extends BaseResponse {
  int status;
  GeneralReportModel data;

  GeneralReportResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new GeneralReportModel.fromJson(json['Data'])
        : null;
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

class GeneralReportModel {
  List<Report> report;
  int totalRecord;
  SearchParam searchParam;

  GeneralReportModel({this.report, this.totalRecord, this.searchParam});

  GeneralReportModel.fromJson(Map<String, dynamic> json) {
    if (json['Report'] != null) {
      report = new List<Report>();
      json['Report'].forEach((v) {
        report.add(new Report.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['Report'] = this.report.map((v) => v.toJson()).toList();
    }
    data['TotalRecord'] = this.totalRecord;
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class Report {
  String projectCode;
  String projectName;
  String investor;
  String category;
  double totalAmount;
  int totalCount;

  Report(
      {this.projectCode,
      this.projectName,
      this.investor,
      this.totalAmount,
      this.totalCount,
      this.category});

  Report.fromJson(Map<String, dynamic> json) {
    projectCode = json['ProjectCode'];
    projectName = json['ProjectName'];
    investor = json['Investor'];
    totalAmount = json['TotalAmount'];
    totalCount = json['TotalCount'];
    category = json['Category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProjectCode'] = this.projectCode;
    data['ProjectName'] = this.projectName;
    data['Investor'] = this.investor;
    data['TotalAmount'] = this.totalAmount;
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class SearchParam {
  List<SearchObject> dept;
  List<SearchObject> projects;
  List<SearchObject> years;
  List<SearchObject> quarter;
  List<SearchObject> suggestTypes;
  List<SearchObject> shoppingTypes;
  List<SearchObject> categories;

  SearchParam(
      {this.dept,
      this.projects,
      this.years,
      this.quarter,
      this.suggestTypes,
      this.shoppingTypes});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Dept'] != null) {
      dept = new List<SearchObject>();
      json['Dept'].forEach((v) {
        dept.add(new SearchObject.fromJson(v));
      });
    }
    if (json['Projects'] != null) {
      projects = new List<SearchObject>();
      json['Projects'].forEach((v) {
        projects.add(new SearchObject.fromJson(v));
      });
    }
    if (json['Years'] != null) {
      years = new List<SearchObject>();
      json['Years'].forEach((v) {
        years.add(new SearchObject.fromJson(v));
      });
    }
    if (json['Quarter'] != null) {
      quarter = new List<SearchObject>();
      json['Quarter'].forEach((v) {
        quarter.add(new SearchObject.fromJson(v));
      });
    }
    if (json['SuggestTypes'] != null) {
      suggestTypes = new List<SearchObject>();
      json['SuggestTypes'].forEach((v) {
        suggestTypes.add(new SearchObject.fromJson(v));
      });
    }
    if (json['ShoppingTypes'] != null) {
      shoppingTypes = new List<SearchObject>();
      json['ShoppingTypes'].forEach((v) {
        shoppingTypes.add(new SearchObject.fromJson(v));
      });
    }
    if (json['Categories'] != null) {
      categories = new List<SearchObject>();
      json['Categories'].forEach((v) {
        categories.add(new SearchObject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dept != null) {
      data['Dept'] = this.dept.map((v) => v.toJson()).toList();
    }
    if (this.projects != null) {
      data['Projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    if (this.years != null) {
      data['Years'] = this.years.map((v) => v.toJson()).toList();
    }
    if (this.quarter != null) {
      data['Quarter'] = this.quarter.map((v) => v.toJson()).toList();
    }
    if (this.suggestTypes != null) {
      data['SuggestTypes'] = this.suggestTypes.map((v) => v.toJson()).toList();
    }
    if (this.shoppingTypes != null) {
      data['ShoppingTypes'] =
          this.shoppingTypes.map((v) => v.toJson()).toList();
    }
    if (this.shoppingTypes != null) {
      data['Categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchObject {
  int iD;
  String name;
  String key;
  bool isEnable;

  SearchObject({this.iD, this.name, this.key, this.isEnable});

  SearchObject.fromJson(Map<String, dynamic> json) {
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
