import 'package:workflow_manager/base/models/base_response.dart';

class OverViewResponse extends BaseResponse {
  DataOverView data;

  OverViewResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data =
        json['Data'] != null ? new DataOverView.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }

    return data;
  }
}

class DataOverView {
  double planTotal;
  String planTotalMoney;
  double actualTotal;
  String actualTotalMoney;
  double commitTotal;
  String commitTotalMoney;
  String actualColor;
  double percent;
  List<ProjectQuaterChartInfos> projectBarChartInfos;
  List<ProjectQuaterChartInfos> projectQuaterChartInfos;
  List<ProjectQuaterChartInfos> projectPieChartChiNhanh;
  List<ProjectQuaterChartInfos> projectPieChartPB;
  List<ProjectQuaterChartInfos> sourceBarChartInfos;
  List<ProjectQuaterChartInfos> campaignBarChartInfos;
  SearchParam searchParam;
  List<ColorNotes> colorNotes;
  String urlSaleTarget;
  String businessTargetMoney;

  DataOverView(
      {this.planTotal,
      this.planTotalMoney,
      this.actualTotal,
      this.actualTotalMoney,
      this.commitTotal,
      this.commitTotalMoney,
      this.actualColor,
      this.percent,
      this.projectBarChartInfos,
      this.projectQuaterChartInfos,
      this.projectPieChartChiNhanh,
      this.projectPieChartPB,
      this.sourceBarChartInfos,
      this.campaignBarChartInfos,
      this.searchParam,
      this.urlSaleTarget,
      this.businessTargetMoney,
      this.colorNotes});

  DataOverView.fromJson(Map<String, dynamic> json) {
    businessTargetMoney = json['BusinessTargetMoney'];
    planTotal = json['PlanTotal'];
    planTotalMoney = json['PlanTotalMoney'];
    actualTotal = json['ActualTotal'];
    actualTotalMoney = json['ActualTotalMoney'];
    commitTotal = json['CommitTotal'];
    commitTotalMoney = json['CommitTotalMoney'];
    actualColor = json['ActualColor'];
    percent = json['Percent'];
    urlSaleTarget = json['UrlSaleTarget'];
    if (json['ProjectBarChartInfos'] != null) {
      projectBarChartInfos = new List<ProjectQuaterChartInfos>();
      json['ProjectBarChartInfos'].forEach((v) {
        projectBarChartInfos.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
    if (json['ProjectQuaterChartInfos'] != null) {
      projectQuaterChartInfos = new List<ProjectQuaterChartInfos>();
      json['ProjectQuaterChartInfos'].forEach((v) {
        projectQuaterChartInfos.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
    if (json['ProjectPieChartChiNhanh'] != null) {
      projectPieChartChiNhanh = new List<ProjectQuaterChartInfos>();
      json['ProjectPieChartChiNhanh'].forEach((v) {
        projectPieChartChiNhanh.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
    if (json['ProjectPieChartPB'] != null) {
      projectPieChartPB = new List<ProjectQuaterChartInfos>();
      json['ProjectPieChartPB'].forEach((v) {
        projectPieChartPB.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
    if (json['SourceBarChartInfos'] != null) {
      sourceBarChartInfos = new List<ProjectQuaterChartInfos>();
      json['SourceBarChartInfos'].forEach((v) {
        sourceBarChartInfos.add(new ProjectQuaterChartInfos.fromJson(v));
      });
    }
    if (json['CampaignBarChartInfos'] != null) {
      campaignBarChartInfos = new List<ProjectQuaterChartInfos>();
      json['CampaignBarChartInfos'].forEach((v) {
        campaignBarChartInfos.add(new ProjectQuaterChartInfos.fromJson(v));
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
    data['BusinessTargetMoney'] = this.businessTargetMoney;
    data['PlanTotal'] = this.planTotal;
    data['PlanTotalMoney'] = this.planTotalMoney;
    data['ActualTotal'] = this.actualTotal;
    data['ActualTotalMoney'] = this.actualTotalMoney;
    data['CommitTotal'] = this.commitTotal;
    data['CommitTotalMoney'] = this.commitTotalMoney;
    data['ActualColor'] = this.actualColor;
    data['Percent'] = this.percent;
    data['UrlSaleTarget'] = this.urlSaleTarget;
    if (this.projectBarChartInfos != null) {
      data['ProjectBarChartInfos'] =
          this.projectBarChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.projectQuaterChartInfos != null) {
      data['ProjectQuaterChartInfos'] =
          this.projectQuaterChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.projectPieChartChiNhanh != null) {
      data['ProjectPieChartChiNhanh'] =
          this.projectPieChartChiNhanh.map((v) => v.toJson()).toList();
    }
    if (this.projectPieChartPB != null) {
      data['ProjectPieChartPB'] =
          this.projectPieChartPB.map((v) => v.toJson()).toList();
    }
    if (this.sourceBarChartInfos != null) {
      data['SourceBarChartInfos'] =
          this.sourceBarChartInfos.map((v) => v.toJson()).toList();
    }
    if (this.campaignBarChartInfos != null) {
      data['CampaignBarChartInfos'] =
          this.campaignBarChartInfos.map((v) => v.toJson()).toList();
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

class ProjectQuaterChartInfos {
  String lable;
  double actual;
  String actualStr;
  double committed;
  String committedStr;
  double plan;
  String planStr;
  String actualColor;
  double percent;
  bool isHeader = false;
  String year = '';

  ProjectQuaterChartInfos(
      {this.lable,
      this.actual,
      this.actualStr,
      this.committed,
      this.committedStr,
      this.plan,
      this.planStr,
      this.actualColor,
      this.percent,
      this.isHeader,
      this.year});

  ProjectQuaterChartInfos.fromJson(Map<String, dynamic> json) {
    lable = json['Lable'];
    actual = json['Actual'];
    actualStr = json['ActualStr'];
    committed = json['Committed'];
    committedStr = json['CommittedStr'];
    plan = json['Plan'];
    planStr = json['PlanStr'];
    actualColor = json['ActualColor'];
    percent = json['Percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Lable'] = this.lable;
    data['Actual'] = this.actual;
    data['ActualStr'] = this.actualStr;
    data['Committed'] = this.committed;
    data['CommittedStr'] = this.committedStr;
    data['Plan'] = this.plan;
    data['PlanStr'] = this.planStr;
    data['ActualColor'] = this.actualColor;
    data['Percent'] = this.percent;
    return data;
  }
}

// class này dùng chung
class SearchParam {
  List<Seller> seller;
  List<int> years;
  List<DateTypes> dateTypes;
  List<DateTypes> quarters;
  List<DateTypes> months;
  List<DateTypes> provinces;

  List<Categories> categories;

  List<DateTypes> listYear = [];
  String startDate = '';
  String endDate = '';

  SearchParam(
      {this.seller,
      this.years,
      this.dateTypes,
      this.quarters,
      this.months,
      this.provinces,
      this.categories});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Categories'] != null) {
      categories = new List<Categories>();
      json['Categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['Seller'] != null) {
      seller = new List<Seller>();
      json['Seller'].forEach((v) {
        seller.add(new Seller.fromJson(v));
      });
    }
    years = json['Years'].cast<int>();
    if (json['DateTypes'] != null) {
      dateTypes = new List<DateTypes>();
      json['DateTypes'].forEach((v) {
        dateTypes.add(new DateTypes.fromJson(v));
      });
    }
    if (json['Quarters'] != null) {
      quarters = new List<DateTypes>();
      json['Quarters'].forEach((v) {
        quarters.add(new DateTypes.fromJson(v));
      });
    }
    if (json['Months'] != null) {
      months = new List<DateTypes>();
      json['Months'].forEach((v) {
        months.add(new DateTypes.fromJson(v));
      });
    }
    if (json['Provinces'] != null) {
      provinces = new List<DateTypes>();
      json['Provinces'].forEach((v) {
        provinces.add(new DateTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['Categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.seller != null) {
      data['Seller'] = this.seller.map((v) => v.toJson()).toList();
    }
    data['Years'] = this.years;
    if (this.dateTypes != null) {
      data['DateTypes'] = this.dateTypes.map((v) => v.toJson()).toList();
    }
    if (this.quarters != null) {
      data['Quarters'] = this.quarters.map((v) => v.toJson()).toList();
    }
    if (this.months != null) {
      data['Months'] = this.months.map((v) => v.toJson()).toList();
    }
    if (this.provinces != null) {
      data['Provinces'] = this.provinces.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seller {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  String deptName;
  int iDDept;
  bool isSelected = false;

  Seller(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept,
      this.deptName,
      this.isSelected});

  Seller.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    iDDept = json['IDDept'];
    deptName = json['DeptName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Avatar'] = this.avatar;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['IDDept'] = this.iDDept;
    data['DeptName'] = this.deptName;
    return data;
  }
}

class DateTypes {
  String text;
  int value;
  bool isSelected = false;

  DateTypes({this.text, this.value, this.isSelected});

  DateTypes.fromJson(Map<String, dynamic> json) {
    text = json['Text'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Text'] = this.text;
    data['Value'] = this.value;
    return data;
  }
}

class ColorNotes {
  String name;
  String color;
  List<ColorNotes> percentNotes;

  ColorNotes({this.name, this.color, this.percentNotes});

  ColorNotes.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    color = json['Color'];
    if (json['PercentNotes'] != null) {
      percentNotes = new List<ColorNotes>();
      json['PercentNotes'].forEach((v) {
        percentNotes.add(new ColorNotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Color'] = this.color;
    if (this.percentNotes != null) {
      data['PercentNotes'] = this.percentNotes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int iD;
  String key;
  String name;
  bool isEnable;
  bool isSelected = false;

  Categories({this.iD, this.key, this.name, this.isEnable, this.isSelected});

  Categories.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    key = json['Key'];
    name = json['Name'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Key'] = this.key;
    data['Name'] = this.name;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}
