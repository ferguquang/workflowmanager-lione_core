import 'package:workflow_manager/base/models/base_response.dart';

class PaymentProgressResponse extends BaseResponse {
  int status;
  PaymentProgressModel data;

  PaymentProgressResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new PaymentProgressModel.fromJson(json['Data'])
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

class PaymentProgressModel {
  List<Contracts> contracts;
  int totalRecord;
  SearchParam searchParam;

  PaymentProgressModel({this.contracts, this.totalRecord, this.searchParam});

  PaymentProgressModel.fromJson(Map<String, dynamic> json) {
    if (json['Contracts'] != null) {
      contracts = new List<Contracts>();
      json['Contracts'].forEach((v) {
        contracts.add(new Contracts.fromJson(v));
      });
    }
    totalRecord = json['TotalRecord'];
    searchParam = json['SearchParam'] != null
        ? new SearchParam.fromJson(json['SearchParam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contracts != null) {
      data['Contracts'] = this.contracts.map((v) => v.toJson()).toList();
    }
    data['TotalRecord'] = this.totalRecord;
    if (this.searchParam != null) {
      data['SearchParam'] = this.searchParam.toJson();
    }
    return data;
  }
}

class Contracts {
  int iD;
  String project;
  String requisitionNumber;
  String pONumber;
  int signDate;
  String provider;
  String totalAmount;
  String currency;
  Satus status;
  bool isView;
  bool isUpdate;

  Contracts(
      {this.iD,
      this.project,
      this.requisitionNumber,
      this.pONumber,
      this.signDate,
      this.provider,
      this.totalAmount,
      this.currency,
      this.status,
      this.isView,
      this.isUpdate});

  Contracts.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    project = json['Project'];
    requisitionNumber = json['RequisitionNumber'];
    pONumber = json['PONumber'];
    signDate = json['SignDate'];
    provider = json['Provider'];
    totalAmount = json['TotalAmount'];
    currency = json['Currency'];
    status = json['Satus'] != null ? new Satus.fromJson(json['Satus']) : null;
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Project'] = this.project;
    data['RequisitionNumber'] = this.requisitionNumber;
    data['PONumber'] = this.pONumber;
    data['SignDate'] = this.signDate;
    data['Provider'] = this.provider;
    data['TotalAmount'] = this.totalAmount;
    data['Currency'] = this.currency;
    if (this.status != null) {
      data['Satus'] = this.status.toJson();
    }
    data['IsView'] = this.isView;
    data['IsUpdate'] = this.isUpdate;
    return data;
  }
}

class Satus {
  int iD;
  String name;
  String bgColor;

  Satus({this.iD, this.name, this.bgColor});

  Satus.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    bgColor = json['BgColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['BgColor'] = this.bgColor;
    return data;
  }
}

class SearchParam {
  List<Projects> projects;
  List<PRCodes> pRCodes;
  List<POCodes> pOCodes;
  List<Statuses> statuses;

  SearchParam({this.projects, this.pRCodes, this.pOCodes, this.statuses});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Projects'] != null) {
      projects = new List<Projects>();
      json['Projects'].forEach((v) {
        projects.add(new Projects.fromJson(v));
      });
    }
    if (json['PRCodes'] != null) {
      pRCodes = new List<PRCodes>();
      json['PRCodes'].forEach((v) {
        pRCodes.add(new PRCodes.fromJson(v));
      });
    }
    if (json['POCodes'] != null) {
      pOCodes = new List<POCodes>();
      json['POCodes'].forEach((v) {
        pOCodes.add(new POCodes.fromJson(v));
      });
    }
    if (json['Statuses'] != null) {
      statuses = new List<Statuses>();
      json['Statuses'].forEach((v) {
        statuses.add(new Statuses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projects != null) {
      data['Projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    if (this.pRCodes != null) {
      data['PRCodes'] = this.pRCodes.map((v) => v.toJson()).toList();
    }
    if (this.pOCodes != null) {
      data['POCodes'] = this.pOCodes.map((v) => v.toJson()).toList();
    }
    if (this.statuses != null) {
      data['Statuses'] = this.statuses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Projects {
  int iD;
  String name;
  String key;
  bool isEnable;

  Projects({this.iD, this.name, this.key, this.isEnable});

  Projects.fromJson(Map<String, dynamic> json) {
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

class PRCodes {
  String iD;
  String name;
  String key;
  bool isEnable;

  PRCodes({this.iD, this.name, this.key, this.isEnable});

  PRCodes.fromJson(Map<String, dynamic> json) {
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

class POCodes {
  String iD;
  String name;
  String key;
  bool isEnable;

  POCodes({this.iD, this.name, this.key, this.isEnable});

  POCodes.fromJson(Map<String, dynamic> json) {
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

class Statuses {
  int iD;
  String name;
  String key;
  bool isEnable;

  Statuses({this.iD, this.name, this.key, this.isEnable});

  Statuses.fromJson(Map<String, dynamic> json) {
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
