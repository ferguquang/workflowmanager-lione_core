import 'package:workflow_manager/base/models/base_response.dart';

class ContractListResponse extends BaseResponse {
  int status;
  ContractListModel data;

  ContractListResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new ContractListModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class ContractListModel {
  List<Contracts> contracts;
  int totalRecord;
  SearchParam searchParam;

  ContractListModel({this.contracts, this.totalRecord, this.searchParam});

  ContractListModel.fromJson(Map<String, dynamic> json) {
    if (json['contracts'] != null) {
      contracts = new List<Contracts>();
      json['contracts'].forEach((v) {
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
      data['contracts'] = this.contracts.map((v) => v.toJson()).toList();
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
  String pONumber;
  String requisition;
  String paymentMethod;
  double totalAmount;
  String currency;
  Status status;

  Contracts(
      {this.iD,
      this.project,
      this.pONumber,
      this.requisition,
      this.paymentMethod,
      this.totalAmount,
      this.currency,
      this.status});

  Contracts.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    project = json['Project'];
    pONumber = json['PONumber'];
    requisition = json['Requisition'];
    paymentMethod = json['PaymentMethod'];
    totalAmount = json['TotalAmount'];
    currency = json['Currency'];
    status =
        json['Status'] != null ? new Status.fromJson(json['Status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Project'] = this.project;
    data['PONumber'] = this.pONumber;
    data['Requisition'] = this.requisition;
    data['PaymentMethod'] = this.paymentMethod;
    data['TotalAmount'] = this.totalAmount;
    data['Currency'] = this.currency;
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    return data;
  }
}

class Status {
  int iD;
  String name;
  String bgColor;

  Status({this.iD, this.name, this.bgColor});

  Status.fromJson(Map<String, dynamic> json) {
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
  List<Requisitions> requisitions;
  List<PONumbers> pONumbers;
  List<Status> status;

  SearchParam({this.projects, this.requisitions, this.pONumbers, this.status});

  SearchParam.fromJson(Map<String, dynamic> json) {
    if (json['Projects'] != null) {
      projects = new List<Projects>();
      json['Projects'].forEach((v) {
        projects.add(new Projects.fromJson(v));
      });
    }
    if (json['Requisitions'] != null) {
      requisitions = new List<Requisitions>();
      json['Requisitions'].forEach((v) {
        requisitions.add(new Requisitions.fromJson(v));
      });
    }
    if (json['PONumbers'] != null) {
      pONumbers = new List<PONumbers>();
      json['PONumbers'].forEach((v) {
        pONumbers.add(new PONumbers.fromJson(v));
      });
    }
    if (json['Status'] != null) {
      status = new List<Status>();
      json['Status'].forEach((v) {
        status.add(new Status.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projects != null) {
      data['Projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    if (this.requisitions != null) {
      data['Requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    if (this.pONumbers != null) {
      data['PONumbers'] = this.pONumbers.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['Status'] = this.status.map((v) => v.toJson()).toList();
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

class Requisitions {
  String iD;
  String name;
  String key;
  bool isEnable;

  Requisitions({this.iD, this.name, this.key, this.isEnable});

  Requisitions.fromJson(Map<String, dynamic> json) {
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

class PONumbers {
  int iD;
  String name;
  String key;
  bool isEnable;

  PONumbers({this.iD, this.name, this.key, this.isEnable});

  PONumbers.fromJson(Map<String, dynamic> json) {
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
