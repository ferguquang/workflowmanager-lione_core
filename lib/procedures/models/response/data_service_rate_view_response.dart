import 'package:workflow_manager/base/models/base_response.dart';

class DataServiceRateViewResponse extends BaseResponse {
  int status;
  DataServiceRateView data;

  DataServiceRateViewResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DataServiceRateView.fromJson(json['Data'])
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

class DataServiceRateView {
  int iDServiceRecord;
  int iDService;
  int isRegisterView;
  List<FilterStyles> filterStyles;
  Star star;
  List<RateStars> rateStars;
  List<RateRecords> rateRecords;
  int pageSize;
  int pageIndex;
  int pageTotal;

  DataServiceRateView(
      {this.iDServiceRecord,
      this.iDService,
      this.isRegisterView,
      this.filterStyles,
      this.star,
      this.rateStars,
      this.rateRecords,
      this.pageSize,
      this.pageIndex,
      this.pageTotal});

  DataServiceRateView.fromJson(Map<String, dynamic> json) {
    iDServiceRecord = json['IDServiceRecord'];
    iDService = json['IDService'];
    isRegisterView = json['IsRegisterView'];
    if (json['FilterStyles'] != null) {
      filterStyles = new List<FilterStyles>();
      json['FilterStyles'].forEach((v) {
        filterStyles.add(new FilterStyles.fromJson(v));
      });
    }
    star = json['Star'] != null ? new Star.fromJson(json['Star']) : null;
    if (json['RateStars'] != null) {
      rateStars = new List<RateStars>();
      json['RateStars'].forEach((v) {
        rateStars.add(new RateStars.fromJson(v));
      });
    }
    if (json['RateRecords'] != null) {
      rateRecords = new List<RateRecords>();
      json['RateRecords'].forEach((v) {
        rateRecords.add(new RateRecords.fromJson(v));
      });
    }
    pageSize = json['PageSize'];
    pageIndex = json['PageIndex'];
    pageTotal = json['PageTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDServiceRecord'] = this.iDServiceRecord;
    data['IDService'] = this.iDService;
    data['IsRegisterView'] = this.isRegisterView;
    if (this.filterStyles != null) {
      data['FilterStyles'] = this.filterStyles.map((v) => v.toJson()).toList();
    }
    if (this.star != null) {
      data['Star'] = this.star.toJson();
    }
    if (this.rateStars != null) {
      data['RateStars'] = this.rateStars.map((v) => v.toJson()).toList();
    }
    if (this.rateRecords != null) {
      data['RateRecords'] = this.rateRecords.map((v) => v.toJson()).toList();
    }
    data['PageSize'] = this.pageSize;
    data['PageIndex'] = this.pageIndex;
    data['PageTotal'] = this.pageTotal;
    return data;
  }
}

class FilterStyles {
  int iDServiceRecord;
  int iDService;
  int isRegisterView;
  int state;
  String action;
  int total;

  FilterStyles(
      {this.iDServiceRecord,
      this.iDService,
      this.isRegisterView,
      this.state,
      this.action,
      this.total});

  FilterStyles.fromJson(Map<String, dynamic> json) {
    iDServiceRecord = json['IDServiceRecord'];
    iDService = json['IDService'];
    isRegisterView = json['IsRegisterView'];
    state = json['State'];
    action = json['Action'];
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDServiceRecord'] = this.iDServiceRecord;
    data['IDService'] = this.iDService;
    data['IsRegisterView'] = this.isRegisterView;
    data['State'] = this.state;
    data['Action'] = this.action;
    data['Total'] = this.total;
    return data;
  }
}

class Star {
  double star;
  int numberEval;
  String title;

  Star({this.star, this.numberEval, this.title});

  Star.fromJson(Map<String, dynamic> json) {
    star = json['Star'];
    numberEval = json['NumberEval'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Star'] = this.star;
    data['NumberEval'] = this.numberEval;
    data['Title'] = this.title;
    return data;
  }
}

class RateStars {
  int star;
  double percent;
  String title;

  RateStars({this.star, this.percent, this.title});

  RateStars.fromJson(Map<String, dynamic> json) {
    star = json['Star'];
    percent = json['Percent'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Star'] = this.star;
    data['Percent'] = this.percent;
    data['Title'] = this.title;
    return data;
  }
}

class RateRecords {
  CreatedBy createdBy;
  Dept dept;
  int star;
  String content;
  String dateTimeDisplay;

  RateRecords(
      {this.createdBy,
      this.dept,
      this.star,
      this.content,
      this.dateTimeDisplay});

  RateRecords.fromJson(Map<String, dynamic> json) {
    createdBy = json['CreatedBy'] != null
        ? new CreatedBy.fromJson(json['CreatedBy'])
        : null;
    dept = json['Dept'] != null ? new Dept.fromJson(json['Dept']) : null;
    star = json['Star'];
    content = json['Content'];
    dateTimeDisplay = json['DateTimeDisplay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.createdBy != null) {
      data['CreatedBy'] = this.createdBy.toJson();
    }
    if (this.dept != null) {
      data['Dept'] = this.dept.toJson();
    }
    data['Star'] = this.star;
    data['Content'] = this.content;
    data['DateTimeDisplay'] = this.dateTimeDisplay;
    return data;
  }
}

class CreatedBy {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  int iDDept;

  CreatedBy(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    iDDept = json['IDDept'];
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
    return data;
  }
}

class Dept {
  int iD;
  String name;
  String describe;

  Dept({this.iD, this.name, this.describe});

  Dept.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    return data;
  }
}
